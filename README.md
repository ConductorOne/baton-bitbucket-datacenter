
# `baton-bitbucket-datacenter` [![Go Reference](https://pkg.go.dev/badge/github.com/conductorone/baton-bitbucket.svg)](https://pkg.go.dev/github.com/conductorone/baton-bitbucket) ![main ci](https://github.com/conductorone/baton-zendesk/actions/workflows/main.yaml/badge.svg)

`baton-bitbucket-datacenter` is a connector for Bitbucket built using the [Baton SDK](https://github.com/conductorone/baton-sdk). It communicates with the Bitbucket User provisioning API to sync data about user groups, users, projects and their repositories.

Check out [Baton](https://github.com/conductorone/baton) to learn more about the project in general.

# Prerequisites

To work with the connector, you can use basic authentication, with a username and password.

Each one of these methods are configurable with permissions (Read, Write, Admin) to access the Bitbucket API. The permissions required for this connector are:
- Read: `Group`, `User`, `Project`, `Repository`
- Admin: `Project`, `Repository`

# Getting Started

## brew

```
brew install conductorone/baton/baton conductorone/baton/baton-bitbucket-datacenter
BATON_BITBUCKETDC_USERNAME=bitbucketdc-username BATON_BITBUCKETDC_PASSWORD=bitbucketdc-password BATON_BITBUCKETDC_BASE_URL=bitbucketdc-baseurl baton-bitbucket-datacenter
baton resources
```

## docker

```
docker run --rm -v $(pwd):/out -e BATON_BITBUCKETDC_USERNAME=bitbucketdc-username BATON_BITBUCKETDC_PASSWORD=bitbucketdc-password BATON_BITBUCKETDC_BASE_URL=bitbucketdc-baseurl public.ecr.aws/conductorone/baton-bitbucket-datacenter:latest -f "/out/sync.c1z"
docker run --rm -v $(pwd):/out ghcr.io/conductorone/baton:latest -f "/out/sync.c1z" resources
```

## source

```
go install github.com/conductorone/baton/cmd/baton@main
go install github.com/conductorone/baton-bitbucket-datacenter/cmd/baton-bitbucket-datacenter@main
BATON_BITBUCKETDC_USERNAME=bitbucketdc-username BATON_BITBUCKETDC_PASSWORD=bitbucketdc-password BATON_BITBUCKETDC_BASE_URL=bitbucketdc-baseurl baton-bitbucket-datacenter
baton resources
```

# Data Model

`baton-bitbucket-datacenter` will pull down information about the following Bitbucket resources:

- Groups
- Users
- Projects
- Repositories

# Account Provisioning

When run with the `--provisioning` flag, `baton-bitbucket-datacenter` supports creating and
deleting Bitbucket users:

- **Create account**: provisions a new local Bitbucket user (`POST /rest/api/latest/admin/users`)
  from a username, display name, and email address. A random password is generated to satisfy the
  API's required `password` parameter; it is never logged, persisted, or returned to the caller.
  An optional `add_to_default_group` field controls whether the user is added to Bitbucket's
  default group, which affects their initial permissions and ability to log in (defaults to
  `false`). Creating an account for a username that already exists is treated as a successful
  no-op only if the existing user has the same email address that was requested; if the email
  differs, the existing account belongs to someone else and the request fails instead.
- **Delete account**: deletes a Bitbucket user (`DELETE /rest/api/latest/admin/users?name=`).
  Deleting a user that no longer exists is treated as a successful no-op. Users managed by an
  external directory (e.g. LDAP, Crowd) cannot be deleted through this API; the connector surfaces
  a clear error in that case instead of silently failing.

These endpoints are under Bitbucket's `admin/` namespace and require credentials with at
least the `ADMIN` (Administrator) global permission; `SYS_ADMIN` also works. `LICENSED_USER`
is not sufficient and is rejected.

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
      --bitbucketdc-baseurl string                 required: Bitbucket Data Center server. example http://localhost:7990. ($BATON_BITBUCKETDC_BASEURL) (default "http://localhost:7990")
      --bitbucketdc-licensed-user-groups strings   List of groups that are considered licensed users in Bitbucket Data Center ($BATON_BITBUCKETDC_LICENSED_USER_GROUPS)
      --bitbucketdc-password string                Application password used to connect to the BitBucketDC API. ($BATON_BITBUCKETDC_PASSWORD)
      --bitbucketdc-token string                   HTTP access tokens in Bitbucket Data Center ($BATON_BITBUCKETDC_TOKEN)
      --bitbucketdc-username string                Username of administrator used to connect to the BitBucketDC API. ($BATON_BITBUCKETDC_USERNAME)
      --client-id string                           The client ID used to authenticate with ConductorOne ($BATON_CLIENT_ID)
      --client-secret string                       The client secret used to authenticate with ConductorOne ($BATON_CLIENT_SECRET)
  -f, --file string                                The path to the c1z file to sync with ($BATON_FILE) (default "sync.c1z")
  -h, --help                                       help for baton-bitbucket-datacenter
      --log-format string                          The output format for logs: json, console ($BATON_LOG_FORMAT) (default "json")
      --log-level string                           The log level: debug, info, warn, error ($BATON_LOG_LEVEL) (default "info")
  -p, --provisioning                               This must be set in order for provisioning actions to be enabled ($BATON_PROVISIONING)
      --skip-full-sync                             This must be set to skip a full sync ($BATON_SKIP_FULL_SYNC)
      --skip-repos                                 Skip repositories ($BATON_SKIP_REPOS)
      --ticketing                                  This must be set to enable ticketing support ($BATON_TICKETING)
  -v, --version                                    version for baton-bitbucket-datacenter

Use "baton-bitbucket-datacenter [command] --help" for more information about a command.
```
