package connector

import (
	"context"
	"fmt"
	"strconv"
	"strings"

	"github.com/conductorone/baton-bitbucket-datacenter/pkg/client"
	v2 "github.com/conductorone/baton-sdk/pb/c1/connector/v2"
	"github.com/conductorone/baton-sdk/pkg/pagination"
	rs "github.com/conductorone/baton-sdk/pkg/types/resource"
	"golang.org/x/text/cases"
	"golang.org/x/text/language"
)

func userResource(ctx context.Context, user *client.User, parentResourceID *v2.ResourceId) (*v2.Resource, error) {
	var userStatus v2.UserTrait_Status_Status = v2.UserTrait_Status_STATUS_ENABLED
	firstName, lastName := rs.SplitFullName(user.Name)
	profile := map[string]interface{}{
		"login":      user.Slug,
		"first_name": firstName,
		"last_name":  lastName,
		"email":      user.EmailAddress,
		"user_id":    user.ID,
		"user_slug":  user.Slug,
	}

	switch user.Active {
	case true:
		userStatus = v2.UserTrait_Status_STATUS_ENABLED
	case false:
		userStatus = v2.UserTrait_Status_STATUS_DISABLED
	}

	userTraits := []rs.UserTraitOption{
		rs.WithUserProfile(profile),
		rs.WithStatus(userStatus),
		rs.WithUserLogin(user.Slug),
		rs.WithEmail(user.EmailAddress, true),
	}

	displayName := user.Name
	if displayName == "" {
		displayName = user.Slug
	}
	if displayName == "" {
		displayName = user.EmailAddress
	}

	ret, err := rs.NewUserResource(
		displayName,
		resourceTypeUser,
		user.ID,
		userTraits,
		rs.WithParentResourceID(parentResourceID))
	if err != nil {
		return nil, err
	}

	return ret, nil
}

