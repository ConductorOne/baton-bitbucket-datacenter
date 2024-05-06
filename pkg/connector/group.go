package connector

import (
	"context"
	"fmt"
	"slices"
	"strconv"

	"github.com/conductorone/baton-bitbucket-datacenter/pkg/client"
	v2 "github.com/conductorone/baton-sdk/pb/c1/connector/v2"
	"github.com/conductorone/baton-sdk/pkg/annotations"
	"github.com/conductorone/baton-sdk/pkg/pagination"
	ent "github.com/conductorone/baton-sdk/pkg/types/entitlement"
	"github.com/conductorone/baton-sdk/pkg/types/grant"
	"github.com/grpc-ecosystem/go-grpc-middleware/logging/zap/ctxzap"
	"go.uber.org/zap"
)

type groupBuilder struct {
	resourceType *v2.ResourceType
	client       *client.DataCenterClient
}

const memberEntitlement = "MEMBER"

func (g *groupBuilder) ResourceType(ctx context.Context) *v2.ResourceType {
	return g.resourceType
}

// List returns all the groups from the database as resource objects.
// Groups include a GroupTrait because they are the 'shape' of a standard group.
func (g *groupBuilder) List(ctx context.Context, parentResourceID *v2.ResourceId, pToken *pagination.Token) ([]*v2.Resource, string, annotations.Annotations, error) {
	var (
		pageToken int
		err       error
		rv        []*v2.Resource
	)
	_, bag, err := unmarshalSkipToken(pToken)
	if err != nil {
		return nil, "", nil, err
	}

	if bag.Current() == nil {
		bag.Push(pagination.PageState{
			ResourceTypeID: resourceTypeGroup.Id,
		})
	}

	if bag.Current().Token != "" {
		pageToken, err = strconv.Atoi(bag.Current().Token)
		if err != nil {
			return nil, "", nil, err
		}
	}

	groups, nextPageToken, err := g.client.ListGroups(ctx, client.PageOptions{
		PerPage: ITEMSPERPAGE,
		Page:    pageToken,
	})
	if err != nil {
		return nil, "", nil, err
	}

	err = bag.Next(nextPageToken)
	if err != nil {
		return nil, "", nil, err
	}

	for _, group := range groups {
		groupCopy := group
		ur, err := groupResource(ctx, groupCopy, parentResourceID)
		if err != nil {
			return nil, "", nil, err
		}
		rv = append(rv, ur)
	}

	nextPageToken, err = bag.Marshal()
	if err != nil {
		return nil, "", nil, err
	}

	return rv, nextPageToken, nil, nil
}

// Entitlements always returns an empty slice for users.
func (g *groupBuilder) Entitlements(ctx context.Context, resource *v2.Resource, pToken *pagination.Token) ([]*v2.Entitlement, string, annotations.Annotations, error) {
	var (
		pageToken int
		err       error
		rv        []*v2.Entitlement
	)
	assignmentOptions := []ent.EntitlementOption{
		ent.WithGrantableTo(resourceTypeUser),
		ent.WithDisplayName(fmt.Sprintf("%s Group %s", resource.DisplayName, memberEntitlement)),
		ent.WithDescription(fmt.Sprintf("Access to %s group in Bitbucket DC", resource.DisplayName)),
	}

	// create membership entitlement
	rv = append(rv, ent.NewAssignmentEntitlement(
		resource,
		memberEntitlement,
		assignmentOptions...,
	))

	if pToken.Token != "" {
		pageToken, err = strconv.Atoi(pToken.Token)
		if err != nil {
			return nil, "", nil, err
		}
	}

	permissions, nextPageToken, err := g.client.ListGlobalPermissions(ctx, client.PageOptions{
		PerPage: ITEMSPERPAGE,
		Page:    pageToken,
	})
	if err != nil {
		return nil, "", nil, err
	}

	// create entitlements for each project role (read, write, create, admin)
	for _, permission := range permissions {
		permissionOptions := []ent.EntitlementOption{
			ent.WithGrantableTo(resourceTypeUser, resourceTypeGroup),
			ent.WithDisplayName(fmt.Sprintf("%s Group %s", resource.DisplayName, permission.Permission)),
			ent.WithDescription(fmt.Sprintf("%s access to %s group in Bitbucket DC", titleCase(permission.Permission), resource.DisplayName)),
		}

		rv = append(rv, ent.NewPermissionEntitlement(
			resource,
			permission.Permission,
			permissionOptions...,
		))
	}

	return rv, nextPageToken, nil, nil
}

