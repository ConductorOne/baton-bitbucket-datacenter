package connector

import (
	"context"
	"fmt"
	"strconv"
	"strings"

	"github.com/conductorone/baton-bitbucket-datacenter/pkg/client"
	v2 "github.com/conductorone/baton-sdk/pb/c1/connector/v2"
	"github.com/conductorone/baton-sdk/pkg/pagination"
	"github.com/conductorone/baton-sdk/pkg/uhttp"
	"golang.org/x/text/cases"
	"golang.org/x/text/language"
	"google.golang.org/grpc/codes"
)

// callerString separates "the caller omitted this field" (defaulting/fallback is
// legitimate) from "the caller sent a value we can't read" (must fail - silently
// defaulting would substitute a value the admin never asked for).
func callerString(profile map[string]any, key string) (string, bool, error) {
	raw, present := profile[key]
	if !present || raw == nil {
		return "", false, nil
	}
	value, ok := raw.(string)
	if !ok {
		return "", true, uhttp.WrapErrors(
			codes.InvalidArgument,
			fmt.Sprintf("bitbucket(dc)-connector: invalid %s: expected a string, got %T", key, raw),
		)
	}
	return value, true, nil
}

// callerBool mirrors callerString's semantics for boolean profile fields: absent means
// the caller didn't set it (default to false), but present-with-the-wrong-type must fail
// loudly rather than silently default, since that would substitute a value the admin
// never asked for. A string is also accepted and parsed with strconv.ParseBool (after
// trimming whitespace and lowercasing, so "True"/" true " work as well as "true"),
// since some callers (e.g. CLI/form-driven invocations) can only send string profile
// values; a string that doesn't parse as a bool still fails loudly rather than defaulting.
func callerBool(profile map[string]any, key string) (bool, bool, error) {
	raw, present := profile[key]
	if !present || raw == nil {
		return false, false, nil
	}
	if value, ok := raw.(bool); ok {
		return value, true, nil
	}
	if str, ok := raw.(string); ok {
		value, err := strconv.ParseBool(strings.ToLower(strings.TrimSpace(str)))
		if err != nil {
			return false, true, uhttp.WrapErrors(
				codes.InvalidArgument,
				fmt.Sprintf("bitbucket(dc)-connector: invalid %s: cannot parse %q as a bool", key, str),
			)
		}
		return value, true, nil
	}
	return false, true, uhttp.WrapErrors(
		codes.InvalidArgument,
		fmt.Sprintf("bitbucket(dc)-connector: invalid %s: expected a bool, got %T", key, raw),
	)
}

func parseRepositoryID(id string) (string, string, error) {
	parts := strings.Split(id, "/")
	if len(parts) != 2 {
		return "", "", fmt.Errorf("bitbucket(dc)-connector: invalid repository id")
	}

	return parts[0], parts[1], nil
}

func makeRepositoryID(projectKey, repositorySlug string) string {
	return fmt.Sprintf("%s/%s", projectKey, repositorySlug)
}

func titleCase(s string) string {
	titleCaser := cases.Title(language.English)

	return titleCaser.String(s)
}

func parseToken(pToken *pagination.Token, defaultPageState []pagination.PageState) (*pagination.Token, *pagination.Bag, error) {
	bag := &pagination.Bag{}

	if pToken != nil && pToken.Token != "" {
		err := bag.Unmarshal(pToken.Token)
		return pToken, bag, err
	}

	for _, pageState := range defaultPageState {
		bag.Push(pageState)
	}

	token, err := bag.Marshal()
	if err != nil {
		return nil, nil, err
	}
	if pToken == nil {
		pToken = &pagination.Token{}
	}
	pToken.Size = 0
	pToken.Token = token
	return pToken, bag, nil
}

func ParseEntitlementID(id string) (*v2.ResourceId, string, error) {
	parts := strings.Split(id, ":")
	// Need to be at least 3 parts type:entitlement_id:slug
	if len(parts) < 3 || len(parts) > 3 {
		return nil, "", fmt.Errorf("bitbucket(dc)-connector: invalid resource id")
	}

	resourceId := &v2.ResourceId{
		ResourceType: parts[0],
		Resource:     strings.Join(parts[1:len(parts)-1], ":"),
	}

	return resourceId, parts[len(parts)-1], nil
}

