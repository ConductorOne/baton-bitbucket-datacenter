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

type projectBuilder struct {
	resourceType *v2.ResourceType
	client       *client.DataCenterClient
}

const (
	roleProjectRead   = "PROJECT_READ"
	roleProjectWrite  = "PROJECT_WRITE"
	roleProjectCreate = "PROJECT_CREATE"
	roleProjectAdmin  = "PROJECT_ADMIN"
)

var projectPermissions = []string{roleProjectRead, roleProjectWrite, roleProjectCreate, roleProjectAdmin, roleRepoCreate}

func (p *projectBuilder) ResourceType(ctx context.Context) *v2.ResourceType {
	return p.resourceType
}

// List returns all the projects from the database as resource objects.
// Projects include a ProjectTrait because they are the 'shape' of a standard project.
func (p *projectBuilder) List(ctx context.Context, parentResourceID *v2.ResourceId, pToken *pagination.Token) ([]*v2.Resource, string, annotations.Annotations, error) {
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
			ResourceTypeID: resourceTypeProject.Id,
		})
	}

	if bag.Current().Token != "" {
		pageToken, err = strconv.Atoi(bag.Current().Token)
		if err != nil {
			return nil, "", nil, err
		}
	}

	projects, nextPageToken, err := p.client.ListProjects(ctx, client.PageOptions{
		PerPage: ITEMSPERPAGE,
		Page:    pageToken,
	})
	err = checkStatusUnauthorizedError(ctx, err)
	if err != nil {
		return nil, "", nil, err
	}

	err = bag.Next(nextPageToken)
	if err != nil {
		return nil, "", nil, err
	}

	for _, proj := range projects {
		projCopy := proj
		ur, err := projectResource(ctx, &projCopy, parentResourceID)
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
func (p *projectBuilder) Entitlements(_ context.Context, resource *v2.Resource, _ *pagination.Token) ([]*v2.Entitlement, string, annotations.Annotations, error) {
	var rv []*v2.Entitlement
	// create entitlements for each project role (read, write, create, admin)
	for _, permission := range projectPermissions {
		permissionOptions := []ent.EntitlementOption{
			ent.WithGrantableTo(resourceTypeUser, resourceTypeGroup),
			ent.WithDisplayName(fmt.Sprintf("%s Project %s", resource.DisplayName, permission)),
			ent.WithDescription(fmt.Sprintf("%s access to %s project in Bitbucket DC", titleCase(permission), resource.DisplayName)),
		}

		rv = append(rv, ent.NewPermissionEntitlement(
			resource,
			permission,
			permissionOptions...,
		))
	}

	return rv, "", nil, nil
}

func (p *projectBuilder) Grants(ctx context.Context, resource *v2.Resource, pToken *pagination.Token) ([]*v2.Grant, string, annotations.Annotations, error) {
	var (
		pageToken                 int
		err                       error
		rv                        []*v2.Grant
		projectKey, nextPageToken string
		usersPermissions          []client.UsersPermissions
		groupsPermissions         []client.GroupsPermissions
	)
	_, bag, err := unmarshalSkipToken(pToken)
	if err != nil {
		return nil, "", nil, err
	}

	if bag.Current() == nil {
		// Push onto stack in reverse
		bag.Push(pagination.PageState{
			ResourceTypeID: resourceTypeGroup.Id,
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

	projectId, err := strconv.Atoi(resource.Id.Resource)
	if err != nil {
		return nil, "", nil, err
	}

	projectKey, err = getProjectKey(ctx, p, projectId)
	if err != nil {
		return nil, "", nil, err
	}

	switch bag.ResourceTypeID() {
	case resourceTypeGroup.Id:
		groupsPermissions, nextPageToken, err = p.client.ListGroupProjectsPermissions(ctx, client.PageOptions{
			PerPage: ITEMSPERPAGE,
			Page:    pageToken,
		}, projectKey)
		if err != nil {
			return nil, "", nil, err
		}

		err = bag.Next(nextPageToken)
		if err != nil {
			return nil, "", nil, err
		}

		for _, member := range groupsPermissions {
			grpCppy := member.Group
			ur, err := groupResource(ctx, grpCppy.Name, resource.Id)
			if err != nil {
				return nil, "", nil, fmt.Errorf("error creating group resource for repository %s: %w", resource.Id.Resource, err)
			}

			membershipGrant := grant.NewGrant(resource, member.Permission, ur.Id)
			rv = append(rv, membershipGrant)
		}
	case resourceTypeUser.Id:
		usersPermissions, nextPageToken, err = p.client.ListUserProjectsPermissions(ctx, client.PageOptions{
			PerPage: ITEMSPERPAGE,
			Page:    pageToken,
		}, projectKey)
		if err != nil {
			return nil, "", nil, err
		}

		err = bag.Next(nextPageToken)
		if err != nil {
			return nil, "", nil, err
		}

		for _, member := range usersPermissions {
			usrCppy := member.User
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
				return nil, "", nil, fmt.Errorf("error creating user resource for project %s: %w", resource.Id.Resource, err)
			}

			membershipGrant := grant.NewGrant(resource, member.Permission, ur.Id)
			rv = append(rv, membershipGrant)
		}
	default:
		return nil, "", nil, fmt.Errorf("bitbucket(dc)-connector: invalid grant resource type: %s", bag.ResourceTypeID())
	}

	nextPageToken, err = bag.Marshal()
	if err != nil {
		return nil, "", nil, err
	}

	return rv, nextPageToken, nil, nil
}

func (p *projectBuilder) Grant(ctx context.Context, principal *v2.Resource, entitlement *v2.Entitlement) (annotations.Annotations, error) {
	var projectKey, permission string
	l := ctxzap.Extract(ctx)
	if principal.Id.ResourceType != resourceTypeUser.Id && principal.Id.ResourceType != resourceTypeGroup.Id {
		l.Warn(
			"bitbucket(dc)-connector: only users or groups can be granted project membership",
			zap.String("principal_type", principal.Id.ResourceType),
			zap.String("principal_id", principal.Id.Resource),
		)
		return nil, fmt.Errorf("bitbucket(dc)-connector: only users or groups can be granted project membership")
	}

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

	projectId, err := strconv.Atoi(entitlement.Resource.Id.Resource)
	if err != nil {
		return nil, err
	}

	projectKey, err = getProjectKey(ctx, p, projectId)
	if err != nil {
		return nil, err
	}

	switch principal.Id.ResourceType {
	case resourceTypeUser.Id:
		userId, err := strconv.Atoi(principal.Id.Resource)
		if err != nil {
			return nil, err
		}

		listUser, err := listUserProjectsPermissions(ctx, p.client, projectKey)
		if err != nil {
			return nil, err
		}

		userPos := slices.IndexFunc(listUser, func(c client.UsersPermissions) bool {
			return c.User.Name == principal.DisplayName && c.Permission == permission
		})
		if userPos != NF {
			l.Warn(
				"bitbucket(dc)-connector: user already has this project permission",
				zap.String("principal_id", principal.Id.String()),
				zap.String("principal_type", principal.Id.ResourceType),
			)
			return nil, fmt.Errorf("bitbucket(dc)-connector: user %s already has this project permission", principal.DisplayName)
		}

		err = p.client.UpdateUserProjectPermission(ctx, projectKey, principal.DisplayName, permission)
		if err != nil {
			return nil, err
		}

		l.Warn("Project Membership has been created.",
			zap.Int64("UserID", int64(userId)),
			zap.String("UserName", principal.DisplayName),
			zap.String("ProjectKey", projectKey),
			zap.String("Permission", permission),
		)
	case resourceTypeGroup.Id:
		listGroup, err := listGroupProjectsPermissions(ctx, p.client, projectKey)
		if err != nil {
			return nil, err
		}

		groupPos := slices.IndexFunc(listGroup, func(c client.GroupsPermissions) bool {
			return c.Group.Name == principal.DisplayName && c.Permission == permission
		})
		if groupPos != NF {
			l.Warn(
				"bitbucket(dc)-connector: group already has this project permission",
				zap.String("principal_id", principal.Id.String()),
				zap.String("principal_type", principal.Id.ResourceType),
			)
			return nil, fmt.Errorf("bitbucket(dc)-connector: group %s already has this project permission", principal.DisplayName)
		}

		err = p.client.UpdateGroupProjectPermission(ctx, projectKey, principal.DisplayName, permission)
		if err != nil {
			return nil, err
		}

		l.Warn("Project Membership has been created.",
			zap.String("GroupName", principal.DisplayName),
			zap.String("ProjectKey", projectKey),
			zap.String("Permission", permission),
		)
	default:
		return nil, fmt.Errorf("bitbucket(dc) connector: invalid grant resource type: %s", principal.Id.ResourceType)
	}

	return nil, nil
}

func (p *projectBuilder) Revoke(ctx context.Context, grant *v2.Grant) (annotations.Annotations, error) {
	var projectKey, repositorySlug, permission string
	l := ctxzap.Extract(ctx)
	principal := grant.Principal
	entitlement := grant.Entitlement
	principalIsUser := principal.Id.ResourceType == resourceTypeUser.Id
	principalIsGroup := principal.Id.ResourceType == resourceTypeGroup.Id
	if !principalIsUser && !principalIsGroup {
		l.Warn(
			"bitbucket(bk)-connector: only users and groups can have repository permissions revoked",
			zap.String("principal_id", principal.Id.Resource),
			zap.String("principal_type", principal.Id.ResourceType),
		)

		return nil, fmt.Errorf("bitbucket(bk)-connector: only users and groups can have repository permissions revoked")
	}

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

	projectId, err := strconv.Atoi(entitlement.Resource.Id.Resource)
	if err != nil {
		return nil, err
	}

	projectKey, err = getProjectKey(ctx, p, projectId)
	if err != nil {
		return nil, err
	}

	switch principal.Id.ResourceType {
	case resourceTypeUser.Id:
		userName := principal.DisplayName
		userId, err := strconv.Atoi(principal.Id.Resource)
		if err != nil {
			return nil, err
		}

		listUser, err := listUserProjectsPermissions(ctx, p.client, projectKey)
		if err != nil {
			return nil, err
		}

		userPos := slices.IndexFunc(listUser, func(c client.UsersPermissions) bool {
			return c.User.Name == userName && c.Permission == permission
		})
		if userPos == NF {
			l.Warn(
				"bitbucket(dc)-connector: user doesn't have this project permission",
				zap.String("principal_id", principal.Id.String()),
				zap.String("principal_type", principal.Id.ResourceType),
			)
			return nil, fmt.Errorf("bitbucket(dc)-connector: user %s doesn't have this project permission", userName)
		}

		err = p.client.RevokeUserProjectPermission(ctx, projectKey, userName)
		if err != nil {
			return nil, fmt.Errorf("bitbucket(dc)-connector: failed to remove repository user permission: %w", err)
		}

		l.Warn("Project Membership has been revoked.",
			zap.Int64("UserID", int64(userId)),
			zap.String("UserName", userName),
			zap.String("ProjectKey", projectKey),
			zap.String("RepositorySlug", repositorySlug),
		)
	case resourceTypeGroup.Id:
		groupName := principal.DisplayName
		listGroup, err := listGroupProjectsPermissions(ctx, p.client, projectKey)
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

		err = p.client.RevokeGroupProjectPermission(ctx, projectKey, groupName)
		if err != nil {
			return nil, fmt.Errorf("bitbucket(dc)-connector: failed to remove repository group permission: %w", err)
		}

		l.Warn("Project Membership has been revoked.",
			zap.String("GroupName", groupName),
			zap.String("ProjectKey", projectKey),
			zap.String("RepositorySlug", repositorySlug),
		)
	default:
		return nil, fmt.Errorf("bitbucket(dc) connector: invalid grant resource type: %s", principal.Id.ResourceType)
	}

	return nil, nil
}

func newProjectBuilder(c *client.DataCenterClient) *projectBuilder {
	return &projectBuilder{
		resourceType: resourceTypeProject,
		client:       c,
	}
}
