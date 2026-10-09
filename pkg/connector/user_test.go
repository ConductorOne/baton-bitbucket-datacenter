package connector

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"net/http"
	"net/http/httptest"
	"strings"
	"sync"
	"testing"

	"github.com/conductorone/baton-bitbucket-datacenter/pkg/client"
	v2 "github.com/conductorone/baton-sdk/pb/c1/connector/v2"
	"github.com/conductorone/baton-sdk/pkg/annotations"
	"github.com/grpc-ecosystem/go-grpc-middleware/logging/zap/ctxzap"
	"go.uber.org/zap"
	"go.uber.org/zap/zapcore"
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

// validCredentialOptions returns CredentialOptions requesting a random password of the
// given length, the shape C1 sends when CreateAccountCapabilityDetails advertises
// RANDOM_PASSWORD.
func validCredentialOptions(length int64) *v2.CredentialOptions {
	return &v2.CredentialOptions{
		Options: &v2.CredentialOptions_RandomPassword_{
			RandomPassword: &v2.CredentialOptions_RandomPassword{
				Length: length,
			},
		},
	}
}

// userServer builds a mock Bitbucket admin/users endpoint, seeded with existingUser (if
// non-nil). POSTing a name that's already known responds 409; any other name is recorded
// as a newly created user (reflecting the displayName/emailAddress sent on create) and
// responds 204, matching the real create-then-GET flow CreateAccount relies on. Username
// matching (both the create conflict check and the GET filter lookup) is case-insensitive,
// mirroring Bitbucket's own case-insensitive usernames. lastPassword, if non-nil, is set to
// the password query parameter observed on every create POST (including ones that 409),
// so tests can compare it against the PlaintextData CreateAccount returns.
func userServer(t *testing.T, existingUser *client.User, lastAddToDefaultGroup, lastPassword *string) *httptest.Server {
	t.Helper()

	var mu sync.Mutex
	users := map[string]client.User{} // keyed by strings.ToLower(Name)
	if existingUser != nil {
		users[strings.ToLower(existingUser.Name)] = *existingUser
	}

	return httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		switch {
		case r.Method == http.MethodPost && r.URL.Path == "/rest/api/latest/admin/users":
			if lastAddToDefaultGroup != nil {
				*lastAddToDefaultGroup = r.URL.Query().Get("addToDefaultGroup")
			}
			if lastPassword != nil {
				*lastPassword = r.URL.Query().Get("password")
			}
			name := r.URL.Query().Get("name")

			mu.Lock()
			defer mu.Unlock()
			if _, ok := users[strings.ToLower(name)]; ok {
				w.WriteHeader(http.StatusConflict)
				return
			}
			users[strings.ToLower(name)] = client.User{
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
			if u, ok := users[strings.ToLower(filter)]; ok {
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
		var seenPassword string
		srv := userServer(t, nil, nil, &seenPassword)
		defer srv.Close()
		u := newTestUserBuilder(t, srv)

		accountInfo := accountInfoFromProfile(t, map[string]any{
			"login":        "jdoe",
			"display_name": "Jane Doe",
			"email":        "jane@example.com",
		})

		resp, plaintext, _, err := u.CreateAccount(context.Background(), accountInfo, validCredentialOptions(24))
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
		if seenPassword == "" {
			t.Fatal("expected the mock server to observe a generated password")
		}
		if len(plaintext) != 1 || plaintext[0].Name != "password" {
			t.Fatalf("expected a single %q PlaintextData entry, got %+v", "password", plaintext)
		}
		if string(plaintext[0].Bytes) != seenPassword {
			t.Fatalf("PlaintextData bytes = %q, want the password sent to Bitbucket %q", plaintext[0].Bytes, seenPassword)
		}
	})

	t.Run("409 same email is idempotent success", func(t *testing.T) {
		existing := &client.User{Name: "jdoe", DisplayName: "Jane Doe", EmailAddress: "Jane@Example.com", Active: true, Type: "NORMAL"}
		srv := userServer(t, existing, nil, nil)
		defer srv.Close()
		u := newTestUserBuilder(t, srv)

		accountInfo := accountInfoFromProfile(t, map[string]any{
			"login":        "jdoe",
			"display_name": "Jane Doe",
			"email":        "jane@example.com", // differs only in case from the existing user
		})

		resp, plaintext, _, err := u.CreateAccount(context.Background(), accountInfo, validCredentialOptions(24))
		if err != nil {
			t.Fatalf("CreateAccount: %v", err)
		}
		if _, ok := resp.(*v2.CreateAccountResponse_SuccessResult); !ok {
			t.Fatalf("expected SuccessResult, got %T", resp)
		}
		// The existing account's password was never touched on this idempotent 409 path -
		// returning the freshly generated (and unused) password here would hand back a
		// credential that does not actually work.
		if len(plaintext) != 0 {
			t.Fatalf("expected no PlaintextData on a 409 idempotent success, got %+v", plaintext)
		}
	})

	t.Run("409 case-insensitive login match with same email is idempotent success", func(t *testing.T) {
		existing := &client.User{Name: "jdoe", DisplayName: "Jane Doe", EmailAddress: "jane@example.com", Active: true, Type: "NORMAL"}
		srv := userServer(t, existing, nil, nil)
		defer srv.Close()
		u := newTestUserBuilder(t, srv)

		accountInfo := accountInfoFromProfile(t, map[string]any{
			"login":        "JDoe", // differs only in case from the existing user's name
			"display_name": "Jane Doe",
			"email":        "jane@example.com",
		})

		resp, _, _, err := u.CreateAccount(context.Background(), accountInfo, validCredentialOptions(24))
		if err != nil {
			t.Fatalf("CreateAccount: %v", err)
		}
		if _, ok := resp.(*v2.CreateAccountResponse_SuccessResult); !ok {
			t.Fatalf("expected SuccessResult, got %T", resp)
		}
	})

	t.Run("409 followed by an empty lookup is an error naming the login", func(t *testing.T) {
		srv := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			switch {
			case r.Method == http.MethodPost && r.URL.Path == "/rest/api/latest/admin/users":
				w.WriteHeader(http.StatusConflict)
			case r.Method == http.MethodGet && r.URL.Path == "/rest/api/latest/users":
				w.Header().Set("Content-Type", "application/json")
				_ = json.NewEncoder(w).Encode(client.UsersAPIData{IsLastPage: true})
			default:
				t.Fatalf("unexpected request: %s %s", r.Method, r.URL.String())
			}
		}))
		defer srv.Close()
		u := newTestUserBuilder(t, srv)

		accountInfo := accountInfoFromProfile(t, map[string]any{
			"login":        "jdoe",
			"display_name": "Jane Doe",
			"email":        "jane@example.com",
		})

		_, _, _, err := u.CreateAccount(context.Background(), accountInfo, validCredentialOptions(24))
		if err == nil {
			t.Fatal("expected an error, got nil")
		}
		if !strings.Contains(err.Error(), "jdoe") {
			t.Fatalf("expected error to name the login %q, got: %v", "jdoe", err)
		}
	})

	// A fresh create (204) already set the generated password server-side, so a failed or
	// empty post-create lookup must not discard it: CreateAccount still succeeds, building
	// the resource from the known fields and returning the password as PlaintextData.
	for _, tt := range []struct {
		name   string
		lookup func(w http.ResponseWriter)
	}{
		{name: "fresh create followed by an empty lookup still returns the password", lookup: func(w http.ResponseWriter) {
			w.Header().Set("Content-Type", "application/json")
			_ = json.NewEncoder(w).Encode(client.UsersAPIData{IsLastPage: true})
		}},
		{name: "fresh create followed by a failed lookup still returns the password", lookup: func(w http.ResponseWriter) {
			w.WriteHeader(http.StatusBadRequest)
		}},
	} {
		t.Run(tt.name, func(t *testing.T) {
			var seenPassword string
			srv := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
				switch {
				case r.Method == http.MethodPost && r.URL.Path == "/rest/api/latest/admin/users":
					seenPassword = r.URL.Query().Get("password")
					w.WriteHeader(http.StatusNoContent)
				case r.Method == http.MethodGet && r.URL.Path == "/rest/api/latest/users":
					tt.lookup(w)
				default:
					t.Fatalf("unexpected request: %s %s", r.Method, r.URL.String())
				}
			}))
			defer srv.Close()
			u := newTestUserBuilder(t, srv)

			accountInfo := accountInfoFromProfile(t, map[string]any{
				"login":        "jdoe",
				"display_name": "Jane Doe",
				"email":        "jane@example.com",
			})

			resp, plaintext, _, err := u.CreateAccount(context.Background(), accountInfo, validCredentialOptions(24))
			if err != nil {
				t.Fatalf("CreateAccount: %v", err)
			}
			success, ok := resp.(*v2.CreateAccountResponse_SuccessResult)
			if !ok {
				t.Fatalf("expected SuccessResult, got %T", resp)
			}
			if got := success.Resource.GetId().GetResource(); got != "jdoe" {
				t.Fatalf("resource ID = %q, want %q", got, "jdoe")
			}
			if seenPassword == "" {
				t.Fatal("expected the mock server to observe a generated password")
			}
			if len(plaintext) != 1 || plaintext[0].Name != "password" {
				t.Fatalf("expected a single %q PlaintextData entry, got %+v", "password", plaintext)
			}
			if string(plaintext[0].Bytes) != seenPassword {
				t.Fatalf("PlaintextData bytes = %q, want the password sent to Bitbucket %q", plaintext[0].Bytes, seenPassword)
			}
		})
	}

	t.Run("409 different email is AlreadyExists, no secrets", func(t *testing.T) {
		existing := &client.User{Name: "jdoe", DisplayName: "Someone Else", EmailAddress: "someone.else@example.com", Active: true, Type: "NORMAL"}
		var seenPassword string
		srv := userServer(t, existing, nil, &seenPassword)
		defer srv.Close()
		u := newTestUserBuilder(t, srv)

		accountInfo := accountInfoFromProfile(t, map[string]any{
			"login":        "jdoe",
			"display_name": "Jane Doe",
			"email":        "jane@example.com",
		})

		resp, plaintext, _, err := u.CreateAccount(context.Background(), accountInfo, validCredentialOptions(24))
		if err == nil {
			t.Fatalf("expected an error, got success: %+v", resp)
		}
		if code := status.Code(err); code != codes.AlreadyExists {
			t.Fatalf("expected codes.AlreadyExists, got %s (%v)", code, err)
		}
		if len(plaintext) != 0 {
			t.Fatalf("expected no PlaintextData on error, got %+v", plaintext)
		}
		if seenPassword == "" {
			t.Fatal("expected the mock server to observe a generated password")
		}
		if strings.Contains(err.Error(), seenPassword) {
			t.Fatalf("password leaked via error: %v", err)
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
			srv := userServer(t, nil, nil, nil)
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
			srv := userServer(t, nil, &seen, nil)
			defer srv.Close()
			u := newTestUserBuilder(t, srv)

			accountInfo := accountInfoFromProfile(t, map[string]any{
				"login":                "jdoe",
				"display_name":         "Jane Doe",
				"email":                "jane@example.com",
				"add_to_default_group": tt.want,
			})

			_, _, _, err := u.CreateAccount(context.Background(), accountInfo, validCredentialOptions(24))
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

	t.Run("add_to_default_group string true is accepted", func(t *testing.T) {
		var seen string
		srv := userServer(t, nil, &seen, nil)
		defer srv.Close()
		u := newTestUserBuilder(t, srv)

		accountInfo := accountInfoFromProfile(t, map[string]any{
			"login":                "jdoe",
			"display_name":         "Jane Doe",
			"email":                "jane@example.com",
			"add_to_default_group": "true", // string, not bool
		})

		_, _, _, err := u.CreateAccount(context.Background(), accountInfo, validCredentialOptions(24))
		if err != nil {
			t.Fatalf("CreateAccount: %v", err)
		}
		if seen != "true" {
			t.Fatalf("addToDefaultGroup query param = %q, want %q", seen, "true")
		}
	})

	for _, tt := range []struct {
		name  string
		value any
	}{
		{name: "add_to_default_group unparseable string is InvalidArgument", value: "yes-please"},
		{name: "add_to_default_group wrong type is InvalidArgument", value: 123},
	} {
		t.Run(tt.name, func(t *testing.T) {
			srv := userServer(t, nil, nil, nil)
			defer srv.Close()
			u := newTestUserBuilder(t, srv)

			accountInfo := accountInfoFromProfile(t, map[string]any{
				"login":                "jdoe",
				"display_name":         "Jane Doe",
				"email":                "jane@example.com",
				"add_to_default_group": tt.value,
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
}

func TestUserBuilder_CreateAccountCapabilityDetails(t *testing.T) {
	srv := userServer(t, nil, nil, nil)
	defer srv.Close()
	u := newTestUserBuilder(t, srv)

	details, _, err := u.CreateAccountCapabilityDetails(context.Background())
	if err != nil {
		t.Fatalf("CreateAccountCapabilityDetails: %v", err)
	}

	want := v2.CapabilityDetailCredentialOption_CAPABILITY_DETAIL_CREDENTIAL_OPTION_RANDOM_PASSWORD
	if details.GetPreferredCredentialOption() != want {
		t.Fatalf("PreferredCredentialOption = %s, want %s", details.GetPreferredCredentialOption(), want)
	}
	if len(details.GetSupportedCredentialOptions()) != 1 || details.GetSupportedCredentialOptions()[0] != want {
		t.Fatalf("SupportedCredentialOptions = %v, want [%s]", details.GetSupportedCredentialOptions(), want)
	}
}

func TestCreateAccount_CredentialOptions_InvalidArgument(t *testing.T) {
	tests := []struct {
		name              string
		credentialOptions *v2.CredentialOptions
	}{
		{name: "nil credential options", credentialOptions: nil},
		{name: "random password length below minimum", credentialOptions: validCredentialOptions(7)},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			srv := userServer(t, nil, nil, nil)
			defer srv.Close()
			u := newTestUserBuilder(t, srv)

			accountInfo := accountInfoFromProfile(t, map[string]any{
				"login":        "jdoe",
				"display_name": "Jane Doe",
				"email":        "jane@example.com",
			})

			_, plaintext, _, err := u.CreateAccount(context.Background(), accountInfo, tt.credentialOptions)
			if err == nil {
				t.Fatal("expected an error, got nil")
			}
			if code := status.Code(err); code != codes.InvalidArgument {
				t.Fatalf("expected codes.InvalidArgument, got %s (%v)", code, err)
			}
			if len(plaintext) != 0 {
				t.Fatalf("expected no PlaintextData on error, got %+v", plaintext)
			}
		})
	}
}

// TestCreateAccount_GeneratePassword_Internal drives CreateAccount through a
// non-sentinel generatePassword failure (e.g. crypto/rand itself failing, which the
// real crypto.GeneratePassword has no way to simulate on demand) via the generatePassword
// seam, and asserts it maps to codes.Internal rather than codes.InvalidArgument, and that
// the error never leaks a password (there isn't one to leak: generation failed first).
func TestCreateAccount_GeneratePassword_Internal(t *testing.T) {
	srv := userServer(t, nil, nil, nil)
	defer srv.Close()
	u := newTestUserBuilder(t, srv)

	original := generatePassword
	wantErr := errors.New("crypto/rand: entropy source unavailable")
	generatePassword = func(*v2.CredentialOptions) (string, error) {
		return "", wantErr
	}
	defer func() { generatePassword = original }()

	accountInfo := accountInfoFromProfile(t, map[string]any{
		"login":        "jdoe",
		"display_name": "Jane Doe",
		"email":        "jane@example.com",
	})

	_, plaintext, _, err := u.CreateAccount(context.Background(), accountInfo, validCredentialOptions(24))
	if err == nil {
		t.Fatal("expected an error, got nil")
	}
	if code := status.Code(err); code != codes.Internal {
		t.Fatalf("expected codes.Internal, got %s (%v)", code, err)
	}
	if !strings.Contains(err.Error(), wantErr.Error()) {
		t.Fatalf("expected error to mention %q, got %v", wantErr, err)
	}
	if len(plaintext) != 0 {
		t.Fatalf("expected no PlaintextData on error, got %+v", plaintext)
	}
}

// capturingCore is a minimal zapcore.Core that records every logged message and field as
// strings, so tests can assert a secret never appears in anything logged through it.
type capturingCore struct {
	mu      sync.Mutex
	entries []string
}

func newCapturingCore() *capturingCore { return &capturingCore{} }

func (c *capturingCore) Enabled(zapcore.Level) bool { return true }
func (c *capturingCore) With([]zapcore.Field) zapcore.Core {
	return c
}
func (c *capturingCore) Check(ent zapcore.Entry, ce *zapcore.CheckedEntry) *zapcore.CheckedEntry {
	return ce.AddCore(ent, c)
}
func (c *capturingCore) Write(ent zapcore.Entry, fields []zapcore.Field) error {
	enc := zapcore.NewMapObjectEncoder()
	for _, f := range fields {
		f.AddTo(enc)
	}
	c.mu.Lock()
	defer c.mu.Unlock()
	c.entries = append(c.entries, ent.Message, fmt.Sprintf("%v", enc.Fields))
	return nil
}
func (c *capturingCore) Sync() error { return nil }

func (c *capturingCore) contains(s string) bool {
	c.mu.Lock()
	defer c.mu.Unlock()
	for _, entry := range c.entries {
		if strings.Contains(entry, s) {
			return true
		}
	}
	return false
}

// TestCreateAccount_PasswordNeverLogged drives CreateAccount through two failure paths that
// occur after a password has already been generated and sent to Bitbucket (a 409 for a
// different email, and a 409 followed by an empty post-create lookup), and asserts the
// generated password appears in neither the returned error nor any log record emitted via
// the request's context logger.
func TestCreateAccount_PasswordNeverLogged(t *testing.T) {
	assertNoLeak := func(t *testing.T, err error, core *capturingCore, seenPassword string) {
		t.Helper()
		if seenPassword == "" {
			t.Fatal("expected the mock server to observe a generated password")
		}
		if err != nil && strings.Contains(err.Error(), seenPassword) {
			t.Fatalf("password leaked via error: %v", err)
		}
		if core.contains(seenPassword) {
			t.Fatalf("password leaked via a log record")
		}
	}

	t.Run("409 different email", func(t *testing.T) {
		core := newCapturingCore()
		ctx := ctxzap.ToContext(context.Background(), zap.New(core))

		existing := &client.User{Name: "jdoe", DisplayName: "Someone Else", EmailAddress: "someone.else@example.com", Active: true, Type: "NORMAL"}
		var seenPassword string
		srv := userServer(t, existing, nil, &seenPassword)
		defer srv.Close()
		u := newTestUserBuilder(t, srv)

		accountInfo := accountInfoFromProfile(t, map[string]any{
			"login":        "jdoe",
			"display_name": "Jane Doe",
			"email":        "jane@example.com",
		})

		_, _, _, err := u.CreateAccount(ctx, accountInfo, validCredentialOptions(24))
		if err == nil {
			t.Fatal("expected an error, got nil")
		}
		assertNoLeak(t, err, core, seenPassword)
	})

	t.Run("409 followed by an empty lookup", func(t *testing.T) {
		core := newCapturingCore()
		ctx := ctxzap.ToContext(context.Background(), zap.New(core))

		var seenPassword string
		srv := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			switch {
			case r.Method == http.MethodPost && r.URL.Path == "/rest/api/latest/admin/users":
				seenPassword = r.URL.Query().Get("password")
				w.WriteHeader(http.StatusConflict)
			case r.Method == http.MethodGet && r.URL.Path == "/rest/api/latest/users":
				w.Header().Set("Content-Type", "application/json")
				_ = json.NewEncoder(w).Encode(client.UsersAPIData{IsLastPage: true})
			default:
				t.Fatalf("unexpected request: %s %s", r.Method, r.URL.String())
			}
		}))
		defer srv.Close()
		u := newTestUserBuilder(t, srv)

		accountInfo := accountInfoFromProfile(t, map[string]any{
			"login":        "jdoe",
			"display_name": "Jane Doe",
			"email":        "jane@example.com",
		})

		_, _, _, err := u.CreateAccount(ctx, accountInfo, validCredentialOptions(24))
		if err == nil {
			t.Fatal("expected an error, got nil")
		}
		assertNoLeak(t, err, core, seenPassword)
	})
}

// TestCreateAccount_BypassesStaleCache drives create -> delete -> create on the same login
// through the same client, using different emails each time, against a real uhttp-backed
// client (not a stub). uhttp caches GET responses in-memory for an hour keyed by request
// URL; since the post-create lookup always queries the same filter=<login> URL, a client
// that didn't clear that cache before looking up the freshly (re)created user would return
// the first create's cached response instead of the second, proving the ClearCaches call in
// CreateAccount is load-bearing and not just dead code.
func TestCreateAccount_BypassesStaleCache(t *testing.T) {
	var mu sync.Mutex
	users := map[string]client.User{}

	srv := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		switch {
		case r.Method == http.MethodPost && r.URL.Path == "/rest/api/latest/admin/users":
			name := r.URL.Query().Get("name")
			mu.Lock()
			defer mu.Unlock()
			if _, ok := users[strings.ToLower(name)]; ok {
				w.WriteHeader(http.StatusConflict)
				return
			}
			users[strings.ToLower(name)] = client.User{
				Name:         name,
				DisplayName:  r.URL.Query().Get("displayName"),
				EmailAddress: r.URL.Query().Get("emailAddress"),
				Active:       true,
				Type:         "NORMAL",
			}
			w.WriteHeader(http.StatusNoContent)
		case r.Method == http.MethodDelete && r.URL.Path == "/rest/api/latest/admin/users":
			name := r.URL.Query().Get("name")
			mu.Lock()
			delete(users, strings.ToLower(name))
			mu.Unlock()
			w.WriteHeader(http.StatusOK)
		case r.Method == http.MethodGet && r.URL.Path == "/rest/api/latest/users":
			filter := r.URL.Query().Get("filter")
			mu.Lock()
			var found []client.User
			if u, ok := users[strings.ToLower(filter)]; ok {
				found = append(found, u)
			}
			mu.Unlock()
			w.Header().Set("Content-Type", "application/json")
			_ = json.NewEncoder(w).Encode(client.UsersAPIData{IsLastPage: true, Users: found})
		default:
			t.Fatalf("unexpected request: %s %s", r.Method, r.URL.String())
		}
	}))
	defer srv.Close()

	u := newTestUserBuilder(t, srv)
	ctx := context.Background()

	createAndGetEmail := func(email string) string {
		t.Helper()
		accountInfo := accountInfoFromProfile(t, map[string]any{
			"login":        "jdoe",
			"display_name": "Jane Doe",
			"email":        email,
		})
		resp, _, _, err := u.CreateAccount(ctx, accountInfo, validCredentialOptions(24))
		if err != nil {
			t.Fatalf("CreateAccount(%s): %v", email, err)
		}
		success, ok := resp.(*v2.CreateAccountResponse_SuccessResult)
		if !ok {
			t.Fatalf("expected SuccessResult, got %T", resp)
		}
		var ut v2.UserTrait
		annos := annotations.Annotations(success.Resource.GetAnnotations())
		found, err := annos.Pick(&ut)
		if err != nil || !found {
			t.Fatalf("expected a UserTrait annotation on the resource, found=%v err=%v", found, err)
		}
		if len(ut.GetEmails()) == 0 {
			t.Fatal("expected at least one email on the user trait")
		}
		return ut.GetEmails()[0].GetAddress()
	}

	if got := createAndGetEmail("first@example.com"); got != "first@example.com" {
		t.Fatalf("first create email = %q, want %q", got, "first@example.com")
	}

	if _, err := u.Delete(ctx, &v2.ResourceId{ResourceType: "user", Resource: "jdoe"}); err != nil {
		t.Fatalf("Delete: %v", err)
	}

	if got := createAndGetEmail("second@example.com"); got != "second@example.com" {
		t.Fatalf("second create email = %q, want %q (stale cache not bypassed)", got, "second@example.com")
	}
}

