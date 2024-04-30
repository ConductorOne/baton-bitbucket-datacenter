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
