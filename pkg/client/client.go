package client

import (
	"context"
	"encoding/base64"
	"encoding/json"
	"errors"
	"fmt"
	"net/http"
	"net/url"
	"strconv"

	"github.com/conductorone/baton-sdk/pkg/uhttp"
	"github.com/grpc-ecosystem/go-grpc-middleware/logging/zap/ctxzap"
)

const BASEURL = "http://localhost:7990/rest/api/latest"

type DataCenterClient struct {
	Auth         *auth
	httpClient   *uhttp.BaseHttpClient
	baseEndpoint string
}

type auth struct {
	user, password string
}

func WithAuthorizationBearerHeader(token string) uhttp.RequestOption {
	return uhttp.WithHeader("Authorization", "Bearer "+token)
}

func basicAuth(username, password string) string {
	auth := username + ":" + password
	return base64.StdEncoding.EncodeToString([]byte(auth))
}

func WithSetBasicAuthHeader(username, password string) uhttp.RequestOption {
	return uhttp.WithHeader("Authorization", "Basic "+basicAuth(username, password))
}

func (d *DataCenterClient) getUser() string {
	return d.Auth.user
}

func (d *DataCenterClient) getPWD() string {
	return d.Auth.password
}

func New(ctx context.Context, clientId, clientSecret string) (*DataCenterClient, error) {
	httpClient, err := uhttp.NewClient(ctx, uhttp.WithLogger(true, ctxzap.Extract(ctx)))
	if err != nil {
		return nil, err
	}

	cli := uhttp.NewBaseHttpClient(httpClient)
	dc := DataCenterClient{
		httpClient:   cli,
		baseEndpoint: BASEURL,
		Auth: &auth{
			user:     clientId,
			password: clientSecret,
		},
	}

	return &dc, nil
}

func (d *DataCenterClient) GetUsers(ctx context.Context, startPage, limit string) ([]Users, Page, error) {
	var (
		userData     UsersAPIData
		page         Page
		sPage, nPage = "0", "0"
	)
	strUrl, err := url.JoinPath(d.baseEndpoint, "/users")
	if err != nil {
		return nil, Page{}, err
	}

	uri, err := url.Parse(strUrl)
	if err != nil {
		return nil, Page{}, err
	}

	if startPage != "" {
		sPage = startPage
	}

	setRawQuery(uri, sPage, limit)
	req, err := d.httpClient.NewRequest(ctx,
		http.MethodGet,
		uri,
		uhttp.WithAcceptJSONHeader(),
		WithSetBasicAuthHeader(d.getUser(), d.getPWD()),
	)
	if err != nil {
		return nil, Page{}, err
	}

	resp, err := d.httpClient.Do(req, uhttp.WithJSONResponse(&userData))
	if err != nil {
		return nil, Page{}, err
	}

	defer resp.Body.Close()
	sPage = strconv.Itoa(userData.Start)
	nPage = strconv.Itoa(userData.NextPageStart)
	if !userData.IsLastPage {
		page = Page{
			PreviousPage: &sPage,
			NextPage:     &nPage,
			Count:        int64(userData.Size),
		}
	}

	return userData.Users, page, nil
}

func (d *DataCenterClient) ListUsers(ctx context.Context, opts PageOptions) ([]Users, string, error) {
	var nextPageToken string = ""
	users, page, err := d.GetUsers(ctx, strconv.Itoa(opts.Page), strconv.Itoa(opts.PerPage))
	if err != nil {
		return users, "", err
	}

	if page.HasNext() {
		nextPageToken = *page.NextPage
	}

	return users, nextPageToken, err
}

