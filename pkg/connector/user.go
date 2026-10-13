package connector

import (
	"context"
	"errors"
	"fmt"
	"slices"
	"strings"

	"github.com/conductorone/baton-bitbucket-datacenter/pkg/client"
	v2 "github.com/conductorone/baton-sdk/pb/c1/connector/v2"
	"github.com/conductorone/baton-sdk/pkg/annotations"
	"github.com/conductorone/baton-sdk/pkg/connectorbuilder"
	"github.com/conductorone/baton-sdk/pkg/crypto"
	"github.com/conductorone/baton-sdk/pkg/pagination"
	rs "github.com/conductorone/baton-sdk/pkg/types/resource"
	"github.com/conductorone/baton-sdk/pkg/uhttp"
	"github.com/grpc-ecosystem/go-grpc-middleware/logging/zap/ctxzap"
	"go.uber.org/zap"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

// generatePassword is a seam over crypto.GeneratePassword so tests can simulate the
// non-sentinel error path (e.g. a crypto/rand failure), which the real implementation
// only produces via the unfakeable system entropy source.
var generatePassword = crypto.GeneratePassword

func userResource(_ context.Context, user *client.User, parentResourceID *v2.ResourceId, opts []rs.ResourceOption) (*v2.Resource, error) {
	displayName := user.DisplayName
	if displayName == "" {
		displayName = user.Name
	}
	if displayName == "" {
		displayName = user.EmailAddress
	}
	firstName, lastName := rs.SplitFullName(displayName)

	profile := map[string]interface{}{
		"login":        user.Slug,
		"first_name":   firstName,
		"last_name":    lastName,
		"email":        user.EmailAddress,
		"user_id":      user.ID,
		"user_slug":    user.Slug,
		"display_name": user.DisplayName,
		"user_type":    user.Type,
	}

	userStatus := v2.Status_RESOURCE_STATUS_ENABLED
	if !user.Active {
		userStatus = v2.Status_RESOURCE_STATUS_DISABLED
	}

	userTraits := []rs.UserTraitOption{
		rs.WithUserLogin(user.Name),
		rs.WithEmail(user.EmailAddress, true),
	}

	switch user.Type {
	case "NORMAL":
		userTraits = append(userTraits, rs.WithAccountType(v2.UserTrait_ACCOUNT_TYPE_HUMAN))
	case "SERVICE":
		userTraits = append(userTraits, rs.WithAccountType(v2.UserTrait_ACCOUNT_TYPE_SERVICE))
	}

	ret, err := rs.NewUserResource(
		displayName,
		resourceTypeUser,
		user.Name,
		userTraits,
		append([]rs.ResourceOption{
			rs.WithResourceProfile(profile),
			rs.WithResourceStatus(userStatus, ""),
			rs.WithParentResourceID(parentResourceID),
		}, opts...)...,
	)
	if err != nil {
		return nil, err
	}

	return ret, nil
}

type userBuilder struct {
	resourceType    *v2.ResourceType
	client          *client.DataCenterClient
	userGroupFilter []string
	groupUsers      []client.User
}

func (u *userBuilder) ResourceType(ctx context.Context) *v2.ResourceType {
	return u.resourceType
}

// List returns all the users from the database as resource objects.
// Users include a UserTrait because they are the 'shape' of a standard user.
func (u *userBuilder) List(ctx context.Context, parentResourceID *v2.ResourceId, pToken *pagination.Token) ([]*v2.Resource, string, annotations.Annotations, error) {
	var rv []*v2.Resource

	if pToken == nil || pToken.Token == "" {
		for _, group := range u.userGroupFilter {
			users, err := u.client.GetGroupUsers(ctx, group)
			if err != nil {
				return nil, "", nil, err
			}
			u.groupUsers = append(u.groupUsers, users...)
		}
	}

	users, nextPageToken, err := u.client.GetUsers(ctx, pToken)
	if err != nil {
		return nil, "", nil, err
	}

	for _, usr := range users {
		usrCopy := usr
		opts := []rs.ResourceOption{}

		// TODO: This should be a set or map for better performance.
		if len(u.userGroupFilter) > 0 && !slices.ContainsFunc(u.groupUsers, func(u client.User) bool {
			return u.ID == usr.ID
		}) {
			opts = append(opts, rs.WithResourceStatus(v2.Status_RESOURCE_STATUS_DISABLED, "No Bitbucket license"))
		}

		ur, err := userResource(ctx, &usrCopy, parentResourceID, opts)
		if err != nil {
			return nil, "", nil, err
		}
		rv = append(rv, ur)
	}

	return rv, nextPageToken, nil, nil
}

// Entitlements always returns an empty slice for users.
func (u *userBuilder) Entitlements(_ context.Context, resource *v2.Resource, _ *pagination.Token) ([]*v2.Entitlement, string, annotations.Annotations, error) {
	return nil, "", nil, nil
}

// Grants always returns an empty slice for users since they don't have any entitlements.
func (u *userBuilder) Grants(ctx context.Context, resource *v2.Resource, pToken *pagination.Token) ([]*v2.Grant, string, annotations.Annotations, error) {
	return nil, "", nil, nil
}

// CreateAccountCapabilityDetails declares RANDOM_PASSWORD: Bitbucket's create-user API
// requires a password on every call, so CreateAccount generates one from the caller's
// CredentialOptions and returns it to the caller as PlaintextData on a fresh create,
// giving the platform/admin a usable credential for the new account.
func (u *userBuilder) CreateAccountCapabilityDetails(ctx context.Context) (*v2.CredentialDetailsAccountProvisioning, annotations.Annotations, error) {
	return &v2.CredentialDetailsAccountProvisioning{
		SupportedCredentialOptions: []v2.CapabilityDetailCredentialOption{
			v2.CapabilityDetailCredentialOption_CAPABILITY_DETAIL_CREDENTIAL_OPTION_RANDOM_PASSWORD,
		},
		PreferredCredentialOption: v2.CapabilityDetailCredentialOption_CAPABILITY_DETAIL_CREDENTIAL_OPTION_RANDOM_PASSWORD,
	}, nil, nil
}

// CreateAccount provisions a new local Bitbucket user account.
//
// POST /rest/api/latest/admin/users returns 204 No Content on success, so the
// created user is fetched afterward (by name) to build the resulting resource.
//
// A 409 (login already taken) is resolved against that post-create lookup by
// email, since Bitbucket usernames are unique but emails are not:
//   - Same email as requested: the login is idempotently ours, so this returns
//     AlreadyExistsResult{Resource: resource} - no plaintext data (the existing
//     user's password was never touched) and no IsCreateAccountResult (the SDK
//     type-switches on the result type itself).
//   - Different email: this is someone else's account under the same login,
//     and adopting it would hand the caller access to a different person's
//     identity, so this returns status.Error(codes.AlreadyExists, ...).
//   - Lookup fails or finds nothing: identity cannot be verified either way,
//     so this returns an error rather than guessing.
//
// A fresh create (204) always returns SuccessResult with the generated
// password as PlaintextData. A failed or empty lookup in that path is not
// fatal: the generated password is already set server-side, so the resource
// is built from the known login/display name/email and the password is still
// returned rather than discarding a successful create.
func (u *userBuilder) CreateAccount(
	ctx context.Context,
	accountInfo *v2.AccountInfo,
	credentialOptions *v2.LocalCredentialOptions,
) (connectorbuilder.CreateAccountResponse, []*v2.PlaintextData, annotations.Annotations, error) {
	l := ctxzap.Extract(ctx)
	profile := accountInfo.GetProfile()

	// Precedence: the schema-declared profile field wins; GetLogin() is only the
	// fallback, since it's C1's invitee login and can be populated even when the
	// admin typed a different value into the schema's Username field.
	login, _ := rs.GetProfileStringValue(profile, "login")
	if login == "" {
		login = accountInfo.GetLogin()
	}
	if login == "" {
		return nil, nil, nil, uhttp.WrapErrors(codes.InvalidArgument, "bitbucket(dc)-connector: create account: login is required")
	}

	displayName, _ := rs.GetProfileStringValue(profile, "display_name")
	if displayName == "" {
		return nil, nil, nil, uhttp.WrapErrors(codes.InvalidArgument, "bitbucket(dc)-connector: create account: display_name is required")
	}

	email, _ := rs.GetProfileStringValue(profile, "email")
	if email == "" {
		for _, e := range accountInfo.GetEmails() {
			if e.GetAddress() != "" {
				email = e.GetAddress()
				break
			}
		}
	}
	if email == "" {
		return nil, nil, nil, uhttp.WrapErrors(codes.InvalidArgument, "bitbucket(dc)-connector: create account: email is required")
	}

	addToDefaultGroup := profile.GetFields()["add_to_default_group"].GetBoolValue()

	// crypto.GeneratePassword is nil-safe on credentialOptions (a nil receiver's
	// GetRandomPassword() returns nil), so a missing or malformed CredentialOptions
	// surfaces as ErrInvalidCredentialOptions / ErrInvalidPasswordLength here rather
	// than a panic. Neither sentinel error can contain the password, since generation
	// hasn't produced one yet when they're returned. Any other error (e.g. crypto/rand
	// itself failing) is the caller's CredentialOptions being fine but generation
	// failing regardless, so it maps to Internal rather than InvalidArgument.
	password, err := generatePassword(ctx, credentialOptions)
	if err != nil {
		code := codes.Internal
		if errors.Is(err, crypto.ErrInvalidCredentialOptions) || errors.Is(err, crypto.ErrInvalidPasswordLength) {
			code = codes.InvalidArgument
		}
		return nil, nil, nil, uhttp.WrapErrors(code,
			fmt.Sprintf("bitbucket(dc)-connector: create account %s: generate password", login), err)
	}

	err = u.client.CreateUser(ctx, login, password, displayName, email, addToDefaultGroup)
	alreadyExists := client.IsAlreadyExistsError(err)
	if alreadyExists {
		l.Debug("bitbucket(dc)-connector: create account: user already exists", zap.String("login", login))
	} else if err != nil {
		return nil, nil, nil, fmt.Errorf("bitbucket(dc)-connector: create account %s: %w", login, err)
	}

	// Bypass uhttp's in-memory GET cache (1h TTL): without this, a lookup moments after a
	// create/delete/create cycle on the same login can return another call's stale cached
	// response for the same filter=login URL, which would also make the 409 email guard
	// below compare against stale data instead of the account that actually exists now.
	if cacheErr := uhttp.ClearCaches(ctx); cacheErr != nil {
		l.Debug("bitbucket(dc)-connector: create account: clear http cache", zap.Error(cacheErr))
	}

	fetched, err := u.client.GetUserByName(ctx, login)
	if err != nil || fetched == nil {
		if alreadyExists {
			// Nothing to lose by failing here: the idempotent 409 path never set a
			// password, and we need the fetched email for the identity-safety check
			// right below.
			if err != nil {
				return nil, nil, nil, fmt.Errorf("bitbucket(dc)-connector: create account %s: fetch after create: %w", login, err)
			}
			return nil, nil, nil, fmt.Errorf("bitbucket(dc)-connector: create account %s: fetch after create: user not found", login)
		}
		// CreateUser already succeeded and set the generated password server-side.
		// Failing here would report the create as failed while leaving a
		// password-protected account that nobody - not C1, not this caller - knows
		// the password for. Build the resource from what we already know instead of
		// discarding a create that actually succeeded.
		l.Debug("bitbucket(dc)-connector: create account: fetch after create failed, building resource from known fields",
			zap.String("login", login), zap.Error(err))
		// login/user_slug/user_id are placeholders until the next sync corrects them;
		// the resource ID (user.Name) is accurate. Slug is left empty rather than
		// guessed: Bitbucket's real slugs aren't just a lowercased name (e.g. "@"
		// becomes "_", so jane@corp.com -> jane_corp.com).
		fetched = &client.User{
			Name:         login,
			DisplayName:  displayName,
			EmailAddress: email,
			Active:       true,
			Type:         "NORMAL",
		}
	}

	// Deliberate exception: Bitbucket usernames are unique but emails are NOT (verified
	// live against Bitbucket DC 8.9.4: a second user with the same email is created
	// fine), so a username match with a different email is another person's account
	// and must never be adopted.
	if alreadyExists && !strings.EqualFold(fetched.EmailAddress, email) {
		return nil, nil, nil, status.Error(codes.AlreadyExists, fmt.Sprintf("bitbucket(dc)-connector: create account: login %q already exists with a different email address", login))
	}

	resource, err := userResource(ctx, fetched, nil, nil)
	if err != nil {
		return nil, nil, nil, fmt.Errorf("bitbucket(dc)-connector: create account %s: %w", login, err)
	}

	if alreadyExists {
		// The existing user's password was never touched, so there is no plaintext data
		// to return; IsCreateAccountResult is not set here, as the SDK type-switches on
		// the result type itself to distinguish AlreadyExists from Success.
		return &v2.CreateAccountResponse_AlreadyExistsResult{
			Resource: resource,
		}, nil, nil, nil
	}

	return &v2.CreateAccountResponse_SuccessResult{
		Resource:              resource,
		IsCreateAccountResult: true,
	}, []*v2.PlaintextData{
		{
			Name:  "password",
			Bytes: []byte(password),
		},
	}, nil, nil
}

// Delete deprovisions a Bitbucket user account by deleting it.
//
// A 404 whose response body names Bitbucket's NoSuchUserException is treated as
// already-deleted success, since the C1 platform retries deletes and a connector
// that errors on an already-deleted user fails every retry. A 404 without that
// marker (e.g. from a proxy/WAF in front of /admin/*) is surfaced as an error
// instead, since it isn't a reliable signal that the user is actually gone.
// Any other failure - notably a user managed by an external directory (LDAP/Crowd),
// which Bitbucket refuses to delete through this API - is surfaced with the
// upstream response body so the operator can see why the delete did not happen.
func (u *userBuilder) Delete(ctx context.Context, resourceID *v2.ResourceId) (annotations.Annotations, error) {
	err := u.client.DeleteUser(ctx, resourceID.Resource)
	if err != nil {
		if client.IsNotFoundError(err) && client.IsNoSuchUserError(err) {
			return nil, nil
		}
		var bbErr *client.BitbucketError
		if errors.As(err, &bbErr) && bbErr.ErrorSummary != "" {
			return nil, fmt.Errorf("bitbucket(dc)-connector: delete user %s: %s: %w", resourceID.Resource, bbErr.ErrorSummary, err)
		}
		return nil, fmt.Errorf("bitbucket(dc)-connector: delete user %s: %w", resourceID.Resource, err)
	}
	return nil, nil
}

func newUserBuilder(c *client.DataCenterClient, userGroups []string) *userBuilder {
	return &userBuilder{
		resourceType:    resourceTypeUser,
		client:          c,
		userGroupFilter: userGroups,
	}
}
