package client

import (
	"context"
	"encoding/base64"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"net/http"
	"net/url"
	"strconv"

	"github.com/conductorone/baton-sdk/pkg/pagination"
	"github.com/conductorone/baton-sdk/pkg/uhttp"
	"github.com/grpc-ecosystem/go-grpc-middleware/logging/zap/ctxzap"
)

type DataCenterClient struct {
	auth       *Auth
	httpClient *uhttp.BaseHttpClient
	baseUrl    string
}

type BitbucketError struct {
	ErrorMessage     string                   `json:"error"`
	ErrorDescription string                   `json:"error_description"`
	ErrorCode        int                      `json:"errorCode,omitempty"`
	ErrorSummary     string                   `json:"errorSummary,omitempty" toml:"error_description"`
	ErrorLink        string                   `json:"errorLink,omitempty"`
	ErrorId          string                   `json:"errorId,omitempty"`
	ErrorCauses      []map[string]interface{} `json:"errorCauses,omitempty"`
}

func (b *BitbucketError) Error() string {
	return b.ErrorMessage
}

// GET - http://{baseurl}/rest/api/latest/users
// GET - http://{baseurl}/rest/api/latest/projects
// GET - http://{baseurl}/rest/api/latest/admin/groups
// GET - http://{baseurl}/rest/api/latest/admin/groups/more-members?context={context}
// GET - http://{baseurl}/rest/api/latest/admin/permissions/users
// GET - http://{baseurl}/rest/api/latest/projects/{projectKey}/repos/{repositorySlug}/permissions/users
// GET - http://{baseurl}/rest/api/latest/projects/{projectKey}/repos/{repositorySlug}/permissions/users?name={name}&permission={permission}
// POST - http://{baseurl}/rest/api/latest/admin/users/add-groups
// POST - http://{baseurl}/rest/api/latest/admin/users/remove-group
// PUT - http://{baseurl}/rest/api/latest/projects/{projectKey}/repos/{repositorySlug}/permissions/users?name={name}&permission={permission}
// PUT - http://{baseurl}/rest/api/latest/projects/{projectKey}/permissions/groups
// PUT - http://{baseurl}/rest/api/latest/projects/{projectKey}/permissions/users'
// DEL - http://{baseurl}/rest/api/latest/projects/{projectKey}/repos/{repositorySlug}/permissions/users?name={name}
// DEL - http://{baseurl}/rest/api/latest/projects/{projectKey}/permissions/users
// DEL - http://{baseurl}/rest/api/latest/projects/{projectKey}/permissions/groups

const (
	allUsersEndpoint                      = "rest/api/latest/users"
	allProjectsEndpoint                   = "rest/api/latest/projects"
	allRepositoriesEndpoint               = "rest/api/latest/repos"
	allGroupsEndpoint                     = "rest/api/latest/groups"
	allGroupMembersEndpoint               = "rest/api/latest/admin/groups/more-members"
	allUsersWithGlobalPermissionEndpoint  = "rest/api/latest/admin/permissions/users"
	allGroupsWithGlobalPermissionEndpoint = "rest/api/latest/admin/permissions/groups"
	usersWithPermission                   = "permissions/users"
	groupsWithPermission                  = "permissions/groups"
	addUserToGroupsEndpoint               = "rest/api/latest/admin/users/add-groups"
	removeUserFromGroupEndpoint           = "rest/api/latest/admin/users/remove-group"
)

type Auth struct {
	Username, Password string
	BearerToken        string
}

func (d *DataCenterClient) checkStatusUnauthorizedError(err error) error {
	var bitbucketErr *BitbucketError
	if err == nil {
		return nil
	}

	if d.auth.Username != "" && d.auth.Password != "" {
		// Only squelch permission errors if using bearer token auth
		return err
	}

	if errors.As(err, &bitbucketErr) {
		if bitbucketErr.ErrorCode != http.StatusUnauthorized {
			return fmt.Errorf("%s %s", bitbucketErr.Error(), bitbucketErr.ErrorSummary)
		}
		return nil
	}

	return err
}

