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

func userResource(_ context.Context, user *client.User, parentResourceID *v2.ResourceId, opts []rs.UserTraitOption) (*v2.Resource, error) {
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

	userStatus := v2.UserTrait_Status_STATUS_ENABLED
	switch user.Active {
	case true:
		userStatus = v2.UserTrait_Status_STATUS_ENABLED
	case false:
		userStatus = v2.UserTrait_Status_STATUS_DISABLED
	}

	userTraits := []rs.UserTraitOption{
		rs.WithUserProfile(profile),
		rs.WithStatus(userStatus),
		rs.WithUserLogin(user.Name),
		rs.WithEmail(user.EmailAddress, true),
	}

	userTraits = append(userTraits, opts...)

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
		rs.WithParentResourceID(parentResourceID))
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
		opts := []rs.UserTraitOption{}

		// TODO: This should be a set or map for better performance.
		if len(u.userGroupFilter) > 0 && !slices.ContainsFunc(u.groupUsers, func(u client.User) bool {
			return u.ID == usr.ID
		}) {
			opts = append(opts, rs.WithDetailedStatus(v2.UserTrait_Status_STATUS_DISABLED, "No Bitbucket license"))
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
// The baton-sdk version vendored by this connector (v0.3.8) only defines
// Success and ActionRequired branches on CreateAccountResponse - there is no
// AlreadyExists result type to return for a 409. To keep CreateAccount
// idempotent (never error on "already exists") within that constraint, a 409
// is treated the same as a fresh create as long as the post-create lookup finds
// an existing user with the *same* email address we were asked to create: both
// return SuccessResult with the current resource. If the 409'd login belongs to
// a different email, this is someone else's account - returning SuccessResult
// would hand the caller access to it, so a status.Error(codes.AlreadyExists, ...)
// is returned instead. If the lookup fails or finds nothing after a confirmed
// 409, this also returns an error rather than fabricating a resource; on the
// narrow case of a 409 immediately followed by a flaky lookup, a retry (e.g.
// account-provisioning@v3's create-delete-create check) may need to run again
// rather than idempotently succeeding, since there is no AlreadyExistsResult{}
// to fall back to in this SDK version. After a fresh create (204), by contrast,
// a failed or empty lookup is not fatal: the generated password is already set
// server-side, so the resource is built from the known login/display name/email
// and the password is still returned rather than discarding a successful create.
func (u *userBuilder) CreateAccount(
	ctx context.Context,
	accountInfo *v2.AccountInfo,
	credentialOptions *v2.CredentialOptions,
) (connectorbuilder.CreateAccountResponse, []*v2.PlaintextData, annotations.Annotations, error) {
	l := ctxzap.Extract(ctx)
	profileMap := accountInfo.GetProfile().AsMap()

	// Precedence: the schema-declared profile field wins; GetLogin() is only the
	// fallback, since it's C1's invitee login and can be populated even when the
	// admin typed a different value into the schema's Username field.
	login, err := callerString(profileMap, "login")
	if err != nil {
		return nil, nil, nil, err
	}
	if login == "" {
		login = accountInfo.GetLogin()
	}
	if login == "" {
		return nil, nil, nil, uhttp.WrapErrors(codes.InvalidArgument, "bitbucket(dc)-connector: create account: login is required")
	}

	displayName, err := callerString(profileMap, "display_name")
	if err != nil {
		return nil, nil, nil, err
	}
	if displayName == "" {
		return nil, nil, nil, uhttp.WrapErrors(codes.InvalidArgument, "bitbucket(dc)-connector: create account: display_name is required")
	}

	email, err := callerString(profileMap, "email")
	if err != nil {
		return nil, nil, nil, err
	}
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

	addToDefaultGroup, err := callerBool(profileMap, "add_to_default_group")
	if err != nil {
		return nil, nil, nil, err
	}

	// crypto.GeneratePassword is nil-safe on credentialOptions (a nil receiver's
	// GetRandomPassword() returns nil), so a missing or malformed CredentialOptions
	// surfaces as ErrInvalidCredentialOptions / ErrInvalidPasswordLength here rather
	// than a panic. Neither sentinel error can contain the password, since generation
	// hasn't produced one yet when they're returned. Any other error (e.g. crypto/rand
	// itself failing) is the caller's CredentialOptions being fine but generation
	// failing regardless, so it maps to Internal rather than InvalidArgument.
	password, err := generatePassword(credentialOptions)
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
		fetched = &client.User{
			Name:         login,
			DisplayName:  displayName,
			EmailAddress: email,
			Active:       true,
			Type:         "NORMAL",
			Slug:         strings.ToLower(login),
		}
	}

	// A 409 only means the login is idempotently ours if it belongs to the same email
	// we were asked to create. Otherwise this is someone else's account, and adopting it
	// would hand the caller access to a different person's identity.
	if alreadyExists && !strings.EqualFold(fetched.EmailAddress, email) {
		return nil, nil, nil, status.Error(codes.AlreadyExists, fmt.Sprintf("bitbucket(dc)-connector: create account: login %q already exists with a different email address", login))
	}

	resource, err := userResource(ctx, fetched, nil, nil)
	if err != nil {
		return nil, nil, nil, fmt.Errorf("bitbucket(dc)-connector: create account %s: %w", login, err)
	}

	// Only a fresh create actually set the generated password on the account. On the
	// 409-same-email idempotent path, the existing user's password was never touched -
	// returning the generated password as PlaintextData there would hand back a
	// credential that does not work.
	var plaintextData []*v2.PlaintextData
	if !alreadyExists {
		plaintextData = []*v2.PlaintextData{
			{
				Name:  "password",
				Bytes: []byte(password),
			},
		}
	}

	return &v2.CreateAccountResponse_SuccessResult{
		Resource:              resource,
		IsCreateAccountResult: true,
	}, plaintextData, nil, nil
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
