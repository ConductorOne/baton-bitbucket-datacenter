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

// Create a new connector resource for an Bitbucket Project.
func projectResource(_ context.Context, project *client.Projects, parentResourceID *v2.ResourceId) (*v2.Resource, error) {
	profile := map[string]interface{}{
		"project_id":   project.ID,
		"project_name": project.Name,
		"project_key":  project.Key,
	}

	displayName := fmt.Sprintf("%s (%s)", project.Key, project.Name)
	groupTraitOptions := []rs.GroupTraitOption{rs.WithGroupProfile(profile)}
	resource, err := rs.NewGroupResource(
		displayName,
		resourceTypeProject,
		project.Key,
		groupTraitOptions,
		rs.WithParentResourceID(parentResourceID),
	)

	if err != nil {
		return nil, err
	}

	return resource, nil
}

type projectBuilder struct {
	resourceType *v2.ResourceType
	client       *client.DataCenterClient
}

const (
	roleProjectRead  = "PROJECT_READ"
	roleProjectWrite = "PROJECT_WRITE"
	roleProjectAdmin = "PROJECT_ADMIN"
)

var projectPermissions = []string{roleProjectRead, roleProjectWrite, roleProjectAdmin, roleRepoCreate}

func (p *projectBuilder) ResourceType(ctx context.Context) *v2.ResourceType {
	return p.resourceType
}