func (d *DataCenterClient) WithAuthorization() uhttp.RequestOption {
	// Prefer basic auth to bearer token, since bearer token auth can't get global user/group permissions
	if d.auth.Username != "" && d.auth.Password != "" {
		encodedAuth := base64.StdEncoding.EncodeToString([]byte(d.auth.Username + ":" + d.auth.Password))
		return uhttp.WithHeader("Authorization", "Basic "+encodedAuth)
	}

	return uhttp.WithHeader("Authorization", "Bearer "+d.auth.BearerToken)
}

func isValidUrl(baseUrl string) bool {
	u, err := url.Parse(baseUrl)
	return err == nil && u.Scheme != "" && u.Host != ""
}

func New(ctx context.Context, baseUrl string, auth *Auth) (*DataCenterClient, error) {
	httpClient, err := uhttp.NewClient(ctx,
		uhttp.WithLogger(true, ctxzap.Extract(ctx)),
	)
	if err != nil {
		return nil, err
	}

	cli, err := uhttp.NewBaseHttpClientWithContext(ctx, httpClient)
	if err != nil {
		return nil, err
	}
	if !isValidUrl(baseUrl) {
		return nil, fmt.Errorf("the url : %s is not valid", baseUrl)
	}

	// basic authentication or bearerToken
	dc := DataCenterClient{
		httpClient: cli,
		baseUrl:    baseUrl,
		auth:       auth,
	}

	return &dc, nil
}

func GetCustomErr(req *http.Request, resp *http.Response, err error) *BitbucketError {
	if req == nil {
		return &BitbucketError{
			ErrorMessage:     "Unknown error",
			ErrorDescription: "request should not be nil",
		}
	}

	bbErr := &BitbucketError{
		ErrorMessage:     err.Error(),
		ErrorDescription: err.Error(),
		ErrorLink:        req.URL.String(),
	}

	if resp != nil {
		bbErr.ErrorCode = resp.StatusCode
		bodyBytes, err := io.ReadAll(resp.Body)
		if err != nil {
			bbErr.ErrorSummary = fmt.Sprintf("Error reading response body %s", err.Error())
			return bbErr
		}

		bbErr.ErrorSummary = string(bodyBytes)
	}

	return bbErr
}

func (d *DataCenterClient) MakeURL(ctx context.Context, path string, queryParams map[string]string) (*url.URL, error) {
	endpointUrl, err := url.JoinPath(d.baseUrl, path)
	if err != nil {
		return nil, err
	}

	uri, err := url.Parse(endpointUrl)
	if err != nil {
		return nil, err
	}

	q := uri.Query()
	for k, v := range queryParams {
		q.Set(k, v)
	}

	uri.RawQuery = q.Encode()
	return uri, nil
}

func (d *DataCenterClient) Do(ctx context.Context, method string, uri *url.URL, body interface{}, response interface{}, reqOptions ...uhttp.RequestOption) (*http.Response, error) {
	reqOptions = append(reqOptions,
		uhttp.WithAcceptJSONHeader(),
		d.WithAuthorization(),
	)
	if body != nil {
		reqOptions = append(reqOptions, uhttp.WithJSONBody(body))
	}

	doOptions := []uhttp.DoOption{}
	if response != nil {
		doOptions = append(doOptions, uhttp.WithJSONResponse(response))
	}

	req, err := d.httpClient.NewRequest(ctx, method, uri, reqOptions...)
	if err != nil {
		return nil, GetCustomErr(req, nil, err)
	}

	resp, err := d.httpClient.Do(req, doOptions...)
	if err != nil {
		return nil, GetCustomErr(req, resp, err)
	}

	return resp, nil
}