// Create a new connector resource for an Bitbucket Project.
func projectResource(ctx context.Context, project *client.Projects, parentResourceID *v2.ResourceId) (*v2.Resource, error) {
	profile := map[string]interface{}{
		"project_id":   project.ID,
		"project_name": project.Name,
		"project_key":  project.Key,
	}

	groupTraitOptions := []rs.GroupTraitOption{rs.WithGroupProfile(profile)}
	resource, err := rs.NewGroupResource(
		project.Name,
		resourceTypeProject,
		project.Key,
		groupTraitOptions,
		rs.WithParentResourceID(parentResourceID),
	)

	if err != nil {
		return nil, err
	}

	return resource, nil
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

// Create a new connector resource for an Bitbucket Repository.
func repositoryResource(ctx context.Context, repository *client.Repos, parentResourceID *v2.ResourceId) (*v2.Resource, error) {
	profile := map[string]interface{}{
		"repository_id":          repository.ID,
		"repository_name":        repository.Name,
		"repository_full_name":   repository.Slug,
		"repository_project_key": repository.Project.Key,
	}

	groupTraitOptions := []rs.GroupTraitOption{rs.WithGroupProfile(profile)}
	displayName := fmt.Sprintf("%s/%s", repository.Project.Key, repository.Slug)
	resource, err := rs.NewGroupResource(
		displayName,
		resourceTypeRepository,
		makeRepositoryID(repository.Project.Key, repository.Slug),
		groupTraitOptions,
		rs.WithParentResourceID(parentResourceID),
	)
	if err != nil {
		return nil, err
	}

	return resource, nil
}

// Create a new connector resource for an Bitbucket UserGroup.
func groupResource(ctx context.Context, groupName string, parentResourceId *v2.ResourceId) (*v2.Resource, error) {
	if groupName == "" {
		return nil, fmt.Errorf("bitbucket(dc)-connector: group name is empty")
	}
	resourceOptions := []rs.ResourceOption{}
	if parentResourceId != nil {
		resourceOptions = append(resourceOptions, rs.WithParentResourceID(parentResourceId))
	}
	resource, err := rs.NewGroupResource(
		groupName,
		resourceTypeGroup,
		groupName,
		nil,
		resourceOptions...,
	)
	if err != nil {
		return nil, err
	}

	return resource, nil
}

func titleCase(s string) string {
	titleCaser := cases.Title(language.English)

	return titleCaser.String(s)
}

func unmarshalSkipToken(token *pagination.Token) (int32, *pagination.Bag, error) {
	b := &pagination.Bag{}
	err := b.Unmarshal(token.Token)
	if err != nil {
		return 0, nil, err
	}
	current := b.Current()
	skip := int32(0)
	if current != nil && current.Token != "" {
		skip64, err := strconv.ParseInt(current.Token, 10, 32)
		if err != nil {
			return 0, nil, err
		}
		skip = int32(skip64)
	}
	return skip, b, nil
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
	var (
		page           int
		lstPermissions []client.UsersPermissions
	)
	for {
		permissions, nextPageToken, err := cli.ListGlobalUserPermissions(ctx, client.PageOptions{
			PerPage: client.ITEMSPERPAGE,
			Page:    page,
		})
		if err != nil {
			return nil, err
		}

		lstPermissions = append(lstPermissions, permissions...)
		if nextPageToken == "" {
			break
		}

		page, err = strconv.Atoi(nextPageToken)
		if err != nil {
			return nil, err
		}
	}

	return lstPermissions, nil
}

func listGlobalGroupPermissions(ctx context.Context, cli *client.DataCenterClient) ([]client.GroupsPermissions, error) {
	var (
		page           int
		lstPermissions []client.GroupsPermissions
	)
	for {
		permissions, nextPageToken, err := cli.ListGlobalGroupPermissions(ctx, client.PageOptions{
			PerPage: client.ITEMSPERPAGE,
			Page:    page,
		})
		if err != nil {
			return nil, err
		}

		lstPermissions = append(lstPermissions, permissions...)
		if nextPageToken == "" {
			break
		}

		page, err = strconv.Atoi(nextPageToken)
		if err != nil {
			return nil, err
		}
	}

	return lstPermissions, nil
}

func listGroupMembers(ctx context.Context, cli *client.DataCenterClient, groupName string) ([]client.Members, error) {
	var (
		page       int
		lstMembers []client.Members
	)
	for {
		listGroup, nextPageToken, err := cli.ListGroupMembers(ctx, client.PageOptions{
			PerPage: client.ITEMSPERPAGE,
			Page:    page,
		}, groupName)
		if err != nil {
			return nil, err
		}

		lstMembers = append(lstMembers, listGroup...)
		if nextPageToken == "" {
			break
		}

		page, err = strconv.Atoi(nextPageToken)
		if err != nil {
			return nil, err
		}
	}

	return lstMembers, nil
}

func listUserRepositoryPermissions(ctx context.Context, cli *client.DataCenterClient, projectKey, repositorySlug string) ([]client.UsersPermissions, error) {
	var (
		page           int
		lstPermissions []client.UsersPermissions
	)
	for {
		permissions, nextPageToken, err := cli.ListUserRepositoryPermissions(ctx, client.PageOptions{
			PerPage: client.ITEMSPERPAGE,
			Page:    page,
		}, projectKey, repositorySlug)
		if err != nil {
			return nil, err
		}

		lstPermissions = append(lstPermissions, permissions...)
		if nextPageToken == "" {
			break
		}

		page, err = strconv.Atoi(nextPageToken)
		if err != nil {
			return nil, err
		}
	}

	return lstPermissions, nil
}

// listGroupRepositoryPermissions
// repositorySlug = name.
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
	var (
		page           int
		lstPermissions []client.UsersPermissions
	)
	for {
		permissions, nextPageToken, err := cli.ListUserProjectsPermissions(ctx, client.PageOptions{
			PerPage: client.ITEMSPERPAGE,
			Page:    page,
		}, projectKey)
		if err != nil {
			return nil, err
		}

		lstPermissions = append(lstPermissions, permissions...)
		if nextPageToken == "" {
			break
		}

		page, err = strconv.Atoi(nextPageToken)
		if err != nil {
			return nil, err
		}
	}

	return lstPermissions, nil
}

func listGroupProjectsPermissions(ctx context.Context, cli *client.DataCenterClient, projectKey string) ([]client.GroupsPermissions, error) {
	var (
		page           int
		lstPermissions []client.GroupsPermissions
	)
	for {
		permissions, nextPageToken, err := cli.ListGroupProjectsPermissions(ctx, client.PageOptions{
			PerPage: client.ITEMSPERPAGE,
			Page:    page,
		}, projectKey)
		if err != nil {
			return nil, err
		}

		lstPermissions = append(lstPermissions, permissions...)
		if nextPageToken == "" {
			break
		}

		page, err = strconv.Atoi(nextPageToken)
		if err != nil {
			return nil, err
		}
	}

	return lstPermissions, nil
}
