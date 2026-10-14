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

// CreateAccountCapabilityDetails declares RANDOM_PASSWORD: Bitbucket's create-user API only
// requires a password unless notify=true, which instead emails the new user a set-password
// link and therefore depends on Bitbucket having a mail server configured. CreateAccount
// generates a password from the caller's CredentialOptions and returns it to the caller as
// PlaintextData on a fresh create, giving the platform/admin a usable credential for the new
// account without depending on mail delivery.
func (u *userBuilder) CreateAccountCapabilityDetails(ctx context.Context) (*v2.CredentialDetailsAccountProvisioning, annotations.Annotations, error) {
	return &v2.CredentialDetailsAccountProvisioning{
		SupportedCredentialOptions: []v2.CapabilityDetailCredentialOption{
			v2.CapabilityDetailCredentialOption_CAPABILITY_DETAIL_CREDENTIAL_OPTION_RANDOM_PASSWORD,
		},
		PreferredCredentialOption: v2.CapabilityDetailCredentialOption_CAPABILITY_DETAIL_CREDENTIAL_OPTION_RANDOM_PASSWORD,
	}, nil, nil
}

// CreateAccount provisions a new local Bitbucket user account. The create response has no
// body, so the user is fetched by name afterward, and a 409 is resolved against that lookup.
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

	password, err := crypto.GeneratePassword(ctx, credentialOptions)
	if err != nil {
		return nil, nil, nil, fmt.Errorf("bitbucket(dc)-connector: create account %s: generate password: %w", login, err)
	}

	err = u.client.CreateUser(ctx, login, password, displayName, email, addToDefaultGroup)
	alreadyExists := client.IsAlreadyExistsError(err)
	if alreadyExists {
		l.Debug("bitbucket(dc)-connector: create account: user already exists", zap.String("login", login))
	} else if err != nil {
		return nil, nil, nil, fmt.Errorf("bitbucket(dc)-connector: create account %s: %w", login, err)
	}

	// Skip the GET cache so the lookup sees the account that was just created.
	fetched, err := u.client.GetUserByName(ctx, login, uhttp.WithNoCache())
	if err != nil || fetched == nil {
		if alreadyExists {
			// The idempotent 409 path never set a password, and the identity check below
			// needs the fetched email, so failing here loses nothing.
			if err != nil {
				return nil, nil, nil, fmt.Errorf("bitbucket(dc)-connector: create account %s: fetch after create: %w", login, err)
			}
			return nil, nil, nil, fmt.Errorf("bitbucket(dc)-connector: create account %s: fetch after create: user not found", login)
		}
		// The create already succeeded and set the password server-side, so failing here
		// would discard a working account. Build the resource from what we already know.
		l.Debug("bitbucket(dc)-connector: create account: fetch after create failed, building resource from known fields",
			zap.String("login", login), zap.Error(err))
		// Profile login/user_slug/user_id stay empty until the next sync; the resource ID
		// and trait login are correct. Slug is left empty rather than guessed: Bitbucket's
		// real slugs aren't just a lowercased name (e.g. "@" becomes "_", so
		// jane@corp.com -> jane_corp.com).
		fetched = &client.User{
			Name:         login,
			DisplayName:  displayName,
			EmailAddress: email,
			Active:       true,
			Type:         "NORMAL",
		}
	}

	// Usernames are unique in Bitbucket, emails are not, so a different email is another person's account.
	if alreadyExists && !strings.EqualFold(fetched.EmailAddress, email) {
		return nil, nil, nil, status.Error(codes.AlreadyExists, fmt.Sprintf("bitbucket(dc)-connector: create account: login %q already exists with a different email address", login))
	}

	resource, err := userResource(ctx, fetched, nil, nil)
	if err != nil {
		return nil, nil, nil, fmt.Errorf("bitbucket(dc)-connector: create account %s: %w", login, err)
	}

	if alreadyExists {
		return &v2.CreateAccountResponse_AlreadyExistsResult{
			Resource:              resource,
			IsCreateAccountResult: true,
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

// Delete removes the user; a 404 naming NoSuchUserException counts as already deleted so the
// operation is idempotent. Other 404s (e.g. from a proxy) are errors.
func (u *userBuilder) Delete(ctx context.Context, resourceID *v2.ResourceId, parentResourceID *v2.ResourceId) (annotations.Annotations, error) {
	if resourceID.GetResourceType() != u.resourceType.Id {
		return nil, status.Error(codes.InvalidArgument, fmt.Sprintf("bitbucket(dc)-connector: delete: unexpected resource type %q", resourceID.GetResourceType()))
	}

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