// Get all users. Only authenticated users may call this resource.
// https://developer.atlassian.com/server/bitbucket/rest/v819/api-group-system-maintenance/#api-api-latest-users-get
func (d *DataCenterClient) GetUsers(ctx context.Context, pToken *pagination.Token) ([]User, string, error) {
	queryParams := pageTokenToQueryParams(pToken)
	uri, err := d.MakeURL(ctx, allUsersEndpoint, queryParams)
	if err != nil {
		return nil, pToken.Token, err
	}

	var userData UsersAPIData
	resp, err := d.Do(ctx, http.MethodGet, uri, nil, &userData)
	if err != nil {
		return nil, pToken.Token, err
	}
	defer resp.Body.Close()

	nextPageToken, err := getNextPageToken(pToken, userData.NextPageStart, userData.IsLastPage)
	return userData.Users, nextPageToken, err
}

func (d *DataCenterClient) GetGroupUsers(ctx context.Context, group string) ([]User, error) {
	var users []User
	var err error
	start := 0

	for {
		queryParams := map[string]string{
			"start": strconv.Itoa(start),
			"limit": strconv.Itoa(ITEMSPERPAGE),
			"group": group,
		}

		uri, err := d.MakeURL(ctx, allUsersEndpoint, queryParams)
		if err != nil {
			return nil, err
		}

		var userData UsersAPIData
		resp, err := d.Do(ctx, http.MethodGet, uri, nil, &userData)
		if err != nil {
			return nil, err
		}
		defer resp.Body.Close()
		users = append(users, userData.Users...)

		start = userData.NextPageStart
		if userData.IsLastPage {
			break
		}
	}

	return users, err
}

// Get projects. Only projects for which the authenticated user has the PROJECT_VIEW permission will be returned.
// https://developer.atlassian.com/server/bitbucket/rest/v819/api-group-project/#api-api-latest-projects-get
func (d *DataCenterClient) GetProjects(ctx context.Context, pToken *pagination.Token) ([]Projects, string, error) {
	queryParams := pageTokenToQueryParams(pToken)
	uri, err := d.MakeURL(ctx, allProjectsEndpoint, queryParams)
	if err != nil {
		return nil, pToken.Token, err
	}

	var projectData ProjectsAPIData
	resp, err := d.Do(ctx, http.MethodGet, uri, nil, &projectData)
	if err != nil {
		return nil, pToken.Token, err
	}
	defer resp.Body.Close()

	nextPageToken, err := getNextPageToken(pToken, projectData.NextPageStart, projectData.IsLastPage)
	return projectData.Projects, nextPageToken, err
}

func (d *DataCenterClient) GetRepos(ctx context.Context, pToken *pagination.Token) ([]Repos, string, error) {
	queryParams := pageTokenToQueryParams(pToken)
	uri, err := d.MakeURL(ctx, allRepositoriesEndpoint, queryParams)
	if err != nil {
		return nil, pToken.Token, err
	}

	var repoData ReposAPIData
	resp, err := d.Do(ctx, http.MethodGet, uri, nil, &repoData)
	if err != nil {
		return nil, pToken.Token, err
	}
	defer resp.Body.Close()

	nextPageToken, err := getNextPageToken(pToken, repoData.NextPageStart, repoData.IsLastPage)
	return repoData.Repos, nextPageToken, err
}

// GetGroups
// Get groups. The authenticated user must have LICENSED_USER permission or higher to call this resource.
// https://developer.atlassian.com/server/bitbucket/rest/v819/api-group-permission-management/#api-api-latest-admin-groups-get
func (d *DataCenterClient) GetGroups(ctx context.Context, pToken *pagination.Token) ([]string, string, error) {
	queryParams := pageTokenToQueryParams(pToken)
	uri, err := d.MakeURL(ctx, allGroupsEndpoint, queryParams)
	if err != nil {
		return nil, pToken.Token, err
	}

	var groupData GroupsAPIData
	resp, err := d.Do(ctx, http.MethodGet, uri, nil, &groupData)
	if err != nil {
		return nil, pToken.Token, err
	}
	defer resp.Body.Close()

	nextPageToken, err := getNextPageToken(pToken, groupData.NextPageStart, groupData.IsLastPage)
	return groupData.Groups, nextPageToken, err
}