func listGlobalUserPermissions(ctx context.Context, cli *client.DataCenterClient) ([]client.UsersPermissions, error) {
	var lstPermissions []client.UsersPermissions
	pToken := &pagination.Token{}
	for {
		permissions, nextPageToken, err := cli.GetGlobalUserPermissions(ctx, pToken)
		if err != nil {
			return nil, err
		}
		pToken.Token = nextPageToken
		lstPermissions = append(lstPermissions, permissions...)
		if nextPageToken == "" {
			break
		}
	}

	return lstPermissions, nil
}

func listGlobalGroupPermissions(ctx context.Context, cli *client.DataCenterClient) ([]client.GroupsPermissions, error) {
	var lstPermissions []client.GroupsPermissions
	pToken := &pagination.Token{}
	for {
		permissions, nextPageToken, err := cli.GetGlobalGroupPermissions(ctx, pToken)
		if err != nil {
			return nil, err
		}
		pToken.Token = nextPageToken
		lstPermissions = append(lstPermissions, permissions...)
		if nextPageToken == "" {
			break
		}
	}

	return lstPermissions, nil
}

func listGroupMembers(ctx context.Context, cli *client.DataCenterClient, groupName string) ([]client.Members, error) {
	var lstMembers []client.Members
	pToken := &pagination.Token{}
	for {
		listGroup, nextPageToken, err := cli.GetGroupMembers(ctx, groupName, pToken)
		if err != nil {
			return nil, err
		}
		pToken.Token = nextPageToken
		lstMembers = append(lstMembers, listGroup...)
		if nextPageToken == "" {
			break
		}
	}

	return lstMembers, nil
}

func listUserRepositoryPermissions(ctx context.Context, cli *client.DataCenterClient, projectKey, repositorySlug string) ([]client.UsersPermissions, error) {
	var lstPermissions []client.UsersPermissions
	pToken := &pagination.Token{}
	for {
		permissions, nextPageToken, err := cli.GetUserRepositoryPermissions(ctx, projectKey, repositorySlug, pToken)
		if err != nil {
			return nil, err
		}
		pToken.Token = nextPageToken
		lstPermissions = append(lstPermissions, permissions...)
		if nextPageToken == "" {
			break
		}
	}

	return lstPermissions, nil
}

func listGroupRepositoryPermissions(ctx context.Context, cli *client.DataCenterClient, projectKey, repositorySlug string) ([]client.GroupsPermissions, error) {
	var lstPermissions []client.GroupsPermissions
	pToken := &pagination.Token{}
	for {
		permissions, nextPageToken, err := cli.GetGroupRepositoryPermissions(ctx, projectKey, repositorySlug, pToken)
		if err != nil {
			return nil, err
		}
		pToken.Token = nextPageToken
		lstPermissions = append(lstPermissions, permissions...)
		if nextPageToken == "" {
			break
		}
	}

	return lstPermissions, nil
}

func listUserProjectsPermissions(ctx context.Context, cli *client.DataCenterClient, projectKey string) ([]client.UsersPermissions, error) {
	var lstPermissions []client.UsersPermissions
	pToken := &pagination.Token{}
	for {
		permissions, nextPageToken, err := cli.GetUserProjectsPermissions(ctx, projectKey, pToken)
		if err != nil {
			return nil, err
		}
		pToken.Token = nextPageToken
		lstPermissions = append(lstPermissions, permissions...)
		if nextPageToken == "" {
			break
		}
	}

	return lstPermissions, nil
}

func listGroupProjectsPermissions(ctx context.Context, cli *client.DataCenterClient, projectKey string) ([]client.GroupsPermissions, error) {
	var lstPermissions []client.GroupsPermissions
	pToken := &pagination.Token{}
	for {
		permissions, nextPageToken, err := cli.GetGroupProjectsPermissions(ctx, projectKey, pToken)
		if err != nil {
			return nil, err
		}
		pToken.Token = nextPageToken
		lstPermissions = append(lstPermissions, permissions...)
		if nextPageToken == "" {
			break
		}
	}

	return lstPermissions, nil
}
