package connector

import (
	"context"
	"fmt"
	"slices"

	"github.com/conductorone/baton-bitbucket-datacenter/pkg/client"
	v2 "github.com/conductorone/baton-sdk/pb/c1/connector/v2"
	"github.com/conductorone/baton-sdk/pkg/annotations"
	"github.com/conductorone/baton-sdk/pkg/pagination"
	ent "github.com/conductorone/baton-sdk/pkg/types/entitlement"
	"github.com/conductorone/baton-sdk/pkg/types/grant"
	rs "github.com/conductorone/baton-sdk/pkg/types/resource"
	"github.com/grpc-ecosystem/go-grpc-middleware/logging/zap/ctxzap"
	"go.uber.org/zap"
)

type repoBuilder struct {
	resourceType *v2.ResourceType
	client       *client.DataCenterClient
}

const (
	roleRepoRead   = "REPO_READ"
	roleRepoWrite  = "REPO_WRITE"
	roleRepoCreate = "REPO_CREATE"
	roleRepoAdmin  = "REPO_ADMIN"
)

var repositoryRoles = []string{roleRepoRead, roleRepoWrite, roleRepoAdmin, roleRepoCreate}

// Create a new connector resource for an Bitbucket Repository.
func repositoryResource(_ context.Context, repository *client.Repos, parentResourceID *v2.ResourceId) (*v2.Resource, error) {
	profile := map[string]interface{}{
		"repository_id":          repository.ID,
		"repository_name":        repository.Name,
		"repository_full_name":   repository.Slug,
		"repository_project_key": repository.Project.Key,
	}

	groupTraitOptions := []rs.GroupTraitOption{rs.WithGroupProfile(profile)}
	displayName := fmt.Sprintf("%s/%s", repository.Project.Key, repository.Slug)
	resource, err := rs.NewGroupResource(
		displayName,
		resourceTypeRepository,
		makeRepositoryID(repository.Project.Key, repository.Slug),
		groupTraitOptions,
		rs.WithParentResourceID(parentResourceID),
	)
	if err != nil {
		return nil, err
	}

	return resource, nil
}

func (r *repoBuilder) ResourceType(ctx context.Context) *v2.ResourceType {
	return r.resourceType
}

// List returns all the repos from the database as resource objects.
// Repos include a RepoTrait because they are the 'shape' of a standard repository.
func (r *repoBuilder) List(ctx context.Context, parentResourceID *v2.ResourceId, pToken *pagination.Token) ([]*v2.Resource, string, annotations.Annotations, error) {
	var rv []*v2.Resource

	repos, nextPageToken, err := r.client.GetRepos(ctx, pToken)
	if err != nil {
		return nil, "", nil, err
	}

	for _, repo := range repos {
		repoCopy := repo
		if parentResourceID == nil {
			parentResourceID = &v2.ResourceId{
				Resource:     repo.Project.Key,
				ResourceType: resourceTypeProject.Id,
			}
		}
		ur, err := repositoryResource(ctx, &repoCopy, parentResourceID)
		if err != nil {
			return nil, "", nil, err
		}
		rv = append(rv, ur)
	}

	return rv, nextPageToken, nil, nil
}

func (r *repoBuilder) Entitlements(_ context.Context, resource *v2.Resource, _ *pagination.Token) ([]*v2.Entitlement, string, annotations.Annotations, error) {
	var rv []*v2.Entitlement
	// create entitlements for each repository role (read, write, admin)
	for _, permission := range repositoryRoles {
		permissionOptions := []ent.EntitlementOption{
			ent.WithGrantableTo(resourceTypeUser, resourceTypeGroup),
			ent.WithDisplayName(fmt.Sprintf("%s Repository %s", resource.DisplayName, permission)),
			ent.WithDescription(fmt.Sprintf("%s access to %s - %s repository in Bitbucket DC", titleCase(permission), resource.Id.Resource, resource.DisplayName)),
		}
		rv = append(rv, ent.NewPermissionEntitlement(
			resource,
			permission,
			permissionOptions...,
		))
	}

	return rv, "", nil, nil
}