// GetGroupMembers
// Get group members. The authenticated user must have the LICENSED_USER permission to call this resource.
// https://developer.atlassian.com/server/bitbucket/rest/v819/api-group-permission-management/#api-api-latest-admin-groups-more-members-get
func (d *DataCenterClient) GetGroupMembers(ctx context.Context, groupName string, pToken *pagination.Token) ([]Members, string, error) {
	queryParams := pageTokenToQueryParams(pToken)
	queryParams["context"] = groupName
	uri, err := d.MakeURL(ctx, allGroupMembersEndpoint, queryParams)
	if err != nil {
		return nil, pToken.Token, err
	}

	var memberData MembersAPIData
	resp, err := d.Do(ctx, http.MethodGet, uri, nil, &memberData)
	if err != nil {
		return nil, pToken.Token, err
	}
	defer resp.Body.Close()

	nextPageToken, err := getNextPageToken(pToken, memberData.NextPageStart, memberData.IsLastPage)
	return memberData.Members, nextPageToken, err
}

// GetGlobalUserPermissions
// Get users with a global permission
// https://developer.atlassian.com/server/bitbucket/rest/v819/api-group-permission-management/#api-api-latest-admin-permissions-users-get
func (d *DataCenterClient) GetGlobalUserPermissions(ctx context.Context, pToken *pagination.Token) ([]UsersPermissions, string, error) {
	queryParams := pageTokenToQueryParams(pToken)
	uri, err := d.MakeURL(ctx, allUsersWithGlobalPermissionEndpoint, queryParams)
	if err != nil {
		return nil, pToken.Token, err
	}

	var permissionsData GlobalPermissionsAPIData
	resp, err := d.Do(ctx, http.MethodGet, uri, nil, &permissionsData)
	if err != nil {
		// if bearer auth, squelch 403 and return empty list
		err = d.checkStatusUnauthorizedError(err)
		if err == nil {
			return nil, "", nil
		}
		return nil, pToken.Token, err
	}
	defer resp.Body.Close()

	nextPageToken, err := getNextPageToken(pToken, permissionsData.NextPageStart, permissionsData.IsLastPage)
	return permissionsData.UsersPermissions, nextPageToken, err
}

func (d *DataCenterClient) RevokeUserGlobalPermission(ctx context.Context, userName string) error {
	uri, err := d.MakeURL(ctx, allUsersWithGlobalPermissionEndpoint, map[string]string{
		"name": userName,
	})
	if err != nil {
		return err
	}

	resp, err := d.Do(ctx, http.MethodDelete, uri, nil, nil)
	if err != nil {
		return err
	}
	defer resp.Body.Close()
	return nil
}

func (d *DataCenterClient) UpdateUserGlobalPermission(ctx context.Context, userName, permission string) error {
	uri, err := d.MakeURL(ctx, allUsersWithGlobalPermissionEndpoint, map[string]string{
		"name":       userName,
		"permission": permission,
	})
	if err != nil {
		return err
	}

	resp, err := d.Do(ctx, http.MethodPut, uri, nil, nil)
	if err != nil {
		return err
	}
	defer resp.Body.Close()
	return nil
}

