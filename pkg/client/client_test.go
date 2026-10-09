package client

import (
	"context"
	"errors"
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"
	"time"

	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

const testPassword = "SuperSecretPassword123!@#"

func newTestClient(t *testing.T, srv *httptest.Server) *DataCenterClient {
	t.Helper()
	cli, err := New(context.Background(), srv.URL, &Auth{Username: "admin", Password: "admin-pw"})
	if err != nil {
		t.Fatalf("New: %v", err)
	}
	return cli
}

// assertNoPassword fails the test if err (in any form reachable from it) contains the
// plaintext password used to drive the request.
func assertNoPassword(t *testing.T, err error) {
	t.Helper()
	if err == nil {
		t.Fatal("expected a non-nil error")
	}
	if strings.Contains(err.Error(), testPassword) {
		t.Fatalf("password leaked via err.Error(): %v", err)
	}
	var bbErr *BitbucketError
	if errors.As(err, &bbErr) {
		if strings.Contains(bbErr.ErrorMessage, testPassword) {
			t.Fatalf("password leaked via ErrorMessage: %q", bbErr.ErrorMessage)
		}
		if strings.Contains(bbErr.ErrorLink, testPassword) {
			t.Fatalf("password leaked via ErrorLink: %q", bbErr.ErrorLink)
		}
		if strings.Contains(bbErr.ErrorDescription, testPassword) {
			t.Fatalf("password leaked via ErrorDescription: %q", bbErr.ErrorDescription)
		}
		if strings.Contains(bbErr.ErrorSummary, testPassword) {
			t.Fatalf("password leaked via ErrorSummary: %q", bbErr.ErrorSummary)
		}
		if bbErr.ErrorLink != "" {
			t.Fatalf("expected ErrorLink to be scrubbed, got %q", bbErr.ErrorLink)
		}
	}
}

func TestCreateUser_Success(t *testing.T) {
	srv := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		if r.Method != http.MethodPost || r.URL.Path != "/"+adminUsersEndpoint {
			t.Fatalf("unexpected request: %s %s", r.Method, r.URL.Path)
		}
		w.WriteHeader(http.StatusNoContent)
	}))
	defer srv.Close()

	cli := newTestClient(t, srv)
	if err := cli.CreateUser(context.Background(), "jdoe", testPassword, "Jane Doe", "jane@example.com", false); err != nil {
		t.Fatalf("CreateUser: %v", err)
	}
}

func TestCreateUser_Conflict_NoPasswordLeak(t *testing.T) {
	srv := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(http.StatusConflict)
		_, _ = w.Write([]byte(`{"errors":[{"message":"A user with that name already exists"}]}`))
	}))
	defer srv.Close()

	cli := newTestClient(t, srv)
	err := cli.CreateUser(context.Background(), "jdoe", testPassword, "Jane Doe", "jane@example.com", false)
	assertNoPassword(t, err)

	if !IsAlreadyExistsError(err) {
		t.Fatalf("expected IsAlreadyExistsError to be true, got err: %v", err)
	}
}

func TestCreateUser_TransportTimeout_NoPasswordLeak(t *testing.T) {
	srv := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		time.Sleep(200 * time.Millisecond)
		w.WriteHeader(http.StatusNoContent)
	}))
	defer srv.Close()

	cli := newTestClient(t, srv)

	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Millisecond)
	defer cancel()

	err := cli.CreateUser(ctx, "jdoe", testPassword, "Jane Doe", "jane@example.com", false)
	assertNoPassword(t, err)
}

func TestCreateUser_OtherError_NoPasswordLeak(t *testing.T) {
	srv := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(http.StatusForbidden)
		_, _ = w.Write([]byte(`{"errors":[{"message":"XSRF check failed"}]}`))
	}))
	defer srv.Close()

	cli := newTestClient(t, srv)
	err := cli.CreateUser(context.Background(), "jdoe", testPassword, "Jane Doe", "jane@example.com", false)
	assertNoPassword(t, err)

	var bbErr *BitbucketError
	if !errors.As(err, &bbErr) {
		t.Fatalf("expected a *BitbucketError, got %T: %v", err, err)
	}
	if bbErr.ErrorCode != http.StatusForbidden {
		t.Fatalf("ErrorCode = %d, want %d", bbErr.ErrorCode, http.StatusForbidden)
	}
	if got := status.Code(err); got != codes.PermissionDenied {
		t.Fatalf("status.Code(err) = %v, want %v", got, codes.PermissionDenied)
	}
}

func TestDeleteUser(t *testing.T) {
	tests := []struct {
		name         string
		statusCode   int
		wantErr      bool
		wantNotFound bool
		wantCode     codes.Code
	}{
		{name: "200 OK is success", statusCode: http.StatusOK, wantErr: false},
		{name: "204 No Content is success", statusCode: http.StatusNoContent, wantErr: false},
		{name: "404 Not Found reports IsNotFoundError", statusCode: http.StatusNotFound, wantErr: true, wantNotFound: true, wantCode: codes.NotFound},
		{name: "403 Forbidden is an error", statusCode: http.StatusForbidden, wantErr: true, wantCode: codes.PermissionDenied},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			srv := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
				if r.Method != http.MethodDelete {
					t.Fatalf("unexpected method: %s", r.Method)
				}
				w.WriteHeader(tt.statusCode)
			}))
			defer srv.Close()

			cli := newTestClient(t, srv)
			err := cli.DeleteUser(context.Background(), "jdoe")

			if tt.wantErr && err == nil {
				t.Fatal("expected an error, got nil")
			}
			if !tt.wantErr && err != nil {
				t.Fatalf("unexpected error: %v", err)
			}
			if tt.wantNotFound && !IsNotFoundError(err) {
				t.Fatalf("expected IsNotFoundError to be true, got err: %v", err)
			}
			if tt.wantErr {
				if got := status.Code(err); got != tt.wantCode {
					t.Fatalf("status.Code(err) = %v, want %v", got, tt.wantCode)
				}
			}
		})
	}
}