func (d *DataCenterClient) GetProjects(ctx context.Context, startPage, limit string) ([]Projects, Page, error) {
	var (
		projectData  ProjectsAPIData
		page         Page
		sPage, nPage = "0", "0"
	)
	strUrl, err := url.JoinPath(d.baseEndpoint, "/projects")
	if err != nil {
		return nil, Page{}, err
	}

	uri, err := url.Parse(strUrl)
	if err != nil {
		return nil, Page{}, err
	}

	if startPage != "" {
		sPage = startPage
	}

	setRawQuery(uri, sPage, limit)
	req, err := d.httpClient.NewRequest(ctx,
		http.MethodGet,
		uri,
		uhttp.WithAcceptJSONHeader(),
		WithSetBasicAuthHeader(d.getUser(), d.getPWD()),
	)
	if err != nil {
		return nil, Page{}, err
	}

	resp, err := d.httpClient.Do(req, uhttp.WithJSONResponse(&projectData))
	if err != nil {
		return nil, Page{}, err
	}

	defer resp.Body.Close()
	sPage = strconv.Itoa(projectData.Start)
	nPage = strconv.Itoa(projectData.NextPageStart)
	if !projectData.IsLastPage {
		page = Page{
			PreviousPage: &sPage,
			NextPage:     &nPage,
			Count:        int64(projectData.Size),
		}
	}

	return projectData.Projects, page, nil
}

func (d *DataCenterClient) ListProjects(ctx context.Context, opts PageOptions) ([]Projects, string, error) {
	var nextPageToken string = ""
	projects, page, err := d.GetProjects(ctx, strconv.Itoa(opts.Page), strconv.Itoa(opts.PerPage))
	if err != nil {
		return projects, "", err
	}

	if page.HasNext() {
		nextPageToken = *page.NextPage
	}

	return projects, nextPageToken, err
}

func (d *DataCenterClient) GetRepos(ctx context.Context, startPage, limit string) ([]Repos, Page, error) {
	var (
		repoData     ReposAPIData
		page         Page
		sPage, nPage = "0", "0"
	)
	strUrl, err := url.JoinPath(d.baseEndpoint, "/repos")
	if err != nil {
		return nil, Page{}, err
	}

	uri, err := url.Parse(strUrl)
	if err != nil {
		return nil, Page{}, err
	}

	if startPage != "" {
		sPage = startPage
	}

	setRawQuery(uri, sPage, limit)
	req, err := d.httpClient.NewRequest(ctx,
		http.MethodGet,
		uri,
		uhttp.WithAcceptJSONHeader(),
		WithSetBasicAuthHeader(d.getUser(), d.getPWD()),
	)
	if err != nil {
		return nil, Page{}, err
	}

	resp, err := d.httpClient.Do(req, uhttp.WithJSONResponse(&repoData))
	if err != nil {
		return nil, Page{}, err
	}

	defer resp.Body.Close()
	sPage = strconv.Itoa(repoData.Start)
	nPage = strconv.Itoa(repoData.NextPageStart)
	if !repoData.IsLastPage {
		page = Page{
			PreviousPage: &sPage,
			NextPage:     &nPage,
			Count:        int64(repoData.Size),
		}
	}

	return repoData.Repos, page, nil
}

func (d *DataCenterClient) ListRepos(ctx context.Context, opts PageOptions) ([]Repos, string, error) {
	var nextPageToken string = ""
	repos, page, err := d.GetRepos(ctx, strconv.Itoa(opts.Page), strconv.Itoa(opts.PerPage))
	if err != nil {
		return repos, "", err
	}

	if page.HasNext() {
		nextPageToken = *page.NextPage
	}

	return repos, nextPageToken, err
}

func (d *DataCenterClient) GetGroups(ctx context.Context, startPage, limit string) ([]string, Page, error) {
	var (
		groupData    GroupsAPIData
		page         Page
		sPage, nPage = "0", "0"
	)
	strUrl, err := url.JoinPath(d.baseEndpoint, "/groups")
	if err != nil {
		return nil, Page{}, err
	}

	uri, err := url.Parse(strUrl)
	if err != nil {
		return nil, Page{}, err
	}

	if startPage != "" {
		sPage = startPage
	}

	setRawQuery(uri, sPage, limit)
	req, err := d.httpClient.NewRequest(ctx,
		http.MethodGet,
		uri,
		uhttp.WithAcceptJSONHeader(),
		WithSetBasicAuthHeader(d.getUser(), d.getPWD()),
	)
	if err != nil {
		return nil, Page{}, err
	}

	resp, err := d.httpClient.Do(req, uhttp.WithJSONResponse(&groupData))
	if err != nil {
		return nil, Page{}, err
	}

	defer resp.Body.Close()
	sPage = strconv.Itoa(groupData.Start)
	nPage = strconv.Itoa(groupData.NextPageStart)
	if !groupData.IsLastPage {
		page = Page{
			PreviousPage: &sPage,
			NextPage:     &nPage,
			Count:        int64(groupData.Size),
		}
	}

	return groupData.Groups, page, nil
}

