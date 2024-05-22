package main

import (
	"context"
	"fmt"

	"github.com/conductorone/baton-sdk/pkg/cli"
	"github.com/spf13/cobra"
)

// config defines the external configuration required for the connector to run.
type config struct {
	cli.BaseConfig    `mapstructure:",squash"` // Puts the base config options in the same place as the connector options
	BitbucketUsername string                   `mapstructure:"bitbucketdc-username"`
	BitbucketPassword string                   `mapstructure:"bitbucketdc-password"`
	BitbucketBaseUrl  string                   `mapstructure:"bitbucketdc-baseurl"`
	BitbucketToken    string                   `mapstructure:"bitbucketdc-token"`
}

// validateConfig is run after the configuration is loaded, and should return an error if it isn't valid.
func validateConfig(ctx context.Context, cfg *config) error {
	if cfg.BitbucketBaseUrl == "" {
		return fmt.Errorf("bitbucketdc-baseurl must be provided")
	}

	if cfg.BitbucketToken == "" {
		if cfg.BitbucketUsername == "" || cfg.BitbucketPassword == "" {
			return fmt.Errorf("either bitbucketdc-token or (bitbucketdc-username/bitbucketdc-password) must be provided")
		}
	}

	if cfg.BitbucketToken != "" && cfg.BitbucketUsername != "" && cfg.BitbucketPassword != "" {
		return fmt.Errorf("bitbucketdc-token, and (bitbucketdc-username/bitbucketdc-password) cannot be provided simultaneously")
	}

	return nil
}

// cmdFlags sets the cmdFlags required for the connector.
func cmdFlags(cmd *cobra.Command) {
	cmd.PersistentFlags().String("bitbucketdc-username", "", "Username of administrator used to connect to the BitBucket(dc) API. ($BATON_BITBUCKETDC_USERNAME)")
	cmd.PersistentFlags().String("bitbucketdc-password", "", "Application password used to connect to the BitBucket(dc) API. ($BATON_BITBUCKETDC_PASSWORD)")
	cmd.PersistentFlags().String("bitbucketdc-baseurl", "", "Bitbucket Data Center server. example http://localhost:7990. ($BATON_BITBUCKETDC_BASE_URL)")
	cmd.PersistentFlags().String("bitbucketdc-token", "", "HTTP access tokens in Bitbucket Data Center. ($BATON_BITBUCKETDC_TOKEN)")
}
