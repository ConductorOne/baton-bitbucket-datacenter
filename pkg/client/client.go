package client

import (
	"context"
	"encoding/base64"
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

func (d *DataCenterClient) GetUsers(ctx context.Context, startPage string) ([]Users, Page, error) {
	var (
		userData UsersAPIData
		page     Page
		sPage    = "0"
		nPage    = "0"
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

	q := uri.Query()
	q.Set("start", sPage)
	uri.RawQuery = q.Encode()
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

func (d *DataCenterClient) ListUsers(ctx context.Context, pageToken int) ([]Users, string, error) {
	var nextPageToken string = ""
	users, page, err := d.GetUsers(ctx, strconv.Itoa(pageToken))
	if err != nil {
		return users, "", err
	}

	if page.HasNext() {
		nextPageToken = *page.NextPage
	}

	return users, nextPageToken, err
}

func (d *DataCenterClient) GetProjects(ctx context.Context, startPage string) ([]Projects, Page, error) {
	var (
		projectData ProjectsAPIData
		page        Page
		sPage       = "0"
		nPage       = "0"
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

	q := uri.Query()
	q.Set("start", sPage)
	uri.RawQuery = q.Encode()
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

func (d *DataCenterClient) ListProjects(ctx context.Context, pageToken int) ([]Projects, string, error) {
	var nextPageToken string = ""
	projects, page, err := d.GetProjects(ctx, strconv.Itoa(pageToken))
	if err != nil {
		return projects, "", err
	}

	if page.HasNext() {
		nextPageToken = *page.NextPage
	}

	return projects, nextPageToken, err
}
