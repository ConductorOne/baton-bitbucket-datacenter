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

func (g *groupBuilder) ResourceType(ctx context.Context) *v2.ResourceType {
	return g.resourceType
}

// List returns all the groups from the database as resource objects.
// Groups include a GroupTrait because they are the 'shape' of a standard group.
func (g *groupBuilder) List(ctx context.Context, parentResourceID *v2.ResourceId, pToken *pagination.Token) ([]*v2.Resource, string, annotations.Annotations, error) {
	var rv []*v2.Resource

	groups, nextPageToken, err := g.client.ListGroups(ctx, pToken)
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

func (g *groupBuilder) Entitlements(ctx context.Context, resource *v2.Resource, pToken *pagination.Token) ([]*v2.Entitlement, string, annotations.Annotations, error) {
	rv := []*v2.Entitlement{
		ent.NewAssignmentEntitlement(
			resource,
			"member",
			ent.WithDisplayName(fmt.Sprintf("%s member", resource.DisplayName)),
			ent.WithDescription(fmt.Sprintf("Member of %s group", resource.DisplayName)),
			ent.WithGrantableTo(resourceTypeUser),
		),
	}

	return rv, "", nil, nil
}

func (g *groupBuilder) Grants(ctx context.Context, resource *v2.Resource, pToken *pagination.Token) ([]*v2.Grant, string, annotations.Annotations, error) {
	var (
		pageToken     int
		err           error
		rv            []*v2.Grant
		nextPageToken string
	)
	_, bag, err := unmarshalSkipToken(pToken)
	if err != nil {
		return nil, "", nil, err
	}

	if bag.Current() == nil {
		bag.Push(pagination.PageState{
			ResourceTypeID: resourceTypeUser.Id,
		})
	}

	if bag.Current().Token != "" {
		pageToken, err = strconv.Atoi(bag.Current().Token)
		if err != nil {
			return nil, "", nil, err
		}
	}

	groupName := resource.Id.Resource
	switch bag.ResourceTypeID() {
	case resourceTypeUser.Id:
		groupMembers, nextPageToken, err := g.client.ListGroupMembers(ctx, client.PageOptions{
			PerPage: client.ITEMSPERPAGE,
			Page:    pageToken,
		}, groupName)
		if err != nil {
			return nil, "", nil, err
		}

		err = bag.Next(nextPageToken)
		if err != nil {
			return nil, "", nil, err
		}

		for _, member := range groupMembers {
			usrCppy := member
			ur, err := userResource(ctx, &client.User{
				Name:         usrCppy.Name,
				EmailAddress: usrCppy.EmailAddress,
				Active:       usrCppy.Active,
				DisplayName:  usrCppy.DisplayName,
				ID:           usrCppy.ID,
				Slug:         usrCppy.Slug,
				Type:         usrCppy.Type,
			}, resource.Id)
			if err != nil {
				return nil, "", nil, fmt.Errorf("error creating user resource for group %s: %w", groupName, err)
			}

			membershipGrant := grant.NewGrant(resource, "member", ur.Id)
			rv = append(rv, membershipGrant)
		}
	default:
		return nil, "", nil, fmt.Errorf("bitbucket(dc) connector: invalid grant resource type: %s", bag.ResourceTypeID())
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
		l.Error(
			"bitbucket(dc)-connector: only users can be granted group membership",
			zap.String("principal_type", principal.Id.ResourceType),
			zap.String("principal_id", principal.Id.Resource),
		)
		return nil, fmt.Errorf("bitbucket(dc)-connector: only users can be granted group membership")
	}

	groupName := entitlement.Resource.Id.Resource
	switch principal.Id.ResourceType {
	case resourceTypeUser.Id:
		userName := principal.DisplayName
		userId, err := strconv.Atoi(principal.Id.Resource)
		if err != nil {
			return nil, err
		}

		// Check if user is already a member of the group
		listGroups, err := listGroupMembers(ctx, g.client, groupName)
		if err != nil {
			return nil, fmt.Errorf("bitbucket(dc)-connector: failed to get group members: %w", err)
		}

		groupPos := slices.IndexFunc(listGroups, func(c client.Members) bool {
			return c.ID == userId
		})
		if groupPos != NF {
			l.Info(
				"bitbucket(dc)-connector: user is already a member of the group",
				zap.String("principal_id", principal.Id.String()),
				zap.String("principal_type", principal.Id.ResourceType),
			)
			return annotations.New(&v2.GrantAlreadyExists{}), nil
		}

		// Add user to the group
		err = g.client.AddUserToGroups(ctx, groupName, userName)
		if err != nil {
			return nil, fmt.Errorf("bitbucket(dc)-connector: failed to add user to group: %w", err)
		}

		l.Info("Group membership granted.",
			zap.Int64("UserID", int64(userId)),
			zap.String("User", userName),
			zap.String("Group", groupName),
		)
	default:
		return nil, fmt.Errorf("bitbucket(dc)-connector: invalid grant resource type: %s", principal.Id.ResourceType)
	}

	return nil, nil
}

func (g *groupBuilder) Revoke(ctx context.Context, grant *v2.Grant) (annotations.Annotations, error) {
	l := ctxzap.Extract(ctx)
	principal := grant.Principal
	entitlement := grant.Entitlement
	if principal.Id.ResourceType != resourceTypeUser.Id {
		l.Error(
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

	groupName := groupResourceId.Resource
	switch principal.Id.ResourceType {
	case resourceTypeUser.Id:
		userName := principal.DisplayName
		userId, err := strconv.Atoi(principal.Id.Resource)
		if err != nil {
			return nil, err
		}
		// Check if user is member of the group
		groupMembers, err := listGroupMembers(ctx, g.client, groupName)
		if err != nil {
			return nil, fmt.Errorf("bitbucket(dc)-connector: failed to get group members: %w", err)
		}

		groupPos := slices.IndexFunc(groupMembers, func(c client.Members) bool {
			return c.ID == userId
		})
		if groupPos == NF {
			l.Info(
				"bitbucket(dc)-connector: user is not a member of the group",
				zap.String("principal_id", principal.Id.String()),
				zap.String("principal_type", principal.Id.ResourceType),
			)
			return annotations.New(&v2.GrantAlreadyRevoked{}), nil
		}

		// Remove user from group
		err = g.client.RemoveUserFromGroup(ctx, userName, groupName)
		if err != nil {
			return nil, fmt.Errorf("bitbucket(dc)-connector: failed to remove user from group: %w", err)
		}

		l.Info("Group membership revoked.",
			zap.Int64("UserID", int64(userId)),
			zap.String("User", userName),
			zap.String("Group", groupName),
		)
	default:
		return nil, fmt.Errorf("bitbucket(dc) connector: invalid grant resource type: %s", principal.Id.ResourceType)
	}

	return nil, nil
}

func newGroupBuilder(c *client.DataCenterClient) *groupBuilder {
	return &groupBuilder{
		resourceType: resourceTypeGroup,
		client:       c,
	}
}

// ** list of permissions **
// System admin: Has full control over Bitbucket - can modify system configuration properties and all application settings,
// and has full access to all projects and repositories. We recommend granting this permission to as few users as possible.

// Admin:
// Has access to most settings required to administer Bitbucket on a daily basis.
// Can add new users, administer permissions and change general application settings.
// Administrators have full access to all projects and repositories.

// Project creator:
// Can create new projects and repositories.
// To foster collaboration, we recommend granting project creation permissions to as many users as possible.

// Bitbucket User: Can log in to Bitbucket and access projects which have explicitly granted permission to this role.
// Note that all Bitbucket users will count towards your license limit.