func (d *DataCenterClient) ListGroups(ctx context.Context, opts PageOptions) ([]string, string, error) {
	var nextPageToken string = ""
	groups, page, err := d.GetGroups(ctx, strconv.Itoa(opts.Page), strconv.Itoa(opts.PerPage))
	if err != nil {
		return groups, "", err
	}

	if page.HasNext() {
		nextPageToken = *page.NextPage
	}

	return groups, nextPageToken, err
}

// GetGroupMembers get group members
// https://developer.atlassian.com/server/bitbucket/rest/v819/api-group-permission-management/#api-api-latest-admin-groups-more-members-get
func (d *DataCenterClient) GetGroupMembers(ctx context.Context, startPage, limit, groupName string) ([]Members, Page, error) {
	var (
		memberData   MembersAPIData
		page         Page
		sPage, nPage = "0", "0"
	)
	strUrl := fmt.Sprintf("%s/admin/groups/more-members?context=%s", d.baseEndpoint, groupName)
	uri, err := url.Parse(strUrl)
	if err != nil {
		return nil, Page{}, err
	}

	if startPage != "" {
		sPage = startPage
	}

	setRawQuery(uri, sPage, limit)
	req, err := d.httpClient.NewRequest(ctx,
		http.MethodGet,
		uri,
		uhttp.WithAcceptJSONHeader(),
		WithSetBasicAuthHeader(d.getUser(), d.getPWD()),
	)
	if err != nil {
		return nil, Page{}, err
	}

	resp, err := d.httpClient.Do(req, uhttp.WithJSONResponse(&memberData))
	if err != nil {
		return nil, Page{}, err
	}

	defer resp.Body.Close()
	sPage = strconv.Itoa(memberData.Start)
	nPage = strconv.Itoa(memberData.NextPageStart)
	if !memberData.IsLastPage {
		page = Page{
			PreviousPage: &sPage,
			NextPage:     &nPage,
			Count:        int64(memberData.Size),
		}
	}

	return memberData.Members, page, nil
}

func setRawQuery(uri *url.URL, sPage string, limit string) {
	q := uri.Query()
	q.Set("start", sPage)
	q.Set("limit", limit)
	uri.RawQuery = q.Encode()
}

func (d *DataCenterClient) ListGroupMembers(ctx context.Context, opts PageOptions, groupName string) ([]Members, string, error) {
	var nextPageToken string = ""
	members, page, err := d.GetGroupMembers(ctx,
		strconv.Itoa(opts.Page),
		strconv.Itoa(opts.PerPage),
		groupName,
	)
	if err != nil {
		return members, "", err
	}

	if page.HasNext() {
		nextPageToken = *page.NextPage
	}

	return members, nextPageToken, err
}

// GetGlobalPermissions get users with a global permission
// https://developer.atlassian.com/server/bitbucket/rest/v819/api-group-permission-management/#api-api-latest-admin-permissions-users-get
func (d *DataCenterClient) GetGlobalPermissions(ctx context.Context, startPage, limit string) ([]UsersPermissions, Page, error) {
	var (
		permissionsData GlobalPermissionsAPIData
		page            Page
		sPage, nPage    = "0", "0"
	)
	strUrl, err := url.JoinPath(d.baseEndpoint, "/admin/permissions/users")
	if err != nil {
		return nil, Page{}, err
	}

	uri, err := url.Parse(strUrl)
	if err != nil {
		return nil, Page{}, err
	}

	if startPage != "" {
		sPage = startPage
	}

	setRawQuery(uri, sPage, limit)
	req, err := d.httpClient.NewRequest(ctx,
		http.MethodGet,
		uri,
		uhttp.WithAcceptJSONHeader(),
		WithSetBasicAuthHeader(d.getUser(), d.getPWD()),
	)
	if err != nil {
		return nil, Page{}, err
	}

	resp, err := d.httpClient.Do(req, uhttp.WithJSONResponse(&permissionsData))
	if err != nil {
		return nil, Page{}, err
	}

	defer resp.Body.Close()
	sPage = strconv.Itoa(permissionsData.Start)
	nPage = strconv.Itoa(permissionsData.NextPageStart)
	if !permissionsData.IsLastPage {
		page = Page{
			PreviousPage: &sPage,
			NextPage:     &nPage,
			Count:        int64(permissionsData.Size),
		}
	}

	return permissionsData.UsersPermissions, page, nil
}

