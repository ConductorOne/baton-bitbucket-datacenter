package connector

import (
	"context"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"sync"
	"testing"

	"github.com/conductorone/baton-bitbucket-datacenter/pkg/client"
	v2 "github.com/conductorone/baton-sdk/pb/c1/connector/v2"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
	"google.golang.org/protobuf/types/known/structpb"
)

func newTestUserBuilder(t *testing.T, srv *httptest.Server) *userBuilder {
	t.Helper()
	cli, err := client.New(context.Background(), srv.URL, &client.Auth{Username: "admin", Password: "admin-pw"})
	if err != nil {
		t.Fatalf("client.New: %v", err)
	}
	return newUserBuilder(cli, nil)
}

func accountInfoFromProfile(t *testing.T, profile map[string]any) *v2.AccountInfo {
	t.Helper()
	s, err := structpb.NewStruct(profile)
	if err != nil {
		t.Fatalf("structpb.NewStruct: %v", err)
	}
	return &v2.AccountInfo{Profile: s}
}

// userServer builds a mock Bitbucket admin/users endpoint, seeded with existingUser (if
// non-nil). POSTing a name that's already known responds 409; any other name is recorded
// as a newly created user (reflecting the displayName/emailAddress sent on create) and
// responds 204, matching the real create-then-GET flow CreateAccount relies on.
func userServer(t *testing.T, existingUser *client.User, lastAddToDefaultGroup *string) *httptest.Server {
	t.Helper()

	var mu sync.Mutex
	users := map[string]client.User{}
	if existingUser != nil {
		users[existingUser.Name] = *existingUser
	}

	return httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		switch {
		case r.Method == http.MethodPost && r.URL.Path == "/rest/api/latest/admin/users":
			if lastAddToDefaultGroup != nil {
				*lastAddToDefaultGroup = r.URL.Query().Get("addToDefaultGroup")
			}
			name := r.URL.Query().Get("name")

			mu.Lock()
			defer mu.Unlock()
			if _, ok := users[name]; ok {
				w.WriteHeader(http.StatusConflict)
				return
			}
			users[name] = client.User{
				Name:         name,
				DisplayName:  r.URL.Query().Get("displayName"),
				EmailAddress: r.URL.Query().Get("emailAddress"),
				Active:       true,
				Type:         "NORMAL",
			}
			w.WriteHeader(http.StatusNoContent)
		case r.Method == http.MethodGet && r.URL.Path == "/rest/api/latest/users":
			filter := r.URL.Query().Get("filter")

			mu.Lock()
			var found []client.User
			if u, ok := users[filter]; ok {
				found = append(found, u)
			}
			mu.Unlock()

			w.Header().Set("Content-Type", "application/json")
			_ = json.NewEncoder(w).Encode(client.UsersAPIData{
				IsLastPage: true,
				Users:      found,
			})
		default:
			t.Fatalf("unexpected request: %s %s", r.Method, r.URL.String())
		}
	}))
}

