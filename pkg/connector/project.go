package connector

import (
	"context"
	"fmt"
	"strconv"

	"github.com/conductorone/baton-bitbucket-datacenter/pkg/client"
	v2 "github.com/conductorone/baton-sdk/pb/c1/connector/v2"
	"github.com/conductorone/baton-sdk/pkg/annotations"
	"github.com/conductorone/baton-sdk/pkg/pagination"
	ent "github.com/conductorone/baton-sdk/pkg/types/entitlement"
	"github.com/conductorone/baton-sdk/pkg/types/grant"
	rs "github.com/conductorone/baton-sdk/pkg/types/resource"
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

var projectPermissions = []string{roleProjectRead, roleProjectWrite, roleProjectCreate, roleProjectAdmin}

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
		pageToken  int
		err        error
		rv         []*v2.Grant
		projectKey string
		ok         bool
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

	groupTrait, err := rs.GetGroupTrait(resource)
	if err != nil {
		return nil, "", nil, err
	}

	if projectKey, ok = rs.GetProfileStringValue(groupTrait.Profile, "project_key"); !ok {
		return nil, "", nil, fmt.Errorf("project_key not found")
	}

	members, nextPageToken, err := p.client.ListProjectsPermissions(ctx, client.PageOptions{
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

	for _, member := range members {
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

	nextPageToken, err = bag.Marshal()
	if err != nil {
		return nil, "", nil, err
	}

	return rv, nextPageToken, nil, nil
}

func (g *projectBuilder) Grant(ctx context.Context, principal *v2.Resource, entitlement *v2.Entitlement) (annotations.Annotations, error) {
	return nil, nil
}

func (g *projectBuilder) Revoke(ctx context.Context, grant *v2.Grant) (annotations.Annotations, error) {
	return nil, nil
}

func newProjectBuilder(c *client.DataCenterClient) *projectBuilder {
	return &projectBuilder{
		resourceType: resourceTypeProject,
		client:       c,
	}
}