func (d *DataCenterClient) GetGlobalGroupPermissions(ctx context.Context, pToken *pagination.Token) ([]GroupsPermissions, string, error) {
	queryParams := pageTokenToQueryParams(pToken)
	uri, err := d.MakeURL(ctx, allGroupsWithGlobalPermissionEndpoint, queryParams)
	if err != nil {
		return nil, pToken.Token, err
	}

	var permissionsData GlobalGroupPermissionsAPIData
	resp, err := d.Do(ctx, http.MethodGet, uri, nil, &permissionsData)
	if err != nil {
		// if bearer auth, squelch 403 and return empty list
		err = d.checkStatusUnauthorizedError(err)
		if err == nil {
			return nil, "", nil
		}
		return nil, pToken.Token, err
	}
	defer resp.Body.Close()

	nextPageToken, err := getNextPageToken(pToken, permissionsData.NextPageStart, permissionsData.IsLastPage)
	return permissionsData.GroupsPermissions, nextPageToken, err
}

func (d *DataCenterClient) RevokeGroupGlobalPermission(ctx context.Context, groupName string) error {
	uri, err := d.MakeURL(ctx, allGroupsWithGlobalPermissionEndpoint, map[string]string{
		"name": groupName,
	})
	if err != nil {
		return err
	}

	resp, err := d.Do(ctx, http.MethodDelete, uri, nil, nil)
	if err != nil {
		return err
	}
	defer resp.Body.Close()
	return nil
}

func (d *DataCenterClient) UpdateGroupGlobalPermission(ctx context.Context, groupName, permission string) error {
	uri, err := d.MakeURL(ctx, allGroupsWithGlobalPermissionEndpoint, map[string]string{
		"name":       groupName,
		"permission": permission,
	})
	if err != nil {
		return err
	}

	resp, err := d.Do(ctx, http.MethodPut, uri, nil, nil)
	if err != nil {
		return err
	}
	defer resp.Body.Close()
	return nil
}

// GetUserRepositoryPermissions
// Get users with permission to repository
// https://developer.atlassian.com/server/bitbucket/rest/v819/api-group-permission-management/#api-api-latest-projects-projectkey-repos-repositoryslug-permissions-users-get
func (d *DataCenterClient) GetUserRepositoryPermissions(ctx context.Context, projectKey, repositorySlug string, pToken *pagination.Token) ([]UsersPermissions, string, error) {
	queryParams := pageTokenToQueryParams(pToken)
	path := fmt.Sprintf("%s/%s/repos/%s/%s",
		allProjectsEndpoint,
		projectKey,
		repositorySlug,
		usersWithPermission,
	)
	uri, err := d.MakeURL(ctx, path, queryParams)
	if err != nil {
		return nil, pToken.Token, err
	}

	var permissionsData GlobalPermissionsAPIData
	resp, err := d.Do(ctx, http.MethodGet, uri, nil, &permissionsData)
	if err != nil {
		return nil, pToken.Token, err
	}
	defer resp.Body.Close()

	nextPageToken, err := getNextPageToken(pToken, permissionsData.NextPageStart, permissionsData.IsLastPage)
	return permissionsData.UsersPermissions, nextPageToken, err
}

func (d *DataCenterClient) GetUserProjectsPermissions(ctx context.Context, projectKey string, pToken *pagination.Token) ([]UsersPermissions, string, error) {
	queryParams := pageTokenToQueryParams(pToken)
	path := fmt.Sprintf("%s/%s/%s",
		allProjectsEndpoint,
		projectKey,
		usersWithPermission,
	)
	uri, err := d.MakeURL(ctx, path, queryParams)
	if err != nil {
		return nil, pToken.Token, err
	}

	var permissionsData GlobalPermissionsAPIData
	resp, err := d.Do(ctx, http.MethodGet, uri, nil, &permissionsData)
	if err != nil {
		return nil, pToken.Token, err
	}
	defer resp.Body.Close()

	nextPageToken, err := getNextPageToken(pToken, permissionsData.NextPageStart, permissionsData.IsLastPage)
	return permissionsData.UsersPermissions, nextPageToken, err
}

