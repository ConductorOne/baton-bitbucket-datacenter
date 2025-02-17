package connector

import (
	"context"
	"io"

	"github.com/conductorone/baton-bitbucket-datacenter/pkg/client"
	v2 "github.com/conductorone/baton-sdk/pb/c1/connector/v2"
	"github.com/conductorone/baton-sdk/pkg/annotations"
	"github.com/conductorone/baton-sdk/pkg/connectorbuilder"
	"github.com/conductorone/baton-sdk/pkg/pagination"
)

type Connector struct {
	client     *client.DataCenterClient
	skipRepos  bool
	userGroups []string
}

// ResourceSyncers returns a ResourceSyncer for each resource type that should be synced from the upstream service.
func (c *Connector) ResourceSyncers(ctx context.Context) []connectorbuilder.ResourceSyncer {
	resourceSyncers := []connectorbuilder.ResourceSyncer{
		newUserBuilder(c.client, c.userGroups),
		newProjectBuilder(c.client),
		newGroupBuilder(c.client),
		newOrgBuilder(c.client),
	}
	if !c.skipRepos {
		resourceSyncers = append(resourceSyncers, newRepoBuilder(c.client))
	}
	return resourceSyncers
}

// Asset takes an input AssetRef and attempts to fetch it using the connector's authenticated http client
// It streams a response, always starting with a metadata object, following by chunked payloads for the asset.
func (c *Connector) Asset(ctx context.Context, asset *v2.AssetRef) (string, io.ReadCloser, error) {
	return "", nil, nil
}

// Metadata returns metadata about the connector.
func (c *Connector) Metadata(ctx context.Context) (*v2.ConnectorMetadata, error) {
	return &v2.ConnectorMetadata{
		DisplayName: "Bitbucket Datacenter Connector",
		Description: "Connector syncing users, groups, projects and repositories from Bitbucket Datacenter.",
	}, nil
}

// Validate is called to ensure that the connector is properly configured. It should exercise any API credentials
// to be sure that they are valid.
func (c *Connector) Validate(ctx context.Context) (annotations.Annotations, error) {
	_, _, err := c.client.GetProjects(ctx, &pagination.Token{})
	return nil, err
}

// New returns a new instance of the connector.
func New(ctx context.Context, baseUrl string, auth *client.Auth, skipRepos bool, userGroups []string) (*Connector, error) {
	bitbucketClient, err := client.New(ctx, baseUrl, auth)
	if err != nil {
		return nil, err
	}

	return &Connector{
		client:     bitbucketClient,
		skipRepos:  skipRepos,
		userGroups: userGroups,
	}, nil
}
