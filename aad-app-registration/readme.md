# aad-app-registration
Module for creation of an Azure Active Directory App Registration.

## Example
```
module "aad-app-registration" {
    source = "$module_source"
    app_name = "testapp1"
    environment = "sdbx"
    app_roles = {
        "custom" = {
            allowed_member_types = [ "User" ]
            description = "custom role"
            value = "custom"
        },
        "custom2" = {
            allowed_member_types = [ "Application" ]
            description = "custom role2"
            value = "custom2"
        }
    }
    key_vault_name = "$key_vault_name"
    key_vault_resource_group_name = "$key_vault_resource_group_name"
}
```

## Parameters
### app_name | mandatory | type=string
String defining the name of the application. Will be combined with the environment to output a name conforming to our general naming standards and will also be used to define role names. In the example above, the name of the resulting application would be "testapp1-sdbx" and the view role would be "testapp1-sdbx-view".

### environment | mandatory | type=string
String defining the environment to which the app registration is intended for. This will be used as part of internally generated names and will be restricted to the first 4 characters. Recommended values are prod, uat, dev, test, and similar.

### key_vault_name | mandatory | type=string
String defining the name of the key vault in which the app registration's client secret will be stored. 

### key_vault_resource_group_name | mandatory | type=string
String defining the name of the resource group in which the key vault defined in key_vault_name exists. 

### key_vault_subscription_id | mandatory | type=string
String defining the name of the subscription in which the resource group defined in key_vault_resource_group_name exists. 

### mapped_claims_enabled | optional | type=string
Allows an application to use claims mapping without specifying a custom signing key. Defaults to false.

### requested_access_token_version | optional | type=string
The access token version expected by this resource. Must be one of 1 or 2, and must be 2 when sign_in_audience is either AzureADandPersonalMicrosoftAccount or PersonalMicrosoftAccount Defaults to 1.

### known_client_applications | optional | type=list(string)
A set of application IDs (client IDs), used for bundling consent if you have a solution that contains two parts: a client app and a custom web API app.

### apis | optional | type=map(object)
Custom APIs are defined by an object map following this criteria:
```
type = map(object({
        admin_consent_display_name = string
        admin_consent_description = string
        enabled = string
        type = string
        value = string
    }))
```
- `admin_consent_display_name` Delegated permission description that appears in all tenant-wide admin consent experiences, intended to be read by an administrator granting the permission on behalf of all users.
- `admin_consent_description` Display name for the delegated permission, intended to be read by an administrator granting the permission on behalf of all users.
- `enabled` Determines if the permission scope is enabled.
- `type` Whether this delegated permission should be considered safe for non-admin users to consent to on behalf of themselves, or whether an administrator should be required for consent to the permissions. Possible values are User or Admin.
- `value` The value that is used for the scp claim in OAuth 2.0 access tokens.

### app_roles | optional | type=map(object)
Custom app roles are defined by an object map following this criteria:
```
type = map(object({
    allowed_member_types = list(string)
    description = string
    value = string
}))
```
- `allowed_member_types` Specifies whether this app role definition can be assigned to users and groups by setting to User, or to other applications (that are accessing this application in a standalone scenario) by setting to Application, or to both.
- `description` Description of the app role that appears when the role is being assigned and, if the role functions as an application permissions, during the consent experiences.
- `value` The value that is used for the roles claim in ID tokens and OAuth 2.0 access tokens that are authenticating an assigned service or user principal.

### required_resource_access | optional | type=list(object)
Custom required resource access is defined by a list of objects following this criteria.
```
type = list(object({
    resource_app_id = string
    resource_access = list(object({
      id   = string
      type = string
    }))
}))
```
- `resource_app_id` The app ID of the resource to grant this app registration access to.
- `id` The ID of the resource to grant this app registration access to.
- `type` The type of access to be granted to the resource. Generally "Role".

### single_page_application_uris | optional | type=list(string)
A set of URLs where user tokens are sent for sign-in, or the redirect URIs where OAuth 2.0 authorization codes and access tokens are sent. Must be a valid https URL.

### web_redirect_uris | optional | type=list(string)
A set of URLs where user tokens are sent for sign-in, or the redirect URIs where OAuth 2.0 authorization codes and access tokens are sent. Must be a valid http URL or a URN.

### access_token_issuance_enabled | optional | type=string
Whether this web application can request an access token using OAuth 2.0 implicit flow.

### id_token_issuance_enabled | optional | type=string
Whether this web application can request an ID token using OAuth 2.0 implicit flow.