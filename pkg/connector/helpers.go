package connector

import (
	"context"
	"crypto/rand"
	"fmt"
	"math/big"
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

// generatedPasswordLength is comfortably above Bitbucket Data Center's default
// minimum password length policy.
const generatedPasswordLength = 24

// generatePassword returns a cryptographically random password used once to satisfy
// Bitbucket's admin/users create endpoint, which requires a password on every create.
// The value is never persisted or logged; the connector discards it immediately after
// the create call.
func generatePassword() (string, error) {
	const charset = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*-_=+"
	pw := make([]byte, generatedPasswordLength)
	for i := range pw {
		n, err := rand.Int(rand.Reader, big.NewInt(int64(len(charset))))
		if err != nil {
			return "", err
		}
		pw[i] = charset[n.Int64()]
	}
	return string(pw), nil
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
