package main

import (
	"context"
	"fmt"
	"os"

	configschema "github.com/conductorone/baton-sdk/pkg/config"
	"github.com/conductorone/baton-sdk/pkg/connectorbuilder"
	"github.com/conductorone/baton-sdk/pkg/types"
	"github.com/grpc-ecosystem/go-grpc-middleware/logging/zap/ctxzap"
	"github.com/spf13/viper"
	"go.uber.org/zap"

	"github.com/conductorone/baton-bitbucket-datacenter/pkg/client"
	"github.com/conductorone/baton-bitbucket-datacenter/pkg/connector"
)

var version = "dev"

func main() {
	ctx := context.Background()

	_, cmd, err := configschema.DefineConfiguration(ctx, "baton-bitbucket-datacenter", getConnector, cfg)
	if err != nil {
		fmt.Fprintln(os.Stderr, err.Error())
		os.Exit(1)
	}

	cmd.Version = version

	err = cmd.Execute()
	if err != nil {
		fmt.Fprintln(os.Stderr, err.Error())
		os.Exit(1)
	}
}

func getConnector(ctx context.Context, v *viper.Viper) (types.ConnectorServer, error) {
	l := ctxzap.Extract(ctx)

	bitbucketBaseUrl := v.GetString(BitbucketBaseUrl.FieldName)
	if bitbucketBaseUrl == "" {
		return nil, fmt.Errorf("bitbucketdc-baseurl must be provided")
	}

	bitbucketToken := v.GetString(BitbucketToken.FieldName)
	bitbucketUsername := v.GetString(BitbucketUsername.FieldName)
	bitbucketPassword := v.GetString(BitbucketPassword.FieldName)
	if bitbucketToken == "" {
		if bitbucketUsername == "" || bitbucketPassword == "" {
			return nil, fmt.Errorf("either bitbucketdc-token or (bitbucketdc-username/bitbucketdc-password) must be provided")
		}
	}

	if bitbucketToken != "" && bitbucketUsername != "" && bitbucketPassword != "" {
		return nil, fmt.Errorf("bitbucketdc-token, and (bitbucketdc-username/bitbucketdc-password) cannot be provided simultaneously")
	}

	auth := client.Auth{
		Username:    bitbucketUsername,
		Password:    bitbucketPassword,
		BearerToken: bitbucketToken,
	}

	cb, err := connector.New(ctx, bitbucketBaseUrl, &auth, v.GetBool(SkipRepos.FieldName))
	if err != nil {
		l.Error("error creating connector", zap.Error(err))
		return nil, err
	}

	c, err := connectorbuilder.NewConnector(ctx, cb)
	if err != nil {
		l.Error("error creating connector", zap.Error(err))
		return nil, err
	}

	return c, nil
}
