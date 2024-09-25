package client

import (
	"strconv"

	"github.com/conductorone/baton-sdk/pkg/pagination"
)

// To fetch 1000 results
// https://confluence.atlassian.com/bitbucketserverkb/how-to-apply-the-limit-filter-in-bitbucket-server-and-datacenter-rest-api-and-query-more-than-the-max-limit-of-1000-results-1142440445.html
const ITEMSPERPAGE = 1000

func parsePageData(start, nextPageStart, size int, isLastPage bool) Page {
	var page Page
	if isLastPage {
		return page
	}
	sPage := strconv.Itoa(start)
	nPage := strconv.Itoa(nextPageStart)
	return Page{
		PreviousPage: &sPage,
		NextPage:     &nPage,
		Count:        int64(size),
	}
}

func pageTokenToQueryParams(pToken *pagination.Token) map[string]string {
	queryParams := map[string]string{
		"start": "0",
		"limit": strconv.Itoa(ITEMSPERPAGE),
	}
	if pToken != nil && pToken.Token != "" {
		queryParams["start"] = pToken.Token
	}
	return queryParams
}

func getNextPageToken(nextPageStart int, isLastPage bool) string {
	if isLastPage {
		return ""
	}

	return strconv.Itoa(nextPageStart)
}

// Page is base struct for resource pagination.
type Page struct {
	PreviousPage *string `json:"previous_page"`
	NextPage     *string `json:"nextPageStart"`
	Count        int64   `json:"size"`
}

// PageOptions is options for list method of paginatable resources.
// It's used to create query string.
type PageOptions struct {
	PerPage int `url:"limit,omitempty"`
	Page    int `url:"page,omitempty"`
}

// HasPrev checks if the Page has previous page.
func (p Page) HasPrev() bool {
	return (p.PreviousPage != nil)
}

// HasNext checks if the Page has next page.
func (p Page) HasNext() bool {
	return (p.NextPage != nil)
}
