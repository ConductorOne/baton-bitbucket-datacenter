
# `baton-bitbucket-datacenter` [![Go Reference](https://pkg.go.dev/badge/github.com/conductorone/baton-bitbucket.svg)](https://pkg.go.dev/github.com/conductorone/baton-bitbucket) ![main ci](https://github.com/conductorone/baton-zendesk/actions/workflows/main.yaml/badge.svg)

`baton-bitbucket-datacenter` is a connector for Bitbucket built using the [Baton SDK](https://github.com/conductorone/baton-sdk). It communicates with the Bitbucket User provisioning API to sync data about workspaces, user groups, users, projects and their repositories.

Check out [Baton](https://github.com/conductorone/baton) to learn more about the project in general.

# Prerequisites

To work with the connector, you can choose from multiple authentication methods. You can either use an application password with login username and generated password, an API access token, or a consumer key and secret for oauth flow.

Each one of these methods are configurable with permissions (Read, Write, Admin) to access the Bitbucket API. The permissions required for this connector are:
- Read: `Group`, `User`, `Project`, `Repository`
- Admin: `Project`, `Repository`

# Getting Started

## brew

```
brew install conductorone/baton/baton conductorone/baton/baton-bitbucket
BATON_USERNAME=username BATON_PASSWORD=password baton-bitbucket
baton resources
```

## docker

```
docker run --rm -v $(pwd):/out -e BATON_TOKEN=token ghcr.io/conductorone/baton-bitbucket:latest -f "/out/sync.c1z"
docker run --rm -v $(pwd):/out ghcr.io/conductorone/baton:latest -f "/out/sync.c1z" resources
```

## source

```
go install github.com/conductorone/baton/cmd/baton@main
go install github.com/conductorone/baton-bitbucket/cmd/baton-bitbucket@main
BATON_CONSUMER_ID=consumerKey BATON_CONSUMER_SECRET=consumerSecret baton-bitbucket
baton resources
```

# Data Model

`baton-bitbucket-datacenter` will pull down information about the following Bitbucket resources:

- Groups
- Users
- Projects
- Repositories

By default, `baton-bitbucket-datacenter` will sync information from workspaces based on provided credential. You can specify exactly which workspaces you would like to sync using the `--workspaces` flag.

# Contributing, Support and Issues

We started Baton because we were tired of taking screenshots and manually building spreadsheets. We welcome contributions, and ideas, no matter how small -- our goal is to make identity and permissions sprawl less painful for everyone. If you have questions, problems, or ideas: Please open a Github Issue!

See [CONTRIBUTING.md](https://github.com/ConductorOne/baton/blob/main/CONTRIBUTING.md) for more details.

# `baton-bitbucket-datacenter` Command Line Usage

```
baton-bitbucket-datacenter

Usage:
  baton-bitbucket-datacenter [flags]
  baton-bitbucket-datacenter [command]

Available Commands:
  capabilities       Get connector capabilities
  completion         Generate the autocompletion script for the specified shell
  help               Help about any command

Flags:
      --bitbucketdc-baseurl string    Bitbucket Data Center server. example http://localhost:7990. ($BATON_BITBUCKETDC_BASE_URL)
      --bitbucketdc-password string   Application password used to connect to the BitBucket(dc) API. ($BATON_BITBUCKETDC_PASSWORD)
      --bitbucketdc-username string   Username of administrator used to connect to the BitBucket(dc) API. ($BATON_BITBUCKETDC_USERNAME)
      --client-id string              The client ID used to authenticate with ConductorOne ($BATON_CLIENT_ID)
      --client-secret string          The client secret used to authenticate with ConductorOne ($BATON_CLIENT_SECRET)
  -f, --file string                   The path to the c1z file to sync with ($BATON_FILE) (default "sync.c1z")
  -h, --help                          help for baton-bitbucket-datacenter
      --log-format string             The output format for logs: json, console ($BATON_LOG_FORMAT) (default "json")
      --log-level string              The log level: debug, info, warn, error ($BATON_LOG_LEVEL) (default "info")
  -p, --provisioning                  This must be set in order for provisioning actions to be enabled. ($BATON_PROVISIONING)
  -v, --version                       version for baton-bitbucket-datacenter

Use "baton-bitbucket-datacenter [command] --help" for more information about a command.
```