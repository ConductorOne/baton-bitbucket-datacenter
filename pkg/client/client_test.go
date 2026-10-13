package client

import (
	"bytes"
	"context"
	"encoding/json"
	"errors"
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"
	"time"

	"github.com/conductorone/baton-sdk/pkg/pagination"
	"github.com/grpc-ecosystem/go-grpc-middleware/logging/zap/ctxzap"
	"go.uber.org/zap"
	"go.uber.org/zap/zapcore"
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

// TestBitbucketError_GRPCStatus_ZeroValueIsUnknown pins that a BitbucketError built
// without an explicit Code (codes.OK is the zero value) reports Unknown rather than OK.
func TestBitbucketError_GRPCStatus_ZeroValueIsUnknown(t *testing.T) {
	err := &BitbucketError{ErrorMessage: "boom"}
	if got := status.Code(err); got != codes.Unknown {
		t.Fatalf("status.Code(err) = %v, want %v", got, codes.Unknown)
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

	// A transport error (no HTTP response at all) must still carry the code uhttp
	// derived for it, not fall back to codes.Unknown.
	if got := status.Code(err); got != codes.DeadlineExceeded {
		t.Fatalf("status.Code(err) = %v, want %v", got, codes.DeadlineExceeded)
	}
}

func TestCreateUser_200_and_201_AreSuccess(t *testing.T) {
	for _, statusCode := range []int{http.StatusOK, http.StatusCreated} {
		t.Run(http.StatusText(statusCode), func(t *testing.T) {
			srv := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
				w.WriteHeader(statusCode)
			}))
			defer srv.Close()

			cli := newTestClient(t, srv)
			if err := cli.CreateUser(context.Background(), "jdoe", testPassword, "Jane Doe", "jane@example.com", false); err != nil {
				t.Fatalf("CreateUser: %v", err)
			}
		})
	}
}

func TestCreateUser_5xx_MapsToUnavailable(t *testing.T) {
	srv := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(http.StatusInternalServerError)
	}))
	defer srv.Close()

	cli := newTestClient(t, srv)
	err := cli.CreateUser(context.Background(), "jdoe", testPassword, "Jane Doe", "jane@example.com", false)
	assertNoPassword(t, err)

	if got := status.Code(err); got != codes.Unavailable {
		t.Fatalf("status.Code(err) = %v, want %v", got, codes.Unavailable)
	}
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
		{name: "503 Service Unavailable maps to Unavailable", statusCode: http.StatusServiceUnavailable, wantErr: true, wantCode: codes.Unavailable},
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

// TestGetUsers_SyncPathErrorsAlwaysUnknown pins that generic sync-path calls (anything going
// through d.Do -> GetCustomErr without a provisioning-specific code override) surface
// codes.Unknown regardless of HTTP status. A status-derived code such as codes.NotFound would
// make the syncer's isWarning treat the failure as "skip this resource" instead of failing
// the sync. See GetCustomErr.
func TestGetUsers_SyncPathErrorsAlwaysUnknown(t *testing.T) {
	tests := []struct {
		name       string
		statusCode int
	}{
		{name: "404 Not Found", statusCode: http.StatusNotFound},
		{name: "403 Forbidden", statusCode: http.StatusForbidden},
		{name: "503 Service Unavailable", statusCode: http.StatusServiceUnavailable},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			srv := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
				if r.Method != http.MethodGet {
					t.Fatalf("unexpected method: %s", r.Method)
				}
				w.WriteHeader(tt.statusCode)
			}))
			defer srv.Close()

			cli := newTestClient(t, srv)
			_, _, err := cli.GetUsers(context.Background(), &pagination.Token{})
			if err == nil {
				t.Fatal("expected an error, got nil")
			}
			if got := status.Code(err); got != codes.Unknown {
				t.Fatalf("status.Code(err) = %v, want %v (sync-path errors must stay Unknown, see GetCustomErr): %v", got, codes.Unknown, err)
			}
		})
	}
}

// TestCreateUser_DoesNotLogPassword drives CreateUser through a real zap logger (wired
// the same way production does, via ctxzap) and asserts the generated password never
// reaches it, across a success and two error responses. It also drives GetUsers through
// the same logger to prove the client's logging is actually wired up, so the absence of
// the password above isn't just an artifact of nothing being logged at all.
func TestCreateUser_DoesNotLogPassword(t *testing.T) {
	const probePassword = "S3cr3t-Probe-Pw" //nolint:gosec // test fixture, not a real credential

	var buf bytes.Buffer
	core := zapcore.NewCore(
		zapcore.NewJSONEncoder(zap.NewProductionEncoderConfig()),
		zapcore.Lock(zapcore.AddSync(&buf)),
		zapcore.DebugLevel,
	)
	logger := zap.New(core)
	ctx := ctxzap.ToContext(context.Background(), logger)

	for _, tt := range []struct {
		name       string
		statusCode int
	}{
		{name: "204 success", statusCode: http.StatusNoContent},
		{name: "409 conflict", statusCode: http.StatusConflict},
		{name: "500 server error", statusCode: http.StatusInternalServerError},
	} {
		srv := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			w.WriteHeader(tt.statusCode)
		}))
		defer srv.Close()

		cli, err := New(ctx, srv.URL, &Auth{Username: "admin", Password: "admin-pw"})
		if err != nil {
			t.Fatalf("New: %v", err)
		}

		// Error is expected for 409/500; only the log output is under test here.
		_ = cli.CreateUser(ctx, "jdoe", probePassword, "Jane Doe", "jane@example.com", false)

		if strings.Contains(buf.String(), probePassword) {
			t.Fatalf("%s: password leaked into logs:\n%s", tt.name, buf.String())
		}
	}

	// Transport-error case: a closed server fails the request before any HTTP response
	// exists. This is the case the transport logger flag doesn't gate: BaseHttpClient.Do
	// logs the raw *url.Error unconditionally, and that error's text carries the request
	// URL, including the password query parameter.
	transportSrv := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {}))
	transportSrv.Close()

	transportCli, err := New(ctx, transportSrv.URL, &Auth{Username: "admin", Password: "admin-pw"})
	if err != nil {
		t.Fatalf("New: %v", err)
	}

	transportErr := transportCli.CreateUser(ctx, "jdoe", probePassword, "Jane Doe", "jane@example.com", false)
	if transportErr == nil {
		t.Fatal("expected a transport error from a closed server")
	}
	if strings.Contains(buf.String(), probePassword) {
		t.Fatalf("transport error: password leaked into logs:\n%s", buf.String())
	}
	if strings.Contains(transportErr.Error(), probePassword) {
		t.Fatalf("transport error: password leaked into returned error: %v", transportErr)
	}
	if strings.Contains(transportErr.Error(), transportSrv.URL) {
		t.Fatalf("transport error: request URL leaked into returned error: %v", transportErr)
	}

	// A normal, logged request must still produce log output through the same logger,
	// proving the logger is actually wired and the assertions above aren't vacuous.
	usersSrv := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		_ = json.NewEncoder(w).Encode(UsersAPIData{IsLastPage: true})
	}))
	defer usersSrv.Close()

	cli, err := New(ctx, usersSrv.URL, &Auth{Username: "admin", Password: "admin-pw"})
	if err != nil {
		t.Fatalf("New: %v", err)
	}

	preLen := buf.Len()
	if _, _, err := cli.GetUsers(ctx, &pagination.Token{}); err != nil {
		t.Fatalf("GetUsers: %v", err)
	}
	if buf.Len() == preLen {
		t.Fatal("expected GetUsers to produce log output, but the logger stayed silent")
	}
}
