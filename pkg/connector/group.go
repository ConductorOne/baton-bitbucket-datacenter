package connector

import (
	"context"
	"errors"
	"fmt"
	"net/http"
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
	var (
		pageToken    int
		err          error
		rv           []*v2.Resource
		bitbucketErr *client.BitbucketError
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
		switch {
		case errors.As(err, &bitbucketErr):
			if bitbucketErr.ErrorCode != http.StatusUnauthorized {
				return nil, "", nil, fmt.Errorf("%s", bitbucketErr.Error())
			}
		default:
			return nil, "", nil, err
		}
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
		pageToken              int
		nextPageToken          string
		err                    error
		rv                     []*v2.Entitlement
		bitbucketErr           *client.BitbucketError
		entitlementPermissions []string
	)

	if pToken.Token != "" {
		pageToken, err = strconv.Atoi(pToken.Token)
		if err != nil {
			return nil, "", nil, err
		}
	}

	permissions, nextPageToken, err := g.client.ListGlobalUserPermissions(ctx, client.PageOptions{
		PerPage: ITEMSPERPAGE,
		Page:    pageToken,
	})

	if err != nil {
		switch {
		case errors.As(err, &bitbucketErr):
			if bitbucketErr.ErrorCode != http.StatusUnauthorized {
				return nil, "", nil, fmt.Errorf("%s", bitbucketErr.Error())
			}
		default:
			return nil, "", nil, err
		}

		permissions = []client.UsersPermissions{{Permission: "LICENSED_USER"}}
	}

	for _, permission := range permissions {
		entitlementPermissions = append(entitlementPermissions, permission.Permission)
	}

	entitlementPermissions = append(entitlementPermissions, projectPermissions...)
	entitlementPermissions = append(entitlementPermissions, repositoryRoles...)
	// create entitlements for each group role (read, write, create, admin)
	for _, permission := range entitlementPermissions {
		permissionOptions := []ent.EntitlementOption{
			ent.WithGrantableTo(resourceTypeUser, resourceTypeGroup),
			ent.WithDisplayName(fmt.Sprintf("%s Group %s", resource.DisplayName, permission)),
			ent.WithDescription(fmt.Sprintf("%s access to %s group in Bitbucket DC", titleCase(permission), resource.DisplayName)),
		}

		rv = append(rv, ent.NewPermissionEntitlement(
			resource,
			permission,
			permissionOptions...,
		))
	}

	return rv, nextPageToken, nil, nil
}