func (d *DataCenterClient) ListGlobalPermissions(ctx context.Context, opts PageOptions) ([]UsersPermissions, string, error) {
	var nextPageToken string = ""
	usersPermissions, page, err := d.GetGlobalPermissions(ctx,
		strconv.Itoa(opts.Page),
		strconv.Itoa(opts.PerPage),
	)
	if err != nil {
		return usersPermissions, "", err
	}

	if page.HasNext() {
		nextPageToken = *page.NextPage
	}

	return usersPermissions, nextPageToken, err
}

func (d *DataCenterClient) GetUserRepositoryPermissions(ctx context.Context, startPage, limit, projectKey, repositorySlug string) ([]UsersPermissions, Page, error) {
	var (
		permissionData GlobalPermissionsAPIData
		page           Page
		sPage, nPage   = "0", "0"
	)
	strUrl := fmt.Sprintf("%s/projects/%s/repos/%s/permissions/users", d.baseEndpoint, projectKey, repositorySlug)
	uri, err := url.Parse(strUrl)
	if err != nil {
		return nil, Page{}, err
	}

	if startPage != "" {
		sPage = startPage
	}

	setRawQuery(uri, sPage, limit)
	req, err := d.httpClient.NewRequest(ctx,
		http.MethodGet,
		uri,
		uhttp.WithAcceptJSONHeader(),
		WithSetBasicAuthHeader(d.getUser(), d.getPWD()),
	)
	if err != nil {
		return nil, Page{}, err
	}

	resp, err := d.httpClient.Do(req, uhttp.WithJSONResponse(&permissionData))
	if err != nil {
		return nil, Page{}, err
	}

	defer resp.Body.Close()
	sPage = strconv.Itoa(permissionData.Start)
	nPage = strconv.Itoa(permissionData.NextPageStart)
	if !permissionData.IsLastPage {
		page = Page{
			PreviousPage: &sPage,
			NextPage:     &nPage,
			Count:        int64(permissionData.Size),
		}
	}

	return permissionData.UsersPermissions, page, nil
}

func (d *DataCenterClient) ListUserRepositoryPermissions(ctx context.Context, opts PageOptions, projectKey, repositorySlug string) ([]UsersPermissions, string, error) {
	var nextPageToken string = ""
	permissions, page, err := d.GetUserRepositoryPermissions(ctx,
		strconv.Itoa(opts.Page),
		strconv.Itoa(opts.PerPage),
		projectKey,
		repositorySlug,
	)
	if err != nil {
		return permissions, "", err
	}

	if page.HasNext() {
		nextPageToken = *page.NextPage
	}

	return permissions, nextPageToken, err
}

func (d *DataCenterClient) GetProjectsPermissions(ctx context.Context, startPage, limit, projectKey string) ([]UsersPermissions, Page, error) {
	var (
		permissionData GlobalPermissionsAPIData
		page           Page
		sPage, nPage   = "0", "0"
	)
	strUrl := fmt.Sprintf("%s/projects/%s/permissions/users", d.baseEndpoint, projectKey)
	uri, err := url.Parse(strUrl)
	if err != nil {
		return nil, Page{}, err
	}

	if startPage != "" {
		sPage = startPage
	}

	setRawQuery(uri, sPage, limit)
	req, err := d.httpClient.NewRequest(ctx,
		http.MethodGet,
		uri,
		uhttp.WithAcceptJSONHeader(),
		WithSetBasicAuthHeader(d.getUser(), d.getPWD()),
	)
	if err != nil {
		return nil, Page{}, err
	}

	resp, err := d.httpClient.Do(req, uhttp.WithJSONResponse(&permissionData))
	if err != nil {
		return nil, Page{}, err
	}

	defer resp.Body.Close()
	sPage = strconv.Itoa(permissionData.Start)
	nPage = strconv.Itoa(permissionData.NextPageStart)
	if !permissionData.IsLastPage {
		page = Page{
			PreviousPage: &sPage,
			NextPage:     &nPage,
			Count:        int64(permissionData.Size),
		}
	}

	return permissionData.UsersPermissions, page, nil
}