func (d *DataCenterClient) GetGroupProjectsPermissions(ctx context.Context, projectKey string, pToken *pagination.Token) ([]GroupsPermissions, string, error) {
	queryParams := pageTokenToQueryParams(pToken)
	path := fmt.Sprintf("%s/%s/%s",
		allProjectsEndpoint,
		projectKey,
		groupsWithPermission,
	)
	uri, err := d.MakeURL(ctx, path, queryParams)
	if err != nil {
		return nil, pToken.Token, err
	}

	var permissionsData GlobalGroupPermissionsAPIData
	resp, err := d.Do(ctx, http.MethodGet, uri, nil, &permissionsData)
	if err != nil {
		return nil, pToken.Token, err
	}
	defer resp.Body.Close()

	nextPageToken, err := getNextPageToken(pToken, permissionsData.NextPageStart, permissionsData.IsLastPage)
	return permissionsData.GroupsPermissions, nextPageToken, err
}

func (d *DataCenterClient) GetGroupRepositoryPermissions(ctx context.Context, projectKey, repositorySlug string, pToken *pagination.Token) ([]GroupsPermissions, string, error) {
	queryParams := pageTokenToQueryParams(pToken)
	path := fmt.Sprintf("%s/%s/repos/%s/%s",
		allProjectsEndpoint,
		projectKey,
		repositorySlug,
		groupsWithPermission,
	)
	uri, err := d.MakeURL(ctx, path, queryParams)
	if err != nil {
		return nil, pToken.Token, err
	}

	var permissionsData GroupPermissionsAPIData
	resp, err := d.Do(ctx, http.MethodGet, uri, nil, &permissionsData)
	if err != nil {
		return nil, pToken.Token, err
	}
	defer resp.Body.Close()

	nextPageToken, err := getNextPageToken(pToken, permissionsData.NextPageStart, permissionsData.IsLastPage)
	return permissionsData.GroupsPermissions, nextPageToken, err
}

// AddUserToGroups
// Add a user to one or more groups.
// https://developer.atlassian.com/server/bitbucket/rest/v819/api-group-permission-management/#api-api-latest-admin-users-add-groups-post
func (d *DataCenterClient) AddUserToGroups(ctx context.Context, groupName, userName string) error {
	uri, err := d.MakeURL(ctx, addUserToGroupsEndpoint, nil)
	if err != nil {
		return err
	}

	var (
		body struct {
			Groups []string `json:"groups"`
			User   string   `json:"user"`
		}
		payload = []byte(fmt.Sprintf(`{"groups": ["%s"], "user": "%s"}`, groupName, userName))
	)

	err = json.Unmarshal(payload, &body)
	if err != nil {
		return err
	}

	resp, err := d.Do(ctx, http.MethodPost, uri, body, nil)
	if err != nil {
		return err
	}
	defer resp.Body.Close()

	return nil
}

// RemoveUserFromGroup
// Remove user from group
// https://developer.atlassian.com/server/bitbucket/rest/v819/api-group-permission-management/#api-api-latest-admin-users-remove-group-post
func (d *DataCenterClient) RemoveUserFromGroup(ctx context.Context, userName, groupName string) error {
	uri, err := d.MakeURL(ctx, removeUserFromGroupEndpoint, nil)
	if err != nil {
		return err
	}

	var (
		body struct {
			Context  string `json:"context"`
			ItemName string `json:"itemName"`
		}
		payload = []byte(fmt.Sprintf(`{"context": "%s", "itemName": "%s"}`, userName, groupName))
	)

	err = json.Unmarshal(payload, &body)
	if err != nil {
		return err
	}

	resp, err := d.Do(ctx, http.MethodPost, uri, body, nil)
	if err != nil {
		return err
	}
	defer resp.Body.Close()

	return nil
}