func (r *repoBuilder) Grants(ctx context.Context, resource *v2.Resource, pToken *pagination.Token) ([]*v2.Grant, string, annotations.Annotations, error) {
	var (
		rv                []*v2.Grant
		nextPageToken     string
		usersPermissions  []client.UsersPermissions
		groupsPermissions []client.GroupsPermissions
	)

	defaultPageState := []pagination.PageState{
		{ResourceTypeID: resourceTypeGroup.Id},
		{ResourceTypeID: resourceTypeUser.Id},
	}

	pToken, bag, err := parseToken(pToken, defaultPageState)
	if err != nil {
		return nil, "", nil, err
	}

	projectKey, repoSlug, err := parseRepositoryID(resource.Id.Resource)
	if err != nil {
		return nil, "", nil, err
	}

	switch bag.ResourceTypeID() {
	case resourceTypeGroup.Id:
		groupsPermissions, nextPageToken, err = r.client.GetGroupRepositoryPermissions(ctx, projectKey, repoSlug, pToken)
		if err != nil {
			return nil, "", nil, err
		}

		// create a permission grant for each group in the repository
		for _, member := range groupsPermissions {
			gr, err := groupResource(ctx, member.Group.Name, nil)
			if err != nil {
				return nil, "", nil, fmt.Errorf("error creating group resource %s for repository %s: %w", member.Group.Name, resource.Id.Resource, err)
			}

			grantOpt := grant.WithAnnotation(&v2.GrantExpandable{
				EntitlementIds: []string{
					fmt.Sprintf("group:%s:member", gr.Id.Resource),
				},
			})
			permissionGrant := grant.NewGrant(resource, member.Permission, gr.Id, grantOpt)
			rv = append(rv, permissionGrant)
		}
	case resourceTypeUser.Id:
		usersPermissions, nextPageToken, err = r.client.GetUserRepositoryPermissions(ctx, projectKey, repoSlug, pToken)
		if err != nil {
			return nil, "", nil, err
		}

		// create a permission grant for each user in the repository
		for _, member := range usersPermissions {
			usrCppy := member.User
			ur, err := userResource(ctx, &usrCppy, resource.Id, nil)
			if err != nil {
				return nil, "", nil, fmt.Errorf("error creating user resource for repository %s: %w", resource.Id.Resource, err)
			}

			membershipGrant := grant.NewGrant(resource, member.Permission, ur.Id)
			rv = append(rv, membershipGrant)
		}
	default:
		return nil, "", nil, fmt.Errorf("bitbucket(dc) connector: invalid grant resource type: %s", bag.ResourceTypeID())
	}

	return rv, nextPageToken, nil, nil
}

func (r *repoBuilder) Grant(ctx context.Context, principal *v2.Resource, entitlement *v2.Entitlement) (annotations.Annotations, error) {
	l := ctxzap.Extract(ctx)
	if principal.Id.ResourceType != resourceTypeUser.Id && principal.Id.ResourceType != resourceTypeGroup.Id {
		l.Error(
			"bitbucker(bk)-connector: only users or groups can be granted repo membership",
			zap.String("principal_type", principal.Id.ResourceType),
			zap.String("principal_id", principal.Id.Resource),
		)
		return nil, fmt.Errorf("bitbucker(bk)-connector: only users or groups can be granted repo membership")
	}

	_, permission, err := ParseEntitlementID(entitlement.Id)
	if err != nil {
		return nil, err
	}

	switch permission {
	case roleRepoWrite, roleRepoAdmin, roleRepoRead:
	default:
		return nil, fmt.Errorf("bitbucket(dc) connector: invalid permission type: %s", permission)
	}

	projectKey, repoSlug, err := parseRepositoryID(entitlement.Resource.Id.Resource)
	if err != nil {
		return nil, err
	}

	switch principal.Id.ResourceType {
	case resourceTypeUser.Id:
		userName := principal.DisplayName

		userRepositoryPermissions, err := listUserRepositoryPermissions(ctx, r.client, projectKey, repoSlug)
		if err != nil {
			return nil, err
		}

		index := slices.IndexFunc(userRepositoryPermissions, func(c client.UsersPermissions) bool {
			return c.User.Name == userName
		})
		if index >= 0 {
			l.Info(
				"bitbucket(dc)-connector: user already has this repository permission",
				zap.String("principal_id", principal.Id.String()),
				zap.String("principal_type", principal.Id.ResourceType),
			)
			return annotations.New(&v2.GrantAlreadyExists{}), nil
		}

		err = r.client.UpdateUserRepositoryPermission(ctx,
			projectKey,
			repoSlug,
			userName,
			permission,
		)
		if err != nil {
			return nil, err
		}

		l.Info("User Membership has been created.",
			zap.String("UserName", userName),
			zap.String("ProjectKey", projectKey),
			zap.String("RepositorySlug", repoSlug),
		)
	case resourceTypeGroup.Id:
		groupName := principal.DisplayName
		groupRepositoryPermissions, err := listGroupRepositoryPermissions(ctx, r.client, projectKey, repoSlug)
		if err != nil {
			return nil, err
		}

		groupsPermissionsPos := slices.IndexFunc(groupRepositoryPermissions, func(c client.GroupsPermissions) bool {
			return c.Group.Name == groupName
		})
		if groupsPermissionsPos >= 0 {
			l.Info(
				"bitbucket(dc)-connector: group already has this repository permission",
				zap.String("principal_id", principal.Id.String()),
				zap.String("principal_type", principal.Id.ResourceType),
			)
			return annotations.New(&v2.GrantAlreadyExists{}), nil
		}

		err = r.client.UpdateGroupRepositoryPermission(ctx,
			projectKey,
			repoSlug,
			groupName,
			permission,
		)
		if err != nil {
			return nil, err
		}

		l.Info("Group Membership has been created.",
			zap.String("GroupName", groupName),
			zap.String("ProjectKey", projectKey),
			zap.String("RepositorySlug", repoSlug),
		)
	default:
		return nil, fmt.Errorf("bitbucket(dc) connector: invalid grant resource type: %s", principal.Id.ResourceType)
	}

	return nil, nil
}

