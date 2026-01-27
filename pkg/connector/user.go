package connector

import (
	"context"
	"slices"

	"github.com/conductorone/baton-bitbucket-datacenter/pkg/client"
	v2 "github.com/conductorone/baton-sdk/pb/c1/connector/v2"
	"github.com/conductorone/baton-sdk/pkg/annotations"
	"github.com/conductorone/baton-sdk/pkg/pagination"
	rs "github.com/conductorone/baton-sdk/pkg/types/resource"
)

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

	var userStatus = v2.UserTrait_Status_STATUS_ENABLED
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

func newUserBuilder(c *client.DataCenterClient, userGroups []string) *userBuilder {
	return &userBuilder{
		resourceType:    resourceTypeUser,
		client:          c,
		userGroupFilter: userGroups,
	}
}
