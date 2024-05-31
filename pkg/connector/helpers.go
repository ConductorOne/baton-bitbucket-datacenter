package connector

import (
	"context"
	"fmt"
	"slices"
	"strconv"
	"strings"

	"github.com/conductorone/baton-bitbucket-datacenter/pkg/client"
	v2 "github.com/conductorone/baton-sdk/pb/c1/connector/v2"
	"github.com/conductorone/baton-sdk/pkg/annotations"
	"github.com/conductorone/baton-sdk/pkg/pagination"
	ent "github.com/conductorone/baton-sdk/pkg/types/entitlement"
	rs "github.com/conductorone/baton-sdk/pkg/types/resource"
	"golang.org/x/text/cases"
	"golang.org/x/text/language"
)

func annotationsForUserResourceType() annotations.Annotations {
	annos := annotations.Annotations{}
	annos.Update(&v2.SkipEntitlementsAndGrants{})
	return annos
}

// Populate entitlement options for a 1password resource.
func PopulateOptions(displayName, permission, resource string) []ent.EntitlementOption {
	options := []ent.EntitlementOption{
		ent.WithGrantableTo(resourceTypeUser),
		ent.WithDescription(fmt.Sprintf("%s of VGS %s %s", permission, displayName, resource)),
		ent.WithDisplayName(fmt.Sprintf("%s %s %s", displayName, resource, permission)),
	}
	return options
}

// splitFullName returns firstName and lastName.
func splitFullName(name string) (string, string) {
	names := strings.SplitN(name, " ", 2)
	var firstName, lastName string

	switch len(names) {
	case 1:
		firstName = names[0]
	case 2:
		firstName = names[0]
		lastName = names[1]
	}

	return firstName, lastName
}

func userResource(ctx context.Context, user *client.Users, parentResourceID *v2.ResourceId) (*v2.Resource, error) {
	var userStatus v2.UserTrait_Status_Status = v2.UserTrait_Status_STATUS_ENABLED
	firstName, lastName := splitFullName(user.Name)
	profile := map[string]interface{}{
		"login":      user.EmailAddress,
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
		rs.WithUserLogin(user.EmailAddress),
		rs.WithEmail(user.EmailAddress, true),
	}

	displayName := user.Name
	if user.Name == "" {
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
		project.ID,
		groupTraitOptions,
		rs.WithParentResourceID(parentResourceID),
	)

	if err != nil {
		return nil, err
	}

	return resource, nil
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
	resource, err := rs.NewGroupResource(
		repository.Name,
		resourceTypeRepository,
		repository.ID,
		groupTraitOptions,
		rs.WithParentResourceID(parentResourceID),
	)

	if err != nil {
		return nil, err
	}

	return resource, nil
}

func ParsePageToken(i string, resourceID *v2.ResourceId) (*pagination.Bag, error) {
	b := &pagination.Bag{}
	err := b.Unmarshal(i)
	if err != nil {
		return nil, err
	}

	if b.Current() == nil {
		b.Push(pagination.PageState{
			ResourceTypeID: resourceID.ResourceType,
			ResourceID:     resourceID.Resource,
		})
	}

	return b, nil
}

func PString[T any](p *T) T {
	if p == nil {
		var v T
		return v
	}

	return *p
}

