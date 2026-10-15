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
	addToDefaultGroupDefault := false

	return &v2.ConnectorMetadata{
		DisplayName: "Bitbucket Datacenter Connector",
		Description: "Connector syncing users, groups, projects and repositories from Bitbucket Datacenter.",
		AccountCreationSchema: &v2.ConnectorAccountCreationSchema{
			FieldMap: map[string]*v2.ConnectorAccountCreationSchema_Field{
				"login": {
					DisplayName: "Username",
					Required:    true,
					Description: "The username for the new Bitbucket user.",
					Field: &v2.ConnectorAccountCreationSchema_Field_StringField{
						StringField: &v2.ConnectorAccountCreationSchema_StringField{},
					},
					Placeholder: "jdoe",
					Order:       1,
				},
				"display_name": {
					DisplayName: "Display Name",
					Required:    true,
					Description: "The display name for the new Bitbucket user.",
					Field: &v2.ConnectorAccountCreationSchema_Field_StringField{
						StringField: &v2.ConnectorAccountCreationSchema_StringField{},
					},
					Placeholder: "Jane Doe",
					Order:       2,
				},
				"email": {
					DisplayName: "Email",
					Required:    true,
					Description: "The email address for the new Bitbucket user.",
					Field: &v2.ConnectorAccountCreationSchema_Field_StringField{
						StringField: &v2.ConnectorAccountCreationSchema_StringField{},
					},
					Placeholder: "jane.doe@example.com",
					Order:       3,
				},
				"add_to_default_group": {
					DisplayName: "Add to default group",
					Required:    false,
					Description: "Whether the new user should be added to Bitbucket's default group. " +
						"The default group controls the user's initial permissions and ability to log in.",
					Field: &v2.ConnectorAccountCreationSchema_Field_BoolField{
						BoolField: &v2.ConnectorAccountCreationSchema_BoolField{
							DefaultValue: &addToDefaultGroupDefault,
						},
					},
					Order: 4,
				},
			},
		},
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
