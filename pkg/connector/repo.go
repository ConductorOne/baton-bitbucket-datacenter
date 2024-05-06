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
	roleRepoCreate = "CREATE-REPO"
	roleRepoAdmin  = "REPO_ADMIN"
)

var repositoryRoles = []string{roleRepoRead, roleRepoWrite, roleRepoAdmin, roleRepoCreate}

func (r *repoBuilder) ResourceType(ctx context.Context) *v2.ResourceType {
	return r.resourceType
}

// List returns all the repos from the database as resource objects.
// Repos include a RepoTrait because they are the 'shape' of a standard repository.
func (r *repoBuilder) List(ctx context.Context, parentResourceID *v2.ResourceId, pToken *pagination.Token) ([]*v2.Resource, string, annotations.Annotations, error) {
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
			ResourceTypeID: resourceTypeRepository.Id,
		})
	}

	if bag.Current().Token != "" {
		pageToken, err = strconv.Atoi(bag.Current().Token)
		if err != nil {
			return nil, "", nil, err
		}
	}

	repos, nextPageToken, err := r.client.ListRepos(ctx, client.PageOptions{
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

	for _, repo := range repos {
		repoCopy := repo
		ur, err := repositoryResource(ctx, &repoCopy, parentResourceID)
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
func (r *repoBuilder) Entitlements(_ context.Context, resource *v2.Resource, _ *pagination.Token) ([]*v2.Entitlement, string, annotations.Annotations, error) {
	var rv []*v2.Entitlement
	// create entitlements for each repository role (read, write, admin)
	for _, role := range repositoryRoles {
		permissionOptions := []ent.EntitlementOption{
			ent.WithGrantableTo(resourceTypeUser, resourceTypeGroup),
			ent.WithDisplayName(fmt.Sprintf("%s Repository %s", resource.DisplayName, role)),
			ent.WithDescription(fmt.Sprintf("%s access to %s repository in Bitbucket DC", titleCase(role), resource.DisplayName)),
		}

		rv = append(rv, ent.NewPermissionEntitlement(
			resource,
			role,
			permissionOptions...,
		))
	}

	return rv, "", nil, nil
}

func (r *repoBuilder) Grants(ctx context.Context, resource *v2.Resource, pToken *pagination.Token) ([]*v2.Grant, string, annotations.Annotations, error) {
	var (
		pageToken         int
		err               error
		rv                []*v2.Grant
		projectKey        string
		ok                bool
		nextPageToken     string
		usersPermissions  []client.UsersPermissions
		groupsPermissions []client.GroupsPermissions
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

	groupTrait, err := rs.GetGroupTrait(resource)
	if err != nil {
		return nil, "", nil, err
	}

	if projectKey, ok = rs.GetProfileStringValue(groupTrait.Profile, "repository_project_key"); !ok {
		return nil, "", nil, fmt.Errorf("repository_project_key not found")
	}

	switch bag.ResourceTypeID() {
	case resourceTypeGroup.Id:
		groupsPermissions, nextPageToken, err = r.client.ListGroupRepositoryPermissions(ctx, client.PageOptions{
			PerPage: ITEMSPERPAGE,
			Page:    pageToken,
		}, projectKey, resource.DisplayName)
		if err != nil {
			return nil, "", nil, err
		}

		err = bag.Next(nextPageToken)
		if err != nil {
			return nil, "", nil, err
		}

		// create a permission grant for each group in the repository
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
		usersPermissions, nextPageToken, err = r.client.ListUserRepositoryPermissions(ctx, client.PageOptions{
			PerPage: ITEMSPERPAGE,
			Page:    pageToken,
		}, projectKey, resource.DisplayName)
		if err != nil {
			return nil, "", nil, err
		}

		err = bag.Next(nextPageToken)
		if err != nil {
			return nil, "", nil, err
		}

		// create a permission grant for each user in the repository
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
				return nil, "", nil, fmt.Errorf("error creating user resource for repository %s: %w", resource.Id.Resource, err)
			}

			membershipGrant := grant.NewGrant(resource, member.Permission, ur.Id)
			rv = append(rv, membershipGrant)
		}
	default:
		return nil, "", nil, fmt.Errorf("bitbucket-dc connector: invalid grant resource type: %s", bag.ResourceTypeID())
	}

	nextPageToken, err = bag.Marshal()
	if err != nil {
		return nil, "", nil, err
	}

	return rv, nextPageToken, nil, nil
}

func (r *repoBuilder) Grant(ctx context.Context, principal *v2.Resource, entitlement *v2.Entitlement) (annotations.Annotations, error) {
	var (
		projectKey     string
		ok             bool
		repositorySlug string
	)
	l := ctxzap.Extract(ctx)
	if principal.Id.ResourceType != resourceTypeUser.Id && principal.Id.ResourceType != resourceTypeGroup.Id {
		l.Warn(
			"bitbucker(bk)-connector: only users or groups can be granted repo membership",
			zap.String("principal_type", principal.Id.ResourceType),
			zap.String("principal_id", principal.Id.Resource),
		)
		return nil, fmt.Errorf("bitbucker(bk)-connector: only users or groups can be granted repo membership")
	}

	_, _, err := ParseEntitlementID(entitlement.Id)
	if err != nil {
		return nil, err
	}

	groupTrait, err := rs.GetGroupTrait(entitlement.Resource)
	if err != nil {
		return nil, err
	}

	if projectKey, ok = rs.GetProfileStringValue(groupTrait.Profile, "repository_project_key"); !ok {
		return nil, fmt.Errorf("repository_project_key not found")
	}

	if repositorySlug, ok = rs.GetProfileStringValue(groupTrait.Profile, "repository_full_name"); !ok {
		return nil, fmt.Errorf("repository_full_name not found")
	}

	switch principal.Id.ResourceType {
	case resourceTypeUser.Id:
		userId, err := strconv.Atoi(principal.Id.Resource)
		if err != nil {
			return nil, err
		}

		listUsers, _, err := r.client.ListUserRepositoryPermissions(ctx, client.PageOptions{
			PerPage: ITEMSPERPAGE,
			Page:    0,
		}, projectKey, repositorySlug)
		if err != nil {
			return nil, err
		}

		index := slices.IndexFunc(listUsers, func(c client.UsersPermissions) bool {
			return c.User.ID == userId
		})

		if index != -1 {
			l.Warn(
				"bitbucket(dc)-connector: user already got permision to the repository",
				zap.String("principal_id", principal.Id.String()),
				zap.String("principal_type", principal.Id.ResourceType),
			)
			return nil, fmt.Errorf("bitbucket(dc)-connector: user already got permision to the repository")
		}

		err = r.client.UpdateUserRepositoryPermission(ctx, projectKey, repositorySlug, principal.DisplayName)
		if err != nil {
			return nil, err
		}

		l.Warn("User Membership has been created.",
			zap.Int64("UserID", int64(userId)),
			zap.String("UserName", principal.DisplayName),
			zap.String("ProjectKey", projectKey),
			zap.String("RepositorySlug", repositorySlug),
		)
	case resourceTypeGroup.Id:
		listGroups, _, err := r.client.ListGroupRepositoryPermissions(ctx, client.PageOptions{
			PerPage: ITEMSPERPAGE,
			Page:    0,
		}, projectKey, repositorySlug)
		if err != nil {
			return nil, err
		}

		index := slices.IndexFunc(listGroups, func(c client.GroupsPermissions) bool {
			return c.Group.Name == principal.DisplayName
		})

		if index != -1 {
			l.Warn(
				"bitbucket(dc)-connector: group already got permision to the repository",
				zap.String("principal_id", principal.Id.String()),
				zap.String("principal_type", principal.Id.ResourceType),
			)
			return nil, fmt.Errorf("bitbucket(dc)-connector: group already got permision to the repository")
		}

		err = r.client.UpdateGrouprRepositoryPermission(ctx, projectKey, repositorySlug, principal.DisplayName)
		if err != nil {
			return nil, err
		}

		l.Warn("Group Membership has been created.",
			zap.String("GroupName", principal.DisplayName),
			zap.String("ProjectKey", projectKey),
			zap.String("RepositorySlug", repositorySlug),
		)
	default:
		return nil, fmt.Errorf("bitbucket-dc connector: invalid grant resource type: %s", principal.Id.ResourceType)
	}

	return nil, nil
}

func (r *repoBuilder) Revoke(ctx context.Context, grant *v2.Grant) (annotations.Annotations, error) {
	return nil, nil
}

func newRepoBuilder(c *client.DataCenterClient) *repoBuilder {
	return &repoBuilder{
		resourceType: resourceTypeRepository,
		client:       c,
	}
}