// List returns all the projects from the database as resource objects.
// Projects include a ProjectTrait because they are the 'shape' of a standard project.
func (p *projectBuilder) List(ctx context.Context, parentResourceID *v2.ResourceId, pToken *pagination.Token) ([]*v2.Resource, string, annotations.Annotations, error) {
	var rv []*v2.Resource

	projects, nextPageToken, err := p.client.GetProjects(ctx, pToken)
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

	return rv, nextPageToken, nil, nil
}

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
		rv                []*v2.Grant
		nextPageToken     string
		usersPermissions  []client.UsersPermissions
		groupsPermissions []client.GroupsPermissions
		err               error
	)

	defaultPageState := []pagination.PageState{
		{ResourceTypeID: resourceTypeGroup.Id},
		{ResourceTypeID: resourceTypeUser.Id},
	}
	pToken, bag, err := parseToken(pToken, defaultPageState)
	if err != nil {
		return nil, "", nil, err
	}

	projectKey := resource.Id.Resource

	switch bag.ResourceTypeID() {
	case resourceTypeGroup.Id:
		groupsPermissions, nextPageToken, err = p.client.GetGroupProjectsPermissions(ctx, projectKey, pToken)
		if err != nil {
			return nil, "", nil, err
		}

		for _, member := range groupsPermissions {
			gr, err := groupResource(ctx, member.Group.Name, nil)
			if err != nil {
				return nil, "", nil, fmt.Errorf("error creating group resource %s for project %s: %w", member.Group.Name, resource.Id.Resource, err)
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
		usersPermissions, nextPageToken, err = p.client.GetUserProjectsPermissions(ctx, projectKey, pToken)
		if err != nil {
			return nil, "", nil, err
		}

		for _, member := range usersPermissions {
			usrCppy := member.User
			ur, err := userResource(ctx, &client.User{
				Name:         usrCppy.Name,
				EmailAddress: usrCppy.EmailAddress,
				Active:       usrCppy.Active,
				DisplayName:  usrCppy.DisplayName,
				ID:           usrCppy.ID,
				Slug:         usrCppy.Slug,
				Type:         usrCppy.Type,
			}, resource.Id, nil)
			if err != nil {
				return nil, "", nil, fmt.Errorf("error creating user resource for project %s: %w", resource.Id.Resource, err)
			}

			membershipGrant := grant.NewGrant(resource, member.Permission, ur.Id)
			rv = append(rv, membershipGrant)
		}
	default:
		return nil, "", nil, fmt.Errorf("bitbucket(dc)-connector: invalid grant resource type: %s", bag.ResourceTypeID())
	}

	return rv, nextPageToken, nil, nil
}

func (p *projectBuilder) Grant(ctx context.Context, principal *v2.Resource, entitlement *v2.Entitlement) (annotations.Annotations, error) {
	l := ctxzap.Extract(ctx)
	if principal.Id.ResourceType != resourceTypeUser.Id && principal.Id.ResourceType != resourceTypeGroup.Id {
		l.Error(
			"bitbucket(dc)-connector: only users or groups can be granted project membership",
			zap.String("principal_type", principal.Id.ResourceType),
			zap.String("principal_id", principal.Id.Resource),
		)
		return nil, fmt.Errorf("bitbucket(dc)-connector: only users or groups can be granted project membership")
	}

	_, permission, err := ParseEntitlementID(entitlement.Id)
	if err != nil {
		return nil, err
	}

	switch permission {
	case roleProjectWrite, roleProjectAdmin, roleProjectRead, roleRepoCreate:
	default:
		return nil, fmt.Errorf("bitbucket(dc)-connector: invalid permission type: %s", permission)
	}

	projectKey := entitlement.Resource.Id.Resource

	switch principal.Id.ResourceType {
	case resourceTypeUser.Id:
		listUser, err := listUserProjectsPermissions(ctx, p.client, projectKey)
		if err != nil {
			return nil, err
		}

		userPos := slices.IndexFunc(listUser, func(c client.UsersPermissions) bool {
			return c.User.Name == principal.Id.Resource && c.Permission == permission
		})
		if userPos >= 0 {
			l.Info(
				"bitbucket(dc)-connector: user already has this project permission",
				zap.String("principal_id", principal.Id.String()),
				zap.String("principal_type", principal.Id.ResourceType),
			)
			return annotations.New(&v2.GrantAlreadyExists{}), nil
		}

		err = p.client.UpdateUserProjectPermission(ctx, projectKey, principal.Id.Resource, permission)
		if err != nil {
			return nil, err
		}

		l.Info("Project Membership has been created.",
			zap.String("UserName", principal.Id.Resource),
			zap.String("ProjectKey", projectKey),
			zap.String("Permission", permission),
		)
	case resourceTypeGroup.Id:
		listGroup, err := listGroupProjectsPermissions(ctx, p.client, projectKey)
		if err != nil {
			return nil, err
		}

		groupPos := slices.IndexFunc(listGroup, func(c client.GroupsPermissions) bool {
			return c.Group.Name == principal.Id.Resource && c.Permission == permission
		})
		if groupPos >= 0 {
			l.Info(
				"bitbucket(dc)-connector: group already has this project permission",
				zap.String("principal_id", principal.Id.String()),
				zap.String("principal_type", principal.Id.ResourceType),
			)
			return annotations.New(&v2.GrantAlreadyRevoked{}), nil
		}

		err = p.client.UpdateGroupProjectPermission(ctx, projectKey, principal.Id.Resource, permission)
		if err != nil {
			return nil, err
		}

		l.Info("Project Membership has been created.",
			zap.String("GroupName", principal.DisplayName),
			zap.String("ProjectKey", projectKey),
			zap.String("Permission", permission),
		)
	default:
		return nil, fmt.Errorf("bitbucket(dc)-connector: invalid grant resource type: %s", principal.Id.ResourceType)
	}

	return nil, nil
}

func (p *projectBuilder) Revoke(ctx context.Context, grant *v2.Grant) (annotations.Annotations, error) {
	l := ctxzap.Extract(ctx)
	principal := grant.Principal
	entitlement := grant.Entitlement
	principalIsUser := principal.Id.ResourceType == resourceTypeUser.Id
	principalIsGroup := principal.Id.ResourceType == resourceTypeGroup.Id
	if !principalIsUser && !principalIsGroup {
		l.Error(
			"bitbucket(bk)-connector: only users and groups can have project permissions revoked",
			zap.String("principal_id", principal.Id.Resource),
			zap.String("principal_type", principal.Id.ResourceType),
		)

		return nil, fmt.Errorf("bitbucket(bk)-connector: only users and groups can have project permissions revoked")
	}

	_, permission, err := ParseEntitlementID(entitlement.Id)
	if err != nil {
		return nil, err
	}

	switch permission {
	case roleProjectWrite, roleProjectAdmin, roleProjectRead, roleRepoCreate:
	default:
		return nil, fmt.Errorf("bitbucket(dc)-connector: invalid permission type: %s", permission)
	}

	projectKey := entitlement.Resource.Id.Resource

	switch principal.Id.ResourceType {
	case resourceTypeUser.Id:
		userName := principal.Id.Resource

		listUser, err := listUserProjectsPermissions(ctx, p.client, projectKey)
		if err != nil {
			return nil, err
		}

		userPos := slices.IndexFunc(listUser, func(c client.UsersPermissions) bool {
			return c.User.Name == userName && c.Permission == permission
		})
		if userPos < 0 {
			l.Info(
				"bitbucket(dc)-connector: user doesn't have this project permission",
				zap.String("principal_id", principal.Id.String()),
				zap.String("principal_type", principal.Id.ResourceType),
			)
			return annotations.New(&v2.GrantAlreadyRevoked{}), nil
		}

		err = p.client.RevokeUserProjectPermission(ctx, projectKey, userName)
		if err != nil {
			return nil, fmt.Errorf("bitbucket(dc)-connector: failed to remove project user permission: %w", err)
		}

		l.Info("Project Membership has been revoked.",
			zap.String("UserName", userName),
			zap.String("ProjectKey", projectKey),
		)
	case resourceTypeGroup.Id:
		groupName := principal.Id.Resource
		listGroup, err := listGroupProjectsPermissions(ctx, p.client, projectKey)
		if err != nil {
			return nil, err
		}

		groupPos := slices.IndexFunc(listGroup, func(c client.GroupsPermissions) bool {
			return c.Group.Name == groupName && c.Permission == permission
		})
		if groupPos < 0 {
			l.Info(
				"bitbucket(dc)-connector: group doesn't have this project permission",
				zap.String("principal_id", principal.Id.String()),
				zap.String("principal_type", principal.Id.ResourceType),
			)
			return annotations.New(&v2.GrantAlreadyRevoked{}), nil
		}

		err = p.client.RevokeGroupProjectPermission(ctx, projectKey, groupName)
		if err != nil {
			return nil, fmt.Errorf("bitbucket(dc)-connector: failed to remove project group permission: %w", err)
		}

		l.Info("Project Membership has been revoked.",
			zap.String("GroupName", groupName),
			zap.String("ProjectKey", projectKey),
		)
	default:
		return nil, fmt.Errorf("bitbucket(dc)-connector: invalid grant resource type: %s", principal.Id.ResourceType)
	}

	return nil, nil
}

func newProjectBuilder(c *client.DataCenterClient) *projectBuilder {
	return &projectBuilder{
		resourceType: resourceTypeProject,
		client:       c,
	}
}
