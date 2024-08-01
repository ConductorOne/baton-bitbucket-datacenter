package main

import (
	"github.com/conductorone/baton-sdk/pkg/field"
)

var (
	BitbucketUsername = field.StringField(
		"bitbucketdc-username",
		field.WithDescription("Username of administrator used to connect to the BitBucketDC API."),
	)
	BitbucketPassword = field.StringField(
		"bitbucketdc-password",
		field.WithDescription("Application password used to connect to the BitBucketDC API."),
	)
	BitbucketBaseUrl = field.StringField(
		"bitbucketdc-baseurl",
		field.WithDescription("Bitbucket Data Center server. example http://localhost:7990."),
		field.WithRequired(true),
		field.WithDefaultValue("http://localhost:7990"),
	)
	BitbucketToken = field.StringField(
		"bitbucketdc-token",
		field.WithDescription("HTTP access tokens in Bitbucket Data Center"),
	)
	SkipRepos = field.BoolField(
		"skip-repos",
		field.WithDescription("Skip repositories"),
	)
)

var fields = []field.SchemaField{
	BitbucketUsername,
	BitbucketPassword,
	BitbucketBaseUrl,
	BitbucketToken,
	SkipRepos,
}

var constraints = []field.SchemaFieldRelationship{
	field.FieldsRequiredTogether(BitbucketUsername, BitbucketPassword),
	field.FieldsMutuallyExclusive(BitbucketToken, BitbucketUsername),
	field.FieldsMutuallyExclusive(BitbucketToken, BitbucketPassword),
}

var cfg = field.NewConfiguration(fields, constraints...)