func (g *groupBuilder) Grants(ctx context.Context, resource *v2.Resource, pToken *pagination.Token) ([]*v2.Grant, string, annotations.Annotations, error) {
	var (
		pageToken                                      int
		err                                            error
		rv                                             []*v2.Grant
		userPermission, groupPermission, nextPageToken string
		bitbucketErr                                   *client.BitbucketError
	)
	_, bag, err := unmarshalSkipToken(pToken)
	if err != nil {
		return nil, "", nil, err
	}

	if bag.Current() == nil {
		// Push onto stack in reverse
		bag.Push(pagination.PageState{
			ResourceTypeID: resourceTypeRepository.Id,
		})
		bag.Push(pagination.PageState{
			ResourceTypeID: resourceTypeProject.Id,
		})
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
	case resourceTypeRepository.Id:
		repos, nextPageToken, err := g.client.ListRepos(ctx, client.PageOptions{
			PerPage: ITEMSPERPAGE,
			Page:    pageToken,
		})
		if err != nil {
			return nil, "", nil, err
		}

		for _, repo := range repos {
			projectKey := repo.Project.Key
			repositorySlug := repo.Slug
			groupRepositoryPermissions, err := listGroupRepositoryPermissions(ctx, g.client, projectKey, repositorySlug)
			if err != nil {
				return nil, "", nil, err
			}

			groupsPermissionsPos := slices.IndexFunc(groupRepositoryPermissions, func(c client.GroupsPermissions) bool {
				return c.Group.Name == groupName
			})
			if groupsPermissionsPos != NF {
				ur, err := repositoryResource(ctx, &client.Repos{
					Slug:          repo.Slug,
					ID:            repo.ID,
					Name:          repo.Name,
					HierarchyId:   repo.HierarchyId,
					ScmId:         repo.ScmId,
					State:         repo.State,
					StatusMessage: repo.StatusMessage,
					Project: client.Projects{
						Key:  repo.Project.Key,
						ID:   repo.Project.ID,
						Name: repo.Project.Name,
						Type: repo.Project.Type,
					},
				}, resource.Id)
				if err != nil {
					return nil, "", nil, err
				}

				membershipGrant := grant.NewGrant(resource, groupRepositoryPermissions[groupsPermissionsPos].Permission, ur.Id)
				rv = append(rv, membershipGrant)
			}
		}

		err = bag.Next(nextPageToken)
		if err != nil {
			return nil, "", nil, err
		}
	case resourceTypeProject.Id:
		projects, nextPageToken, err := g.client.ListProjects(ctx, client.PageOptions{
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

		for _, project := range projects {
			projectKey := project.Key
			// Get group permissions
			groupProjectsPermission, groupPos, err := getGroupProjectsPermission(ctx, g.client, projectKey, groupName)
			if err != nil {
				return nil, "", nil, err
			}

			if groupPos != NF {
				ur, err := projectResource(ctx, &client.Projects{
					Key:  projectKey,
					ID:   project.ID,
					Name: project.Name,
					Type: project.Type,
				}, resource.Id)
				if err != nil {
					return nil, "", nil, err
				}

				membershipGrant := grant.NewGrant(resource, groupProjectsPermission, ur.Id)
				rv = append(rv, membershipGrant)
			}
		}
	case resourceTypeUser.Id:
		// Get user permissions
		userPermissions, err := listGlobalUserPermissions(ctx, g.client)
		if err != nil {
			switch {
			case errors.As(err, &bitbucketErr):
				if bitbucketErr.ErrorCode != http.StatusUnauthorized {
					return nil, "", nil, fmt.Errorf("%s", bitbucketErr.Error())
				}
			default:
				return nil, "", nil, err
			}
		}

		// Get group permissions
		groupPermissions, err := listGlobalGroupPermissions(ctx, g.client)
		if err != nil {
			switch {
			case errors.As(err, &bitbucketErr):
				if bitbucketErr.ErrorCode != http.StatusUnauthorized {
					return nil, "", nil, fmt.Errorf("%s", bitbucketErr.Error())
				}
			default:
				return nil, "", nil, err
			}
		}

		groupPos := slices.IndexFunc(groupPermissions, func(c client.GroupsPermissions) bool {
			return c.Group.Name == resource.Id.Resource
		})
		if groupPos != NF {
			groupPermission = groupPermissions[groupPos].Permission
		}

		groupMembers, nextPageToken, err := g.client.ListGroupMembers(ctx, client.PageOptions{
			PerPage: ITEMSPERPAGE,
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
			userPermission = "LICENSED_USER"
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
				return nil, "", nil, fmt.Errorf("error creating user resource for group %s: %w", groupName, err)
			}

			userPos := slices.IndexFunc(userPermissions, func(c client.UsersPermissions) bool {
				return c.User.ID == usrCppy.ID
			})
			if userPos != NF {
				userPermission = userPermissions[userPos].Permission
			}

			if userPermission == groupPermission {
				membershipGrant := grant.NewGrant(resource, userPermission, ur.Id)
				rv = append(rv, membershipGrant)
				continue
			}

			membershipGrant := grant.NewGrant(resource, userPermission, ur.Id)
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
	var (
		projectKey, permission, repositorySlug string
		bitbucketErr                           *client.BitbucketError
	)
	l := ctxzap.Extract(ctx)
	if principal.Id.ResourceType != resourceTypeUser.Id &&
		principal.Id.ResourceType != resourceTypeRepository.Id &&
		principal.Id.ResourceType != resourceTypeProject.Id {
		l.Warn(
			"bitbucket(dc)-connector: only users, repos or projects can be granted group membership",
			zap.String("principal_type", principal.Id.ResourceType),
			zap.String("principal_id", principal.Id.Resource),
		)
		return nil, fmt.Errorf("bitbucket(dc)-connector: only users, repos or projects can be granted group membership")
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
			l.Warn(
				"bitbucket(dc)-connector: user is already a member of the group",
				zap.String("principal_id", principal.Id.String()),
				zap.String("principal_type", principal.Id.ResourceType),
			)
			return nil, fmt.Errorf("bitbucket(dc)-connector: user is already a member of the group")
		}

		// Add user to the group
		err = g.client.AddUserToGroups(ctx, groupName, userName)
		if err != nil {
			return nil, fmt.Errorf("bitbucket(dc)-connector: failed to add user to group: %w", err)
		}

		l.Warn("Membership has been created.",
			zap.Int64("UserID", int64(userId)),
			zap.String("User", userName),
			zap.String("Group", groupName),
		)
	case resourceTypeRepository.Id:
		groupName := entitlement.Resource.Id.Resource
		_, permissions, err := ParseEntitlementID(entitlement.Id)
		if err != nil {
			return nil, err
		}

		switch permissions[len(permissions)-1] {
		case roleRepoWrite, roleRepoAdmin, roleRepoRead:
			permission = permissions[len(permissions)-1]
		default:
			return nil, fmt.Errorf("bitbucket(dc)-connector: invalid permission type: %s", permissions[len(permissions)-1])
		}

		repoId, err := strconv.Atoi(principal.Id.Resource)
		if err != nil {
			return nil, err
		}

		projectKey, repositorySlug, _, err = getRepositoryData(ctx, g, repoId)
		if err != nil {
			return nil, err
		}

		groupRepositoryPermissions, err := listGroupRepositoryPermissions(ctx, g.client, projectKey, repositorySlug)
		if err != nil {
			switch {
			case errors.As(err, &bitbucketErr):
				if bitbucketErr.ErrorCode != http.StatusUnauthorized {
					return nil, fmt.Errorf("%s", bitbucketErr.Error())
				}
			default:
				return nil, err
			}
		}

		groupRepositoryPermissionPos := slices.IndexFunc(groupRepositoryPermissions, func(c client.GroupsPermissions) bool {
			return c.Group.Name == groupName
		})
		if groupRepositoryPermissionPos != NF {
			l.Warn(
				"bitbucket(dc)-connector: group already has this repository permission",
				zap.String("principal_id", principal.Id.String()),
				zap.String("principal_type", principal.Id.ResourceType),
			)
			return nil, fmt.Errorf("bitbucket(dc)-connector: group %s already has this repository permission", groupName)
		}

		err = g.client.UpdateGroupRepositoryPermission(ctx,
			projectKey,
			repositorySlug,
			groupName,
			permission,
		)
		if err != nil {
			switch {
			case errors.As(err, &bitbucketErr):
				if bitbucketErr.ErrorCode != http.StatusUnauthorized {
					return nil, fmt.Errorf("%s", bitbucketErr.Error())
				}
			default:
				return nil, err
			}
		}

		l.Warn("Group Membership has been created.",
			zap.String("GroupName", groupName),
			zap.String("ProjectKey", projectKey),
			zap.String("RepositorySlug", repositorySlug),
		)
	case resourceTypeProject.Id:
		_, permissions, err := ParseEntitlementID(entitlement.Id)
		if err != nil {
			return nil, err
		}

		switch permissions[len(permissions)-1] {
		case roleProjectCreate, roleProjectWrite, roleProjectAdmin, roleProjectRead, roleRepoCreate:
			permission = permissions[len(permissions)-1]
		default:
			return nil, fmt.Errorf("bitbucket(dc) connector: invalid permission type: %s", permissions[len(permissions)-1])
		}

		projectId, err := strconv.Atoi(principal.Id.Resource)
		if err != nil {
			return nil, err
		}

		projectKey, err = getProjectKey(ctx, g, projectId)
		if err != nil {
			return nil, err
		}

		listGroup, err := listGroupProjectsPermissions(ctx, g.client, projectKey)
		if err != nil {
			return nil, err
		}

		groupPos := slices.IndexFunc(listGroup, func(c client.GroupsPermissions) bool {
			return c.Group.Name == groupName && c.Permission == permission
		})
		if groupPos != NF {
			l.Warn(
				"bitbucket(dc)-connector: group already has this project permission",
				zap.String("principal_id", principal.Id.String()),
				zap.String("principal_type", principal.Id.ResourceType),
			)
			return nil, fmt.Errorf("bitbucket(dc)-connector: group %s already has this project permission", groupName)
		}

		err = g.client.UpdateGroupProjectPermission(ctx, projectKey, groupName, permission)
		if err != nil {
			switch {
			case errors.As(err, &bitbucketErr):
				return nil, fmt.Errorf("%s %s", bitbucketErr.Error(), bitbucketErr.ErrorSummary)
			default:
				return nil, err
			}
		}

		l.Warn("Project Membership has been created.",
			zap.String("GroupName", groupName),
			zap.String("ProjectKey", projectKey),
			zap.String("Permission", permission),
		)
	default:
		return nil, fmt.Errorf("bitbucket(dc)-connector: invalid grant resource type: %s", principal.Id.ResourceType)
	}

	return nil, nil
}

func (g *groupBuilder) Revoke(ctx context.Context, grant *v2.Grant) (annotations.Annotations, error) {
	var (
		projectKey, repositorySlug, permission string
		bitbucketErr                           *client.BitbucketError
	)
	l := ctxzap.Extract(ctx)
	principal := grant.Principal
	entitlement := grant.Entitlement
	if principal.Id.ResourceType != resourceTypeUser.Id &&
		principal.Id.ResourceType != resourceTypeRepository.Id &&
		principal.Id.ResourceType != resourceTypeProject.Id {
		l.Warn(
			"bitbucket(dc)-connector: only users, repos or projects can have group membership revoked",
			zap.String("principal_id", principal.Id.String()),
			zap.String("principal_type", principal.Id.ResourceType),
		)

		return nil, fmt.Errorf("bitbucket(dc)-connector: only users, repos or projects can have group membership revoked")
	}

	groupResourceId, permissions, err := ParseEntitlementID(entitlement.Id)
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
			l.Warn(
				"bitbucket(dc)-connector: user is not a member of the group",
				zap.String("principal_id", principal.Id.String()),
				zap.String("principal_type", principal.Id.ResourceType),
			)
			return nil, fmt.Errorf("bitbucket(dc)-connector: user %s is not a member of the group", userName)
		}

		// Remove user from group
		err = g.client.RemoveUserFromGroup(ctx, userName, groupName)
		if err != nil {
			return nil, fmt.Errorf("bitbucket(dc)-connector: failed to remove user from group: %w", err)
		}

		l.Warn("Membership has been revoked.",
			zap.Int64("UserID", int64(userId)),
			zap.String("User", userName),
			zap.String("Group", groupName),
		)
	case resourceTypeRepository.Id:
		groupName := entitlement.Resource.Id.Resource
		switch permissions[len(permissions)-1] {
		case roleRepoWrite, roleRepoAdmin, roleRepoRead:
			permission = permissions[len(permissions)-1]
		default:
			return nil, fmt.Errorf("bitbucket(dc)-connector: invalid permission type: %s", permissions[len(permissions)-1])
		}

		repoId, err := strconv.Atoi(principal.Id.Resource)
		if err != nil {
			return nil, err
		}

		projectKey, repositorySlug, _, err = getRepositoryData(ctx, g, repoId)
		if err != nil {
			return nil, err
		}

		groupRepositoryPermissions, err := listGroupRepositoryPermissions(ctx, g.client, projectKey, repositorySlug)
		if err != nil {
			switch {
			case errors.As(err, &bitbucketErr):
				if bitbucketErr.ErrorCode != http.StatusUnauthorized {
					return nil, fmt.Errorf("%s", bitbucketErr.Error())
				}
			default:
				return nil, err
			}
		}

		groupRepositoryPermissionPos := slices.IndexFunc(groupRepositoryPermissions, func(c client.GroupsPermissions) bool {
			return c.Group.Name == groupName
		})
		if groupRepositoryPermissionPos == NF {
			l.Warn(
				"bitbucket(dc)-connector: group does not have this repository permission",
				zap.String("principal_id", principal.Id.String()),
				zap.String("principal_type", principal.Id.ResourceType),
			)
			return nil, fmt.Errorf("bitbucket(dc)-connector: group %s does not have this repository permission", groupName)
		}

		err = g.client.RevokeGroupRepositoryPermission(ctx,
			projectKey,
			repositorySlug,
			groupName,
		)
		if err != nil {
			switch {
			case errors.As(err, &bitbucketErr):
				if bitbucketErr.ErrorCode != http.StatusUnauthorized {
					return nil, fmt.Errorf("%s", bitbucketErr.Error())
				}
			default:
				return nil, err
			}
		}

		l.Warn("Group Membership has been revoked.",
			zap.String("GroupName", groupName),
			zap.String("ProjectKey", projectKey),
			zap.String("RepositorySlug", repositorySlug),
			zap.String("Permission", permission),
		)
	case resourceTypeProject.Id:

		switch permissions[len(permissions)-1] {
		case roleProjectCreate, roleProjectWrite, roleProjectAdmin, roleProjectRead, roleRepoCreate:
			permission = permissions[len(permissions)-1]
		default:
			return nil, fmt.Errorf("bitbucket(dc) connector: invalid permission type: %s", permissions[len(permissions)-1])
		}

		projectId, err := strconv.Atoi(principal.Id.Resource)
		if err != nil {
			return nil, err
		}

		projectKey, err = getProjectKey(ctx, g, projectId)
		if err != nil {
			return nil, err
		}

		listGroup, err := listGroupProjectsPermissions(ctx, g.client, projectKey)
		if err != nil {
			return nil, err
		}

		groupPos := slices.IndexFunc(listGroup, func(c client.GroupsPermissions) bool {
			return c.Group.Name == groupName && c.Permission == permission
		})
		if groupPos == NF {
			l.Warn(
				"bitbucket(dc)-connector: group doesn't have this project permission",
				zap.String("principal_id", principal.Id.String()),
				zap.String("principal_type", principal.Id.ResourceType),
			)
			return nil, fmt.Errorf("bitbucket(dc)-connector: group %s doesn't have this project permission", groupName)
		}

		err = g.client.RevokeGroupProjectPermission(ctx, projectKey, groupName)
		if err != nil {
			switch {
			case errors.As(err, &bitbucketErr):
				return nil, fmt.Errorf("%s %s", bitbucketErr.Error(), bitbucketErr.ErrorSummary)
			default:
				return nil, err
			}
		}

		l.Warn("Project Membership has been revoked.",
			zap.String("GroupName", groupName),
			zap.String("ProjectKey", projectKey),
			zap.String("Permission", permission),
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
