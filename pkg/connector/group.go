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
	if pToken.Token != "" {
		pageToken, err = strconv.Atoi(pToken.Token)
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

	for _, group := range groups {
		groupCopy := group
		ur, err := groupResource(ctx, groupCopy, parentResourceID)
		if err != nil {
			return nil, "", nil, err
		}
		rv = append(rv, ur)
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

// Grants always returns an empty slice for users since they don't have any entitlements.
func (g *groupBuilder) Grants(ctx context.Context, resource *v2.Resource, pToken *pagination.Token) ([]*v2.Grant, string, annotations.Annotations, error) {
	var (
		pageToken      int
		err            error
		rv             []*v2.Grant
		rolePermission string = memberEntitlement
	)
	if pToken.Token != "" {
		pageToken, err = strconv.Atoi(pToken.Token)
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

	return rv, nextPageToken, nil, nil
}

func newGroupBuilder(c *client.DataCenterClient) *groupBuilder {
	return &groupBuilder{
		resourceType: resourceTypeGroup,
		client:       c,
	}
}
