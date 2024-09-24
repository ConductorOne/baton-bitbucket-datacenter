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
	"github.com/conductorone/baton-sdk/pkg/types/grant"
	rs "github.com/conductorone/baton-sdk/pkg/types/resource"
	"github.com/grpc-ecosystem/go-grpc-middleware/logging/zap/ctxzap"
	"go.uber.org/zap"
)

type orgBuilder struct {
	resourceType *v2.ResourceType
	client       *client.DataCenterClient
}

func (o *orgBuilder) ResourceType(ctx context.Context) *v2.ResourceType {
	return o.resourceType
}

func (o *orgBuilder) List(ctx context.Context, parentResourceID *v2.ResourceId, pToken *pagination.Token) ([]*v2.Resource, string, annotations.Annotations, error) {
	resourceOptions := []rs.ResourceOption{}
	if parentResourceID != nil {
		resourceOptions = append(resourceOptions, rs.WithParentResourceID(parentResourceID))
	}

	resource, err := rs.NewResource(
		"Bitbucket Datacenter Organization",
		resourceTypeOrg,
		"1",
		resourceOptions...,
	)
	if err != nil {
		return nil, "", nil, err
	}

	return []*v2.Resource{resource}, "", nil, nil
}

const globalPermissionLicensedUser = "LICENSED_USER"
const globalPermissionProjectCreate = "PROJECT_CREATE"
const globalPermissionAdmin = "ADMIN"
const globalPermissionSysAdmin = "SYS_ADMIN"

// DO NOT CHANGE THE ORDER OF THIS SLICE. Doing so will break isLowerPermission().
var globalPermissions = []string{
	globalPermissionLicensedUser,
	globalPermissionProjectCreate,
	globalPermissionAdmin,
	globalPermissionSysAdmin,
}

func getLowerPermission(permission string) string {
	switch permission {
	case globalPermissionSysAdmin:
		return globalPermissionAdmin
	case globalPermissionAdmin:
		return globalPermissionProjectCreate
	case globalPermissionProjectCreate:
		return globalPermissionLicensedUser
	case globalPermissionLicensedUser:
		return ""
	}
	return ""
}

func isLowerPermission(lowerPermission, higherPermission string) bool {
	return slices.Index(globalPermissions, lowerPermission) < slices.Index(globalPermissions, higherPermission)
}

func getImpliedPermissions(permission string) []string {
	switch permission {
	case globalPermissionSysAdmin:
		return []string{globalPermissionAdmin, globalPermissionProjectCreate, globalPermissionLicensedUser}
	case globalPermissionAdmin:
		return []string{globalPermissionProjectCreate, globalPermissionLicensedUser}
	case globalPermissionProjectCreate:
		return []string{globalPermissionLicensedUser}
	case globalPermissionLicensedUser:
		return []string{}
	}
	return []string{}
}

func (o *orgBuilder) Entitlements(ctx context.Context, resource *v2.Resource, pToken *pagination.Token) ([]*v2.Entitlement, string, annotations.Annotations, error) {
	rv := []*v2.Entitlement{}

	for _, permission := range globalPermissions {
		entitlement := ent.NewPermissionEntitlement(
			resource,
			permission,
			ent.WithDisplayName(strings.ToLower(permission)),
			ent.WithDescription(fmt.Sprintf("Global permission %s", permission)),
			ent.WithGrantableTo(resourceTypeUser, resourceTypeGroup),
		)
		rv = append(rv, entitlement)
	}

	return rv, "", nil, nil
}

