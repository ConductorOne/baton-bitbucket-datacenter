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
)

type repoBuilder struct {
	resourceType *v2.ResourceType
	client       *client.DataCenterClient
}

var repositoryRoles = []string{roleRead, roleWrite, roleAdmin}

const (
	roleRead   = "read"
	roleWrite  = "write"
	roleCreate = "create-repo"
	roleAdmin  = "admin"
)

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
	if pToken.Token != "" {
		pageToken, err = strconv.Atoi(pToken.Token)
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

	for _, repo := range repos {
		repoCopy := repo
		ur, err := repositoryResource(ctx, &repoCopy, parentResourceID)
		if err != nil {
			return nil, "", nil, err
		}
		rv = append(rv, ur)
	}

	return rv, nextPageToken, nil, nil
}

// Entitlements always returns an empty slice for users.
func (p *repoBuilder) Entitlements(_ context.Context, resource *v2.Resource, _ *pagination.Token) ([]*v2.Entitlement, string, annotations.Annotations, error) {
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

// Grants always returns an empty slice for users since they don't have any entitlements.
func (p *repoBuilder) Grants(ctx context.Context, resource *v2.Resource, pToken *pagination.Token) ([]*v2.Grant, string, annotations.Annotations, error) {
	return nil, "", nil, nil
}

func newRepoBuilder(c *client.DataCenterClient) *repoBuilder {
	return &repoBuilder{
		resourceType: resourceTypeRepository,
		client:       c,
	}
}