// Create a new connector resource for an Bitbucket UserGroup.
func groupResource(ctx context.Context, group string, parentResourceID *v2.ResourceId) (*v2.Resource, error) {
	id := group // Bitbucket DC groups only contains name
	name := group
	profile := map[string]interface{}{
		"group_name": name,
		"group_id":   id,
	}
	groupTraitOptions := []rs.GroupTraitOption{rs.WithGroupProfile(profile)}
	resource, err := rs.NewGroupResource(
		name,
		resourceTypeGroup,
		id,
		groupTraitOptions,
		rs.WithParentResourceID(parentResourceID),
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

func ParseEntitlementID(id string) (*v2.ResourceId, []string, error) {
	parts := strings.Split(id, ":")
	// Need to be at least 3 parts type:entitlement_id:slug
	if len(parts) < 3 || len(parts) > 3 {
		return nil, nil, fmt.Errorf("bitbucket(dc)-connector: invalid resource id")
	}

	resourceId := &v2.ResourceId{
		ResourceType: parts[0],
		Resource:     strings.Join(parts[1:len(parts)-1], ":"),
	}

	return resourceId, parts, nil
}

func listGlobalUserPermissions(ctx context.Context, cli *client.DataCenterClient) ([]client.UsersPermissions, error) {
	var (
		page           int
		lstPermissions []client.UsersPermissions
	)
	for {
		permissions, nextPageToken, err := cli.ListGlobalUserPermissions(ctx, client.PageOptions{
			PerPage: ITEMSPERPAGE,
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
			PerPage: ITEMSPERPAGE,
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
			PerPage: ITEMSPERPAGE,
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
			PerPage: ITEMSPERPAGE,
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

func listGroupRepositoryPermissions(ctx context.Context, cli *client.DataCenterClient, projectKey, repositorySlug string) ([]client.GroupsPermissions, error) {
	var (
		page           int
		lstPermissions []client.GroupsPermissions
	)
	for {
		permissions, nextPageToken, err := cli.ListGroupRepositoryPermissions(ctx, client.PageOptions{
			PerPage: ITEMSPERPAGE,
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

func listUserProjectsPermissions(ctx context.Context, cli *client.DataCenterClient, projectKey string) ([]client.UsersPermissions, error) {
	var (
		page           int
		lstPermissions []client.UsersPermissions
	)
	for {
		permissions, nextPageToken, err := cli.ListUserProjectsPermissions(ctx, client.PageOptions{
			PerPage: ITEMSPERPAGE,
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
			PerPage: ITEMSPERPAGE,
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

func listProjects(ctx context.Context, cli *client.DataCenterClient) ([]client.Projects, error) {
	var (
		page        int
		lstProjects []client.Projects
	)
	for {
		projects, nextPageToken, err := cli.ListProjects(ctx, client.PageOptions{
			PerPage: ITEMSPERPAGE,
			Page:    page,
		})
		if err != nil {
			return nil, err
		}

		lstProjects = append(lstProjects, projects...)
		if nextPageToken == "" {
			break
		}

		page, err = strconv.Atoi(nextPageToken)
		if err != nil {
			return nil, err
		}
	}

	return lstProjects, nil
}

func findProjectKey(ctx context.Context, cli *client.DataCenterClient, projectId int) (string, error) {
	projects, err := listProjects(ctx, cli)
	if err != nil {
		return "", err
	}

	projectPos := slices.IndexFunc(projects, func(c client.Projects) bool {
		return c.ID == projectId
	})

	if projectPos == -1 {
		return "", fmt.Errorf("project key was not found")
	}

	return projects[projectPos].Key, nil
}

func getProjectKey(ctx context.Context, customType interface{}, projectId int) (string, error) {
	var (
		projectKey string
		err        error
	)
	switch cli := customType.(type) {
	case *projectBuilder:
		projectKey, err = findProjectKey(ctx, cli.client, projectId)
		if err != nil {
			return "", err
		}
	case *groupBuilder:
		projectKey, err = findProjectKey(ctx, cli.client, projectId)
		if err != nil {
			return "", err
		}
	default:
		return "", fmt.Errorf("projectKey not found, unknown type")
	}

	return projectKey, nil
}

func listRepositories(ctx context.Context, cli *client.DataCenterClient) ([]client.Repos, error) {
	var (
		page     int
		lstRepos []client.Repos
	)
	for {
		repos, nextPageToken, err := cli.ListRepos(ctx, client.PageOptions{
			PerPage: ITEMSPERPAGE,
			Page:    page,
		})
		if err != nil {
			return nil, err
		}

		lstRepos = append(lstRepos, repos...)
		if nextPageToken == "" {
			break
		}

		page, err = strconv.Atoi(nextPageToken)
		if err != nil {
			return nil, err
		}
	}

	return lstRepos, nil
}

func getRepositorySlug(ctx context.Context, r *repoBuilder, repoId int) (string, string, error) {
	repos, err := listRepositories(ctx, r.client)
	if err != nil {
		return "", "", err
	}

	repoPos := slices.IndexFunc(repos, func(c client.Repos) bool {
		return c.ID == repoId
	})

	if repoPos == -1 {
		return "", "", fmt.Errorf("repository was not found")
	}

	return repos[repoPos].Project.Key, repos[repoPos].Slug, nil
}