func (g *groupBuilder) Grants(ctx context.Context, resource *v2.Resource, pToken *pagination.Token) ([]*v2.Grant, string, annotations.Annotations, error) {
	var (
		pageToken      int
		err            error
		rv             []*v2.Grant
		rolePermission string = memberEntitlement
	)
	_, bag, err := unmarshalSkipToken(pToken)
	if err != nil {
		return nil, "", nil, err
	}

	if bag.Current() == nil {
		bag.Push(pagination.PageState{
			ResourceTypeID: resourceTypeGroup.Id,
		})
	}

	if bag.Current().Token != "" {
		pageToken, err = strconv.Atoi(bag.Current().Token)
		if err != nil {
			return nil, "", nil, err
		}
	}

	members, nextPageToken, err := g.client.ListGroupMembers(ctx, client.PageOptions{
		PerPage: ITEMSPERPAGE,
		Page:    pageToken,
	}, resource.Id.Resource)
	if err != nil {
		return nil, "", nil, err
	}

	err = bag.Next(nextPageToken)
	if err != nil {
		return nil, "", nil, err
	}

	for _, member := range members {
		usrCppy := member
		ur, err := userResource(ctx, &client.Users{
			Name:         usrCppy.Name,
			EmailAddress: usrCppy.EmailAddress,
			Active:       usrCppy.Active,
			DisplayName:  usrCppy.DisplayName,
			ID:           usrCppy.ID,
			Slug:         usrCppy.Slug,
			Type:         usrCppy.Type,
		}, resource.Id)
		if err != nil {
			return nil, "", nil, fmt.Errorf("error creating user resource for group %s: %w", resource.Id.Resource, err)
		}

		permissions, _, err := g.client.ListGlobalPermissions(ctx, client.PageOptions{})
		if err != nil {
			return nil, "", nil, err
		}

		index := slices.IndexFunc(permissions, func(c client.UsersPermissions) bool {
			return c.User.ID == usrCppy.ID
		})
		if index != -1 {
			rolePermission = permissions[index].Permission
		}

		membershipGrant := grant.NewGrant(resource, rolePermission, ur.Id)
		rv = append(rv, membershipGrant)
	}

	nextPageToken, err = bag.Marshal()
	if err != nil {
		return nil, "", nil, err
	}

	return rv, nextPageToken, nil, nil
}

func (g *groupBuilder) Grant(ctx context.Context, principal *v2.Resource, entitlement *v2.Entitlement) (annotations.Annotations, error) {
	l := ctxzap.Extract(ctx)
	if principal.Id.ResourceType != resourceTypeUser.Id {
		l.Warn(
			"bitbucket(dc)-connector: only users can be granted group membership",
			zap.String("principal_type", principal.Id.ResourceType),
			zap.String("principal_id", principal.Id.Resource),
		)
		return nil, fmt.Errorf("bitbucket(dc)-connector: only users can be granted group membership")
	}

	groupResourceId, _, err := ParseEntitlementID(entitlement.Id)
	if err != nil {
		return nil, err
	}

	userId, err := strconv.Atoi(principal.Id.Resource)
	if err != nil {
		return nil, err
	}

	// Check if user is already a member of the group
	members, _, err := g.client.ListGroupMembers(ctx, client.PageOptions{
		PerPage: ITEMSPERPAGE,
		Page:    0,
	}, groupResourceId.Resource)
	if err != nil {
		return nil, fmt.Errorf("bitbucket(dc)-connector: failed to get group members: %w", err)
	}

	index := slices.IndexFunc(members, func(c client.Members) bool {
		return c.ID == userId
	})
	if index != -1 {
		l.Warn(
			"bitbucket(dc)-connector: user is already a member of the group",
			zap.String("principal_id", principal.Id.String()),
			zap.String("principal_type", principal.Id.ResourceType),
		)
		return nil, fmt.Errorf("bitbucket(dc)-connector: user is already a member of the group")
	}

	// Add user to the group
	err = g.client.AddUserToGroups(ctx, groupResourceId.Resource, principal.DisplayName)
	if err != nil {
		return nil, fmt.Errorf("bitbucket(dc)-connector: failed to add user to group: %w", err)
	}

	l.Warn("Membership has been created.",
		zap.Int64("UserID", int64(userId)),
		zap.String("User", principal.DisplayName),
		zap.String("Group", groupResourceId.Resource),
	)

	return nil, nil
}

func (g *groupBuilder) Revoke(ctx context.Context, grant *v2.Grant) (annotations.Annotations, error) {
	l := ctxzap.Extract(ctx)
	principal := grant.Principal
	entitlement := grant.Entitlement
	if principal.Id.ResourceType != resourceTypeUser.Id {
		l.Warn(
			"bitbucket(dc)-connector: only users can have group membership revoked",
			zap.String("principal_id", principal.Id.String()),
			zap.String("principal_type", principal.Id.ResourceType),
		)

		return nil, fmt.Errorf("bitbucket(dc)-connector: only users can have group membership revoked")
	}

	groupResourceId, _, err := ParseEntitlementID(entitlement.Id)
	if err != nil {
		return nil, err
	}

	userId, err := strconv.Atoi(principal.Id.Resource)
	if err != nil {
		return nil, err
	}

	// Check if user is member of the group
	members, _, err := g.client.ListGroupMembers(ctx, client.PageOptions{
		PerPage: ITEMSPERPAGE,
		Page:    0,
	}, groupResourceId.Resource)
	if err != nil {
		return nil, fmt.Errorf("bitbucket(dc)-connector: failed to get group members: %w", err)
	}

	index := slices.IndexFunc(members, func(c client.Members) bool {
		return c.ID == userId
	})
	if index == -1 {
		l.Warn(
			"bitbucket(dc)-connector: user is not a member of the group",
			zap.String("principal_id", principal.Id.String()),
			zap.String("principal_type", principal.Id.ResourceType),
		)
		return nil, fmt.Errorf("bitbucket(dc)-connector: user is not a member of the group")
	}

	// Remove user from group
	err = g.client.RemoveUserFromGroup(ctx, principal.DisplayName, groupResourceId.Resource)
	if err != nil {
		return nil, fmt.Errorf("bitbucket(dc)-connector: failed to remove user from group: %w", err)
	}

	l.Warn("Membership has been removed.",
		zap.Int64("UserID", int64(userId)),
		zap.String("User", principal.DisplayName),
		zap.String("Group", groupResourceId.Resource),
	)

	return nil, nil
}

func newGroupBuilder(c *client.DataCenterClient) *groupBuilder {
	return &groupBuilder{
		resourceType: resourceTypeGroup,
		client:       c,
	}
}