func (o *orgBuilder) Grants(ctx context.Context, resource *v2.Resource, pToken *pagination.Token) ([]*v2.Grant, string, annotations.Annotations, error) {
	var (
		pageToken int
		rv        []*v2.Grant
	)
	_, bag, err := unmarshalSkipToken(pToken)
	if err != nil {
		return nil, "", nil, err
	}

	if bag.Current() == nil {
		bag.Push(pagination.PageState{
			ResourceTypeID: resourceTypeUser.Id,
		})
		bag.Push(pagination.PageState{
			ResourceTypeID: resourceTypeGroup.Id,
		})
	}

	if bag.Current().Token != "" {
		pageToken, err = strconv.Atoi(bag.Current().Token)
		if err != nil {
			return nil, "", nil, err
		}
	}

	switch bag.ResourceTypeID() {
	case resourceTypeUser.Id:
		userPermissions, nextPageToken, err := o.client.ListGlobalUserPermissions(ctx, client.PageOptions{
			PerPage: ITEMSPERPAGE,
			Page:    pageToken,
		})
		if err != nil {
			return nil, "", nil, err
		}

		err = bag.Next(nextPageToken)
		if err != nil {
			return nil, "", nil, err
		}

		for _, userPermission := range userPermissions {
			ur, err := userResource(ctx, &client.User{
				Name:        userPermission.User.Name,
				DisplayName: userPermission.User.DisplayName,
				ID:          userPermission.User.ID,
				Type:        userPermission.User.Type,
			}, resource.Id)
			if err != nil {
				return nil, "", nil, fmt.Errorf("error creating user resource for bitbucket org: %w", err)
			}
			permissionGrant := grant.NewGrant(resource, userPermission.Permission, ur.Id)
			rv = append(rv, permissionGrant)
			otherPermissions := getImpliedPermissions(userPermission.Permission)
			for _, permission := range otherPermissions {
				permissionGrant := grant.NewGrant(resource, permission, ur.Id)
				rv = append(rv, permissionGrant)
			}
		}

	case resourceTypeGroup.Id:
		groupPermissions, nextPageToken, err := o.client.ListGlobalGroupPermissions(ctx, client.PageOptions{
			PerPage: ITEMSPERPAGE,
			Page:    pageToken,
		})
		if err != nil {
			return nil, "", nil, err
		}

		err = bag.Next(nextPageToken)
		if err != nil {
			return nil, "", nil, err
		}

		for _, groupPermission := range groupPermissions {
			gr, err := groupResource(ctx, groupPermission.Group.Name, nil)
			if err != nil {
				return nil, "", nil, fmt.Errorf("error creating group resource for bitbucket org: %w", err)
			}
			permissionGrant := grant.NewGrant(resource, groupPermission.Permission, gr.Id)
			rv = append(rv, permissionGrant)
			otherPermissions := getImpliedPermissions(groupPermission.Permission)
			for _, permission := range otherPermissions {
				permissionGrant := grant.NewGrant(resource, permission, gr.Id)
				rv = append(rv, permissionGrant)
			}
		}
	default:
		return nil, "", nil, fmt.Errorf("bitbucket(dc) connector: invalid grant resource type for bitbucket org: %s", bag.ResourceTypeID())
	}

	nextPageToken, err := bag.Marshal()
	if err != nil {
		return nil, "", nil, err
	}

	return rv, nextPageToken, nil, nil
}

func (o *orgBuilder) Grant(ctx context.Context, principal *v2.Resource, entitlement *v2.Entitlement) (annotations.Annotations, error) {
	l := ctxzap.Extract(ctx)
	if principal.Id.ResourceType != resourceTypeUser.Id &&
		principal.Id.ResourceType != resourceTypeGroup.Id {
		l.Error(
			"bitbucket(dc)-connector: only users and groups can be granted global permissions",
			zap.String("principal_type", principal.Id.ResourceType),
			zap.String("principal_id", principal.Id.Resource),
		)
		return nil, fmt.Errorf("bitbucket(dc)-connector: only users and groups can be granted global permissions")
	}

	// There is always only one org resource
	_, permission, err := ParseEntitlementID(entitlement.Id)
	if err != nil {
		return nil, err
	}

	idx := slices.IndexFunc(globalPermissions, func(c string) bool {
		return c == permission
	})
	if idx == -1 {
		return nil, fmt.Errorf("bitbucket(dc) connector: invalid permission: %s", permission)
	}

	switch principal.Id.ResourceType {
	case resourceTypeUser.Id:
		userName := principal.DisplayName
		userId, err := strconv.Atoi(principal.Id.Resource)
		if err != nil {
			return nil, err
		}

		globalUserPermissions, err := listGlobalUserPermissions(ctx, o.client)
		if err != nil {
			return nil, err
		}
		idx := slices.IndexFunc(globalUserPermissions, func(c client.UsersPermissions) bool {
			return c.User.ID == userId
		})
		if idx > -1 {
			userPermission := globalUserPermissions[idx]
			if isLowerPermission(permission, userPermission.Permission) {
				return annotations.New(&v2.GrantAlreadyExists{}), nil
			}
		}

		err = o.client.UpdateUserGlobalPermission(ctx, userName, permission)
		if err != nil {
			return nil, err
		}

		l.Info("User global permission granted.",
			zap.Int64("UserID", int64(userId)),
			zap.String("User", userName),
			zap.String("Permission", permission),
		)
	case resourceTypeGroup.Id:
		groupName := principal.Id.Resource
		globalGroupPermissions, err := listGlobalGroupPermissions(ctx, o.client)
		if err != nil {
			return nil, err
		}
		idx := slices.IndexFunc(globalGroupPermissions, func(c client.GroupsPermissions) bool {
			return c.Group.Name == groupName
		})
		if idx > -1 {
			groupPermission := globalGroupPermissions[idx]
			if isLowerPermission(permission, groupPermission.Permission) {
				return annotations.New(&v2.GrantAlreadyExists{}), nil
			}
		}

		err = o.client.UpdateGroupGlobalPermission(ctx, groupName, permission)
		if err != nil {
			return nil, err
		}

		l.Info("Group global permission granted.",
			zap.String("Group", groupName),
			zap.String("Permission", permission),
		)
	default:
		return nil, fmt.Errorf("bitbucket(dc)-connector: invalid grant resource type: %s", principal.Id.ResourceType)
	}

	return nil, nil
}