// UpdateUserRepositoryPermission
// Update user repository permission
// https://developer.atlassian.com/server/bitbucket/rest/v819/api-group-permission-management/#api-api-latest-projects-projectkey-repos-repositoryslug-permissions-users-put
func (d *DataCenterClient) UpdateUserRepositoryPermission(ctx context.Context, projectKey, repositorySlug, userName, permission string) error {
	path := fmt.Sprintf("%s/%s/repos/%s/%s",
		allProjectsEndpoint,
		projectKey,
		repositorySlug,
		usersWithPermission,
	)

	uri, err := d.MakeURL(ctx, path, map[string]string{
		"name":       userName,
		"permission": permission,
	})
	if err != nil {
		return err
	}

	resp, err := d.Do(ctx, http.MethodPut, uri, nil, nil)
	if err != nil {
		return err
	}
	defer resp.Body.Close()
	if resp.StatusCode != http.StatusNoContent {
		return fmt.Errorf("user not updated. status code %d", resp.StatusCode)
	}

	return nil
}

// UpdateGroupRepositoryPermission
// Update group repository permission
// The authenticated user must have REPO_ADMIN permission for the specified repository or a higher project or global permission to call this resource.
// https://developer.atlassian.com/server/bitbucket/rest/v819/api-group-permission-management/#api-api-latest-projects-projectkey-repos-repositoryslug-permissions-groups-put
func (d *DataCenterClient) UpdateGroupRepositoryPermission(ctx context.Context, projectKey, repositorySlug, groupName, permission string) error {
	path := fmt.Sprintf("%s/%s/repos/%s/%s",
		allProjectsEndpoint,
		projectKey,
		repositorySlug,
		groupsWithPermission,
	)

	uri, err := d.MakeURL(ctx, path, map[string]string{
		"name":       groupName,
		"permission": permission,
	})
	if err != nil {
		return err
	}

	resp, err := d.Do(ctx, http.MethodPut, uri, nil, nil)
	if err != nil {
		return err
	}

	defer resp.Body.Close()
	if resp.StatusCode != http.StatusNoContent {
		return fmt.Errorf("group not updated. status code %d", resp.StatusCode)
	}

	return nil
}

// RevokeGroupRepositoryPermission
// Revoke group repository permission
// https://developer.atlassian.com/server/bitbucket/rest/v819/api-group-permission-management/#api-api-latest-projects-projectkey-repos-repositoryslug-permissions-groups-delete
func (d *DataCenterClient) RevokeGroupRepositoryPermission(ctx context.Context, projectKey, repositorySlug, groupName string) error {
	path := fmt.Sprintf("%s/%s/repos/%s/%s",
		allProjectsEndpoint,
		projectKey,
		repositorySlug,
		groupsWithPermission,
	)
	uri, err := d.MakeURL(ctx, path, map[string]string{
		"name": groupName,
	})
	if err != nil {
		return err
	}

	resp, err := d.Do(ctx, http.MethodDelete, uri, nil, nil)
	if err != nil {
		return err
	}

	defer resp.Body.Close()
	if resp.StatusCode != http.StatusNoContent {
		return fmt.Errorf("group not removed. status code %d", resp.StatusCode)
	}

	return nil
}

// RevokeUserRepositoryPermission
// Revoke user repository permission
// https://developer.atlassian.com/server/bitbucket/rest/v819/api-group-permission-management/#api-api-latest-projects-projectkey-repos-repositoryslug-permissions-users-delete
func (d *DataCenterClient) RevokeUserRepositoryPermission(ctx context.Context, projectKey, repositorySlug, userName string) error {
	path := fmt.Sprintf("%s/%s/repos/%s/%s",
		allProjectsEndpoint,
		projectKey,
		repositorySlug,
		usersWithPermission,
	)
	uri, err := d.MakeURL(ctx, path, map[string]string{
		"name": userName,
	})
	if err != nil {
		return err
	}

	resp, err := d.Do(ctx, http.MethodDelete, uri, nil, nil)
	if err != nil {
		return err
	}

	defer resp.Body.Close()
	if resp.StatusCode != http.StatusNoContent {
		return fmt.Errorf("user not removed. status code %d", resp.StatusCode)
	}

	return nil
}