func (d *DataCenterClient) ListProjectsPermissions(ctx context.Context, opts PageOptions, projectKey string) ([]UsersPermissions, string, error) {
	var nextPageToken string = ""
	permissions, page, err := d.GetProjectsPermissions(ctx,
		strconv.Itoa(opts.Page),
		strconv.Itoa(opts.PerPage),
		projectKey,
	)
	if err != nil {
		return permissions, "", err
	}

	if page.HasNext() {
		nextPageToken = *page.NextPage
	}

	return permissions, nextPageToken, err
}

func (d *DataCenterClient) GetGroupRepositoryPermissions(ctx context.Context, startPage, limit, projectKey, repositorySlug string) ([]GroupsPermissions, Page, error) {
	var (
		permissionData GroupPermissionsAPIData
		page           Page
		sPage, nPage   = "0", "0"
	)
	strUrl := fmt.Sprintf("%s/projects/%s/repos/%s/permissions/groups", d.baseEndpoint, projectKey, repositorySlug)
	uri, err := url.Parse(strUrl)
	if err != nil {
		return nil, Page{}, err
	}

	if startPage != "" {
		sPage = startPage
	}

	setRawQuery(uri, sPage, limit)
	req, err := d.httpClient.NewRequest(ctx,
		http.MethodGet,
		uri,
		uhttp.WithAcceptJSONHeader(),
		WithSetBasicAuthHeader(d.getUser(), d.getPWD()),
	)
	if err != nil {
		return nil, Page{}, err
	}

	resp, err := d.httpClient.Do(req, uhttp.WithJSONResponse(&permissionData))
	if err != nil {
		return nil, Page{}, err
	}

	defer resp.Body.Close()
	sPage = strconv.Itoa(permissionData.Start)
	nPage = strconv.Itoa(permissionData.NextPageStart)
	if !permissionData.IsLastPage {
		page = Page{
			PreviousPage: &sPage,
			NextPage:     &nPage,
			Count:        int64(permissionData.Size),
		}
	}

	return permissionData.GroupsPermissions, page, nil
}

func (d *DataCenterClient) ListGroupRepositoryPermissions(ctx context.Context, opts PageOptions, projectKey, repositorySlug string) ([]GroupsPermissions, string, error) {
	var nextPageToken string = ""
	permissions, page, err := d.GetGroupRepositoryPermissions(ctx,
		strconv.Itoa(opts.Page),
		strconv.Itoa(opts.PerPage),
		projectKey,
		repositorySlug,
	)
	if err != nil {
		return permissions, "", err
	}

	if page.HasNext() {
		nextPageToken = *page.NextPage
	}

	return permissions, nextPageToken, err
}

func (d *DataCenterClient) AddUserToGroups(ctx context.Context, groupName, userName string) error {
	var (
		body    Body
		payload = []byte(fmt.Sprintf(`{"groups": ["%s"], "user": "%s"}`, groupName, userName))
	)

	strUrl, err := url.JoinPath(d.baseEndpoint, "/admin/users/add-groups")
	if err != nil {
		return err
	}

	uri, err := url.Parse(strUrl)
	if err != nil {
		return err
	}

	err = json.Unmarshal(payload, &body)
	if err != nil {
		return err
	}

	req, err := d.httpClient.NewRequest(ctx,
		http.MethodPost,
		uri,
		uhttp.WithAcceptJSONHeader(),
		WithSetBasicAuthHeader(d.getUser(), d.getPWD()),
		uhttp.WithJSONBody(body),
	)

	if err != nil {
		return err
	}

	resp, err := d.httpClient.Do(req)
	if err != nil {
		return err
	}

	defer resp.Body.Close()
	if resp.StatusCode != http.StatusOK {
		return errors.New("user not added")
	}

	return nil
}