func (o *orgBuilder) Revoke(ctx context.Context, grant *v2.Grant) (annotations.Annotations, error) {
	var permission string
	l := ctxzap.Extract(ctx)
	principal := grant.Principal
	entitlement := grant.Entitlement
	if principal.Id.ResourceType != resourceTypeUser.Id &&
		principal.Id.ResourceType != resourceTypeGroup.Id {
		l.Error(
			"bitbucket(dc)-connector: only users and groups can have global permissions revoked",
			zap.String("principal_id", principal.Id.String()),
			zap.String("principal_type", principal.Id.ResourceType),
		)
		return nil, fmt.Errorf("bitbucket(dc)-connector: only users and groups can have global permissions revoked")
	}

	// There is always only one org resource
	_, permission, err := ParseEntitlementID(entitlement.Id)
	if err != nil {
		return nil, err
	}

	idx := slices.IndexFunc(globalPermissions, func(c string) bool {
		return c == permission
	})
	if idx == -1 {
		return nil, fmt.Errorf("bitbucket(dc) connector: invalid permission: %s", permission)
	}

	switch principal.Id.ResourceType {
	case resourceTypeUser.Id:
		userName := principal.DisplayName
		userId, err := strconv.Atoi(principal.Id.Resource)
		if err != nil {
			return nil, err
		}
		globalUserPermissions, err := listGlobalUserPermissions(ctx, o.client)
		if err != nil {
			return nil, err
		}
		idx := slices.IndexFunc(globalUserPermissions, func(c client.UsersPermissions) bool {
			return c.User.ID == userId
		})
		if idx == -1 {
			return annotations.New(&v2.GrantAlreadyRevoked{}), nil
		}

		userPermission := globalUserPermissions[idx]
		if isLowerPermission(userPermission.Permission, permission) {
			return annotations.New(&v2.GrantAlreadyRevoked{}), nil
		}

		newPermission := getLowerPermission(permission)
		if newPermission == "" {
			err = o.client.RevokeUserGlobalPermission(ctx, userName)
		} else {
			err = o.client.UpdateUserGlobalPermission(ctx, userName, newPermission)
		}
		if err != nil {
			return nil, err
		}

		l.Info("User global permission revoked.",
			zap.Int64("UserID", int64(userId)),
			zap.String("User", userName),
			zap.String("Permission", permission),
		)
	case resourceTypeGroup.Id:
		groupName := entitlement.Resource.Id.Resource

		globalGroupPermissions, err := listGlobalGroupPermissions(ctx, o.client)
		if err != nil {
			return nil, err
		}
		idx := slices.IndexFunc(globalGroupPermissions, func(c client.GroupsPermissions) bool {
			return c.Group.Name == groupName
		})
		if idx == -1 {
			return annotations.New(&v2.GrantAlreadyRevoked{}), nil
		}

		groupPermission := globalGroupPermissions[idx]
		if isLowerPermission(groupPermission.Permission, permission) {
			return annotations.New(&v2.GrantAlreadyRevoked{}), nil
		}

		newPermission := getLowerPermission(permission)
		if newPermission == "" {
			err = o.client.RevokeGroupGlobalPermission(ctx, groupName)
		} else {
			err = o.client.UpdateGroupGlobalPermission(ctx, groupName, newPermission)
		}
		if err != nil {
			return nil, err
		}

		l.Info("Group global permission revoked.",
			zap.String("GroupName", groupName),
			zap.String("Permission", permission),
		)
	default:
		return nil, fmt.Errorf("bitbucket(dc) connector: invalid grant resource type: %s", principal.Id.ResourceType)
	}

	return nil, nil
}

func newOrgBuilder(c *client.DataCenterClient) *orgBuilder {
	return &orgBuilder{
		resourceType: resourceTypeOrg,
		client:       c,
	}
}