func TestCreateAccount(t *testing.T) {
	t.Run("success: fresh create", func(t *testing.T) {
		srv := userServer(t, nil, nil)
		defer srv.Close()
		u := newTestUserBuilder(t, srv)

		accountInfo := accountInfoFromProfile(t, map[string]any{
			"login":        "jdoe",
			"display_name": "Jane Doe",
			"email":        "jane@example.com",
		})

		resp, _, _, err := u.CreateAccount(context.Background(), accountInfo, nil)
		if err != nil {
			t.Fatalf("CreateAccount: %v", err)
		}
		success, ok := resp.(*v2.CreateAccountResponse_SuccessResult)
		if !ok {
			t.Fatalf("expected SuccessResult, got %T", resp)
		}
		if success.Resource == nil {
			t.Fatal("expected a resource on success")
		}
	})

	t.Run("409 same email is idempotent success", func(t *testing.T) {
		existing := &client.User{Name: "jdoe", DisplayName: "Jane Doe", EmailAddress: "Jane@Example.com", Active: true, Type: "NORMAL"}
		srv := userServer(t, existing, nil)
		defer srv.Close()
		u := newTestUserBuilder(t, srv)

		accountInfo := accountInfoFromProfile(t, map[string]any{
			"login":        "jdoe",
			"display_name": "Jane Doe",
			"email":        "jane@example.com", // differs only in case from the existing user
		})

		resp, _, _, err := u.CreateAccount(context.Background(), accountInfo, nil)
		if err != nil {
			t.Fatalf("CreateAccount: %v", err)
		}
		if _, ok := resp.(*v2.CreateAccountResponse_SuccessResult); !ok {
			t.Fatalf("expected SuccessResult, got %T", resp)
		}
	})

	t.Run("409 different email is AlreadyExists, no secrets", func(t *testing.T) {
		existing := &client.User{Name: "jdoe", DisplayName: "Someone Else", EmailAddress: "someone.else@example.com", Active: true, Type: "NORMAL"}
		srv := userServer(t, existing, nil)
		defer srv.Close()
		u := newTestUserBuilder(t, srv)

		accountInfo := accountInfoFromProfile(t, map[string]any{
			"login":        "jdoe",
			"display_name": "Jane Doe",
			"email":        "jane@example.com",
		})

		resp, _, _, err := u.CreateAccount(context.Background(), accountInfo, nil)
		if err == nil {
			t.Fatalf("expected an error, got success: %+v", resp)
		}
		if code := status.Code(err); code != codes.AlreadyExists {
			t.Fatalf("expected codes.AlreadyExists, got %s (%v)", code, err)
		}
	})

	for _, tt := range []struct {
		name    string
		profile map[string]any
	}{
		{name: "missing login", profile: map[string]any{"display_name": "Jane Doe", "email": "jane@example.com"}},
		{name: "missing display_name", profile: map[string]any{"login": "jdoe", "email": "jane@example.com"}},
		{name: "missing email", profile: map[string]any{"login": "jdoe", "display_name": "Jane Doe"}},
	} {
		t.Run(tt.name, func(t *testing.T) {
			srv := userServer(t, nil, nil)
			defer srv.Close()
			u := newTestUserBuilder(t, srv)

			accountInfo := accountInfoFromProfile(t, tt.profile)
			_, _, _, err := u.CreateAccount(context.Background(), accountInfo, nil)
			if err == nil {
				t.Fatal("expected an error, got nil")
			}
			if code := status.Code(err); code != codes.InvalidArgument {
				t.Fatalf("expected codes.InvalidArgument, got %s (%v)", code, err)
			}
		})
	}

	for _, tt := range []struct {
		name string
		want bool
	}{
		{name: "add_to_default_group true reaches the query", want: true},
		{name: "add_to_default_group false reaches the query", want: false},
	} {
		t.Run(tt.name, func(t *testing.T) {
			var seen string
			srv := userServer(t, nil, &seen)
			defer srv.Close()
			u := newTestUserBuilder(t, srv)

			accountInfo := accountInfoFromProfile(t, map[string]any{
				"login":                "jdoe",
				"display_name":         "Jane Doe",
				"email":                "jane@example.com",
				"add_to_default_group": tt.want,
			})

			_, _, _, err := u.CreateAccount(context.Background(), accountInfo, nil)
			if err != nil {
				t.Fatalf("CreateAccount: %v", err)
			}
			wantStr := "false"
			if tt.want {
				wantStr = "true"
			}
			if seen != wantStr {
				t.Fatalf("addToDefaultGroup query param = %q, want %q", seen, wantStr)
			}
		})
	}

	t.Run("add_to_default_group wrong type is InvalidArgument", func(t *testing.T) {
		srv := userServer(t, nil, nil)
		defer srv.Close()
		u := newTestUserBuilder(t, srv)

		accountInfo := accountInfoFromProfile(t, map[string]any{
			"login":                "jdoe",
			"display_name":         "Jane Doe",
			"email":                "jane@example.com",
			"add_to_default_group": "true", // string, not bool
		})

		_, _, _, err := u.CreateAccount(context.Background(), accountInfo, nil)
		if err == nil {
			t.Fatal("expected an error, got nil")
		}
		if code := status.Code(err); code != codes.InvalidArgument {
			t.Fatalf("expected codes.InvalidArgument, got %s (%v)", code, err)
		}
	})
}

func TestUserBuilder_Delete(t *testing.T) {
	tests := []struct {
		name       string
		statusCode int
		wantErr    bool
	}{
		{name: "200 OK is success", statusCode: http.StatusOK, wantErr: false},
		{name: "204 No Content is success", statusCode: http.StatusNoContent, wantErr: false},
		{name: "404 Not Found is treated as already-deleted success", statusCode: http.StatusNotFound, wantErr: false},
		{name: "403 Forbidden is an error", statusCode: http.StatusForbidden, wantErr: true},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			srv := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
				if r.Method != http.MethodDelete {
					t.Fatalf("unexpected method: %s", r.Method)
				}
				w.WriteHeader(tt.statusCode)
				_, _ = w.Write([]byte(`{"errors":[{"message":"user is managed by an external directory"}]}`))
			}))
			defer srv.Close()

			u := newTestUserBuilder(t, srv)
			_, err := u.Delete(context.Background(), &v2.ResourceId{ResourceType: "user", Resource: "jdoe"})

			if tt.wantErr && err == nil {
				t.Fatal("expected an error, got nil")
			}
			if !tt.wantErr && err != nil {
				t.Fatalf("unexpected error: %v", err)
			}
		})
	}
}
