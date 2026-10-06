package connector

import (
	"testing"

	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

func TestCallerString(t *testing.T) {
	tests := []struct {
		name        string
		profile     map[string]any
		key         string
		wantValue   string
		wantPresent bool
		wantErrCode codes.Code
	}{
		{
			name:        "absent key defaults to empty, not present",
			profile:     map[string]any{},
			key:         "login",
			wantValue:   "",
			wantPresent: false,
		},
		{
			name:        "nil value treated as absent",
			profile:     map[string]any{"login": nil},
			key:         "login",
			wantValue:   "",
			wantPresent: false,
		},
		{
			name:        "string value is returned and present",
			profile:     map[string]any{"login": "jdoe"},
			key:         "login",
			wantValue:   "jdoe",
			wantPresent: true,
		},
		{
			name:        "empty string is still present",
			profile:     map[string]any{"login": ""},
			key:         "login",
			wantValue:   "",
			wantPresent: true,
		},
		{
			name:        "wrong type fails loudly with InvalidArgument",
			profile:     map[string]any{"login": 12345.0},
			key:         "login",
			wantErrCode: codes.InvalidArgument,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			value, present, err := callerString(tt.profile, tt.key)
			if tt.wantErrCode != codes.OK {
				if err == nil {
					t.Fatalf("expected error with code %s, got nil", tt.wantErrCode)
				}
				if code := status.Code(err); code != tt.wantErrCode {
					t.Fatalf("expected code %s, got %s (%v)", tt.wantErrCode, code, err)
				}
				return
			}
			if err != nil {
				t.Fatalf("unexpected error: %v", err)
			}
			if value != tt.wantValue {
				t.Errorf("value = %q, want %q", value, tt.wantValue)
			}
			if present != tt.wantPresent {
				t.Errorf("present = %v, want %v", present, tt.wantPresent)
			}
		})
	}
}

func TestCallerBool(t *testing.T) {
	tests := []struct {
		name        string
		profile     map[string]any
		key         string
		wantValue   bool
		wantPresent bool
		wantErrCode codes.Code
	}{
		{
			name:        "absent key defaults to false, not present",
			profile:     map[string]any{},
			key:         "add_to_default_group",
			wantValue:   false,
			wantPresent: false,
		},
		{
			name:        "nil value treated as absent",
			profile:     map[string]any{"add_to_default_group": nil},
			key:         "add_to_default_group",
			wantValue:   false,
			wantPresent: false,
		},
		{
			name:        "true value is returned and present",
			profile:     map[string]any{"add_to_default_group": true},
			key:         "add_to_default_group",
			wantValue:   true,
			wantPresent: true,
		},
		{
			name:        "false value is returned and present",
			profile:     map[string]any{"add_to_default_group": false},
			key:         "add_to_default_group",
			wantValue:   false,
			wantPresent: true,
		},
		{
			name:        "wrong type fails loudly with InvalidArgument",
			profile:     map[string]any{"add_to_default_group": "true"},
			key:         "add_to_default_group",
			wantErrCode: codes.InvalidArgument,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			value, present, err := callerBool(tt.profile, tt.key)
			if tt.wantErrCode != codes.OK {
				if err == nil {
					t.Fatalf("expected error with code %s, got nil", tt.wantErrCode)
				}
				if code := status.Code(err); code != tt.wantErrCode {
					t.Fatalf("expected code %s, got %s (%v)", tt.wantErrCode, code, err)
				}
				return
			}
			if err != nil {
				t.Fatalf("unexpected error: %v", err)
			}
			if value != tt.wantValue {
				t.Errorf("value = %v, want %v", value, tt.wantValue)
			}
			if present != tt.wantPresent {
				t.Errorf("present = %v, want %v", present, tt.wantPresent)
			}
		})
	}
}
