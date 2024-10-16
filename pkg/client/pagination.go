package client

import (
	"strconv"

	"github.com/conductorone/baton-sdk/pkg/pagination"
)

// To fetch 1000 results
// https://confluence.atlassian.com/bitbucketserverkb/how-to-apply-the-limit-filter-in-bitbucket-server-and-datacenter-rest-api-and-query-more-than-the-max-limit-of-1000-results-1142440445.html
const ITEMSPERPAGE = 1000

func pageTokenToQueryParams(pToken *pagination.Token) map[string]string {
	queryParams := map[string]string{
		"start": "0",
		"limit": strconv.Itoa(ITEMSPERPAGE),
	}
	if pToken == nil || pToken.Token == "" {
		return queryParams
	}

	bag := &pagination.Bag{}
	err := bag.Unmarshal(pToken.Token)
	if err != nil {
		return queryParams
	}

	if bag.ResourceTypeID() == "group" {
		queryParams["group"] = bag.ResourceID()
	}

	if bag.PageToken() != "" {
		queryParams["start"] = bag.PageToken()
	}

	return queryParams
}

func getNextPageToken(pToken *pagination.Token, nextPageStart int, isLastPage bool) (string, error) {
	bag := &pagination.Bag{}
	if pToken == nil || pToken.Token == "" {
		bag.Push(pagination.PageState{
			Token: strconv.Itoa(nextPageStart),
		})
		return bag.Marshal()
	}

	err := bag.Unmarshal(pToken.Token)
	if err != nil {
		return "", err
	}

	if isLastPage {
		bag.Pop()
		return bag.Marshal()
	}

	return bag.NextToken(strconv.Itoa(nextPageStart))
}
