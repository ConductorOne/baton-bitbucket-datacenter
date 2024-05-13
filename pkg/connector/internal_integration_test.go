package connector

import (
	"context"
	"log"
	"os"
	"testing"

	"github.com/conductorone/baton-bitbucket-datacenter/pkg/client"
	"github.com/conductorone/baton-bitbucket-datacenter/pkg/client/config"
	v2 "github.com/conductorone/baton-sdk/pb/c1/connector/v2"
	"github.com/stretchr/testify/assert"
)

const (
	ConnectorGrant         = "group:local-group:LICENSED_USER:user:64"
	ConnectorEntitlement   = "group:local-group:LICENSED_USER"
	ConnectorPrincipalType = "user"
	ConnectorPrincipal     = "64"
)

var (
	ctx       = context.Background()
	principal = &v2.Resource{
		Id: &v2.ResourceId{
			ResourceType: ConnectorPrincipalType,
			Resource:     ConnectorPrincipal,
		},
		ParentResourceId: &v2.ResourceId{},
		DisplayName:      "f3",
	}
	entitlement = &v2.Entitlement{
		Resource: &v2.Resource{
			Id: &v2.ResourceId{
				ResourceType: "group",
				Resource:     "local-group",
			},
		},
		Id:          ConnectorEntitlement,
		DisplayName: "local-group Group ADMIN",
	}
)

func TestConfig(t *testing.T) {
	env1, err1 := os.LookupEnv("BITBUCKETDC_USERNAME")
	log.Println(env1, err1)
	env1, err1 = os.LookupEnv("BATON_BITBUCKETDC_PASSWORD")
	log.Println(env1, err1)
	t.Skip()
	config, err := config.LoadConfig()
	assert.Nil(t, err)
	assert.NotNil(t, config)
}

func TestClient(t *testing.T) {
	t.Skip()
	config := getCredentials()
	cliTest, err := client.New(ctx,
		config.BitbucketdcUsername,
		config.BitbucketdcPassword,
		config.BitbucketdcBaseUrl,
	)
	assert.Nil(t, err)
	assert.NotNil(t, cliTest)
}

func getCredentials() *config.Configuration {
	config, _ := config.LoadConfig()
	return config
}

func getClient(config *config.Configuration) *client.DataCenterClient {
	cliTest, _ := client.New(ctx,
		config.BitbucketdcUsername,
		config.BitbucketdcPassword,
		config.BitbucketdcBaseUrl,
	)

	return cliTest
}

func TestProvisionigGroupMembership(t *testing.T) {
	t.Skip()
	defer func() { _ = recover() }()
	config := getCredentials()
	cliTest := getClient(config)
	group := &groupBuilder{
		resourceType: &v2.ResourceType{},
		client:       cliTest,
	}
	_, err := group.Grant(ctx, principal, entitlement)
	assert.Nil(t, err)
}

func TestRevokingGroupMembership(t *testing.T) {
	t.Skip()
	defer func() { _ = recover() }()
	config := getCredentials()
	cliTest := getClient(config)
	group := &groupBuilder{
		resourceType: &v2.ResourceType{},
		client:       cliTest,
	}
	_, err := group.Revoke(ctx, &v2.Grant{
		Entitlement: entitlement,
		Principal:   principal,
		Id:          "group:local-group:ADMIN",
	})
	assert.Nil(t, err)
}
