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
		wantErrCode codes.Code
	}{
		{
			name:      "absent key defaults to empty, not present",
			profile:   map[string]any{},
			key:       "login",
			wantValue: "",
		},
		{
			name:      "nil value treated as absent",
			profile:   map[string]any{"login": nil},
			key:       "login",
			wantValue: "",
		},
		{
			name:      "string value is returned and present",
			profile:   map[string]any{"login": "jdoe"},
			key:       "login",
			wantValue: "jdoe",
		},
		{
			name:      "empty string is still present",
			profile:   map[string]any{"login": ""},
			key:       "login",
			wantValue: "",
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
			value, err := callerString(tt.profile, tt.key)
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
		})
	}
}

func TestCallerBool(t *testing.T) {
	tests := []struct {
		name        string
		profile     map[string]any
		key         string
		wantValue   bool
		wantErrCode codes.Code
	}{
		{
			name:      "absent key defaults to false, not present",
			profile:   map[string]any{},
			key:       "add_to_default_group",
			wantValue: false,
		},
		{
			name:      "nil value treated as absent",
			profile:   map[string]any{"add_to_default_group": nil},
			key:       "add_to_default_group",
			wantValue: false,
		},
		{
			name:      "true value is returned and present",
			profile:   map[string]any{"add_to_default_group": true},
			key:       "add_to_default_group",
			wantValue: true,
		},
		{
			name:      "false value is returned and present",
			profile:   map[string]any{"add_to_default_group": false},
			key:       "add_to_default_group",
			wantValue: false,
		},
		{
			name:      "string true is parsed and present",
			profile:   map[string]any{"add_to_default_group": "true"},
			key:       "add_to_default_group",
			wantValue: true,
		},
		{
			name:      "string True is parsed case-insensitively",
			profile:   map[string]any{"add_to_default_group": "True"},
			key:       "add_to_default_group",
			wantValue: true,
		},
		{
			name:      "string with surrounding whitespace is parsed",
			profile:   map[string]any{"add_to_default_group": " false "},
			key:       "add_to_default_group",
			wantValue: false,
		},
		{
			name:        "unparseable string fails loudly with InvalidArgument",
			profile:     map[string]any{"add_to_default_group": "yes-please"},
			key:         "add_to_default_group",
			wantErrCode: codes.InvalidArgument,
		},
		{
			name:        "wrong type fails loudly with InvalidArgument",
			profile:     map[string]any{"add_to_default_group": 123},
			key:         "add_to_default_group",
			wantErrCode: codes.InvalidArgument,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			value, err := callerBool(tt.profile, tt.key)
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
		})
	}
}