// RevokeUserProjectPermission
// Revoke user project permission
// https://developer.atlassian.com/server/bitbucket/rest/v819/api-group-project/#api-api-latest-projects-projectkey-permissions-users-delete
func (d *DataCenterClient) RevokeUserProjectPermission(ctx context.Context, projectKey, userName string) error {
	path := fmt.Sprintf("%s/%s/%s",
		allProjectsEndpoint,
		projectKey,
		usersWithPermission,
	)
	uri, err := d.MakeURL(ctx, path, map[string]string{
		"name": userName,
	})
	if err != nil {
		return err
	}

	resp, err := d.Do(ctx, http.MethodDelete, uri, nil, nil)
	if err != nil {
		return err
	}

	defer resp.Body.Close()
	if resp.StatusCode != http.StatusNoContent {
		return fmt.Errorf("user not removed. status code %d", resp.StatusCode)
	}

	return nil
}

// RevokeGroupProjectPermission
// Revoke group project permission.
// https://developer.atlassian.com/server/bitbucket/rest/v819/api-group-project/#api-api-latest-projects-projectkey-permissions-groups-delete
func (d *DataCenterClient) RevokeGroupProjectPermission(ctx context.Context, projectKey, groupName string) error {
	path := fmt.Sprintf("%s/%s/%s",
		allProjectsEndpoint,
		projectKey,
		groupsWithPermission,
	)
	uri, err := d.MakeURL(ctx, path, map[string]string{
		"name": groupName,
	})
	if err != nil {
		return err
	}

	resp, err := d.Do(ctx, http.MethodDelete, uri, nil, nil)
	if err != nil {
		return err
	}

	defer resp.Body.Close()
	if resp.StatusCode != http.StatusNoContent {
		return fmt.Errorf("group not removed. status code %d", resp.StatusCode)
	}

	return nil
}

// UpdateUserProjectPermission
// Update user project permission. Available project permissions are: PROJECT_READ, PROJECT_WRITE, PROJECT_ADMIN
// https://developer.atlassian.com/server/bitbucket/rest/v819/api-group-project/#api-api-latest-projects-projectkey-permissions-users-put
func (d *DataCenterClient) UpdateUserProjectPermission(ctx context.Context, projectKey, userName, permission string) error {
	path := fmt.Sprintf("%s/%s/%s",
		allProjectsEndpoint,
		projectKey,
		usersWithPermission,
	)
	uri, err := d.MakeURL(ctx, path, map[string]string{
		"name":       userName,
		"permission": permission,
	})
	if err != nil {
		return err
	}

	resp, err := d.Do(ctx, http.MethodPut, uri, nil, nil)
	if err != nil {
		return err
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusNoContent {
		return fmt.Errorf("project not updated. status code %d", resp.StatusCode)
	}

	return nil
}

// UpdateGroupProjectPermission
// Update group project permission. Available project permissions are: PROJECT_READ, PROJECT_WRITE, PROJECT_ADMIN
// https://developer.atlassian.com/server/bitbucket/rest/v819/api-group-project/#api-api-latest-projects-projectkey-permissions-groups-put
func (d *DataCenterClient) UpdateGroupProjectPermission(ctx context.Context, projectKey, groupName, permission string) error {
	path := fmt.Sprintf("%s/%s/%s",
		allProjectsEndpoint,
		projectKey,
		groupsWithPermission,
	)
	uri, err := d.MakeURL(ctx, path, map[string]string{
		"name":       groupName,
		"permission": permission,
	})
	if err != nil {
		return err
	}

	resp, err := d.Do(ctx, http.MethodPut, uri, nil, nil)
	if err != nil {
		return err
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusNoContent {
		return fmt.Errorf("project not updated. status code %d", resp.StatusCode)
	}

	return nil
}