func TestUserBuilder_Delete(t *testing.T) {
	tests := []struct {
		name       string
		statusCode int
		body       string
		wantErr    bool
	}{
		{
			name:       "200 OK is success",
			statusCode: http.StatusOK,
			body:       `{"errors":[{"message":"user is managed by an external directory"}]}`,
			wantErr:    false,
		},
		{
			name:       "204 No Content is success",
			statusCode: http.StatusNoContent,
			body:       `{"errors":[{"message":"user is managed by an external directory"}]}`,
			wantErr:    false,
		},
		{
			name:       "404 Not Found is treated as already-deleted success",
			statusCode: http.StatusNotFound,
			body:       `{"errorSummary":"com.atlassian.bitbucket.user.NoSuchUserException: User jdoe does not exist"}`,
			wantErr:    false,
		},
		{
			name:       "404 Not Found without NoSuchUserException is an error",
			statusCode: http.StatusNotFound,
			body:       `{"errorSummary":"blocked by proxy"}`,
			wantErr:    true,
		},
		{
			name:       "403 Forbidden is an error",
			statusCode: http.StatusForbidden,
			body:       `{"errors":[{"message":"user is managed by an external directory"}]}`,
			wantErr:    true,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			srv := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
				if r.Method != http.MethodDelete {
					t.Fatalf("unexpected method: %s", r.Method)
				}
				w.WriteHeader(tt.statusCode)
				_, _ = w.Write([]byte(tt.body))
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