func (r *repoBuilder) Revoke(ctx context.Context, grant *v2.Grant) (annotations.Annotations, error) {
	l := ctxzap.Extract(ctx)
	principal := grant.Principal
	entitlement := grant.Entitlement
	principalIsUser := principal.Id.ResourceType == resourceTypeUser.Id
	principalIsGroup := principal.Id.ResourceType == resourceTypeGroup.Id
	if !principalIsUser && !principalIsGroup {
		l.Error(
			"bitbucket(bk)-connector: only users and groups can have repository permissions revoked",
			zap.String("principal_id", principal.Id.Resource),
			zap.String("principal_type", principal.Id.ResourceType),
		)

		return nil, fmt.Errorf("bitbucket(bk)-connector: only users and groups can have repository permissions revoked")
	}

	_, _, err := ParseEntitlementID(entitlement.Id)
	if err != nil {
		return nil, err
	}

	projectKey, repoSlug, err := parseRepositoryID(entitlement.Resource.Id.Resource)
	if err != nil {
		return nil, err
	}

	switch principal.Id.ResourceType {
	case resourceTypeUser.Id:
		listUsers, err := listUserRepositoryPermissions(ctx, r.client, projectKey, repoSlug)
		if err != nil {
			return nil, err
		}

		index := slices.IndexFunc(listUsers, func(c client.UsersPermissions) bool {
			return c.User.Name == principal.Id.Resource
		})
		if index < 0 {
			l.Info(
				"bitbucket(dc)-connector: user doesnt have this repository permission",
				zap.String("principal_id", principal.Id.String()),
				zap.String("principal_type", principal.Id.ResourceType),
			)
			return annotations.New(&v2.GrantAlreadyRevoked{}), nil
		}

		err = r.client.RevokeUserRepositoryPermission(ctx, projectKey, repoSlug, principal.DisplayName)
		if err != nil {
			return nil, fmt.Errorf("bitbucket(dc)-connector: failed to remove repository user permission: %w", err)
		}

		l.Info("User Membership has been revoked.",
			zap.String("UserName", principal.DisplayName),
			zap.String("ProjectKey", projectKey),
			zap.String("RepositorySlug", repoSlug),
		)
	case resourceTypeGroup.Id:
		listGroups, err := listGroupRepositoryPermissions(ctx, r.client, projectKey, repoSlug)
		if err != nil {
			return nil, err
		}

		index := slices.IndexFunc(listGroups, func(c client.GroupsPermissions) bool {
			return c.Group.Name == principal.DisplayName
		})
		if index < 0 {
			l.Info(
				"bitbucket(dc)-connector: group doesnt have this repository permission",
				zap.String("principal_id", principal.Id.String()),
				zap.String("principal_type", principal.Id.ResourceType),
			)
			return annotations.New(&v2.GrantAlreadyRevoked{}), nil
		}

		err = r.client.RevokeGroupRepositoryPermission(ctx, projectKey, repoSlug, principal.DisplayName)
		if err != nil {
			return nil, fmt.Errorf("bitbucket(dc)-connector: failed to remove repository group permission: %w", err)
		}

		l.Info("Group Membership has been revoked.",
			zap.String("GroupName", principal.DisplayName),
			zap.String("ProjectKey", projectKey),
			zap.String("RepositorySlug", repoSlug),
		)
	default:
		return nil, fmt.Errorf("bitbucket(dc) connector: invalid grant resource type: %s", principal.Id.ResourceType)
	}

	return nil, nil
}

func newRepoBuilder(c *client.DataCenterClient) *repoBuilder {
	return &repoBuilder{
		resourceType: resourceTypeRepository,
		client:       c,
	}
}
