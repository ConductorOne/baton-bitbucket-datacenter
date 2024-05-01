package client

type UsersAPIData struct {
	Size          int     `json:"size,omitempty"`
	Limit         int     `json:"limit,omitempty"`
	IsLastPage    bool    `json:"isLastPage,omitempty"`
	Users         []Users `json:"values,omitempty"`
	Start         int     `json:"start,omitempty"`
	NextPageStart int     `json:"nextPageStart,omitempty"`
}

type Users struct {
	Name         string   `json:"name,omitempty"`
	EmailAddress string   `json:"emailAddress,omitempty"`
	Active       bool     `json:"active,omitempty"`
	DisplayName  string   `json:"displayName,omitempty"`
	ID           int      `json:"id,omitempty"`
	Slug         string   `json:"slug,omitempty"`
	Type         string   `json:"type,omitempty"`
	Links        UserSelf `json:"links,omitempty"`
}

type UserSelf struct {
	Self any `json:"self,omitempty"`
}

type ProjectsAPIData struct {
	Size          int        `json:"size,omitempty"`
	Limit         int        `json:"limit,omitempty"`
	IsLastPage    bool       `json:"isLastPage,omitempty"`
	Projects      []Projects `json:"values,omitempty"`
	Start         int        `json:"start,omitempty"`
	NextPageStart int        `json:"nextPageStart,omitempty"`
}

type Projects struct {
	Key    string      `json:"key,omitempty"`
	ID     int         `json:"id,omitempty"`
	Name   string      `json:"name,omitempty"`
	Public bool        `json:"public,omitempty"`
	Type   string      `json:"type,omitempty"`
	Links  ProjectSelf `json:"links,omitempty"`
}

type ProjectSelf struct {
	Self any `json:"self,omitempty"`
}

type ReposAPIData struct {
	Size          int     `json:"size,omitempty"`
	Limit         int     `json:"limit,omitempty"`
	IsLastPage    bool    `json:"isLastPage,omitempty"`
	Repos         []Repos `json:"values,omitempty"`
	Start         int     `json:"start,omitempty"`
	NextPageStart int     `json:"nextPageStart,omitempty"`
}

type Repos struct {
	Slug          string   `json:"slug,omitempty"`
	ID            int      `json:"id,omitempty"`
	Name          string   `json:"name,omitempty"`
	HierarchyId   string   `json:"hierarchyId,omitempty"`
	ScmId         string   `json:"scmId,omitempty"`
	State         string   `json:"state,omitempty"`
	StatusMessage string   `json:"statusMessage,omitempty"`
	Forkable      bool     `json:"forkable,omitempty"`
	Project       Projects `json:"project,omitempty"`
}

type GroupsAPIData struct {
	Size          int      `json:"size,omitempty"`
	Limit         int      `json:"limit,omitempty"`
	IsLastPage    bool     `json:"isLastPage,omitempty"`
	Groups        []string `json:"values,omitempty"`
	Start         int      `json:"start,omitempty"`
	NextPageStart int      `json:"nextPageStart,omitempty"`
}
