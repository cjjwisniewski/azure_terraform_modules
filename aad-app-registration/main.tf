terraform {
  required_version = ">=1.0"
}

data "azurerm_client_config" "current" {}

#Define default API settings
resource "random_uuid" "user_impersonation_uuid" {}

locals {
  default_apis = {
    "user_impersonation" = {
      admin_consent_description = "Access API as User"
      admin_consent_display_name = "Access API as User"
      enabled = "true"
      id = random_uuid.user_impersonation_uuid.result
      type = "Admin"
      value = "user_impersonation"
    }
  }
}

#Construct defintions for defined API settings
resource "random_uuid" "defined_api_uuids" {
  for_each = var.apis
}

locals {
  defined_apis = {for setting, properties in var.apis :
    setting => {
      admin_consent_display_name = properties.admin_consent_display_name
      admin_consent_description = properties.admin_consent_description
      enabled = properties.enabled
      id = random_uuid.defined_api_uuids[setting].result
      type = properties.type
      value = properties.value
    } 
  }
}

#merge default and defined API settings
locals {
  total_apis = merge(local.defined_apis,local.default_apis)
}

#Define default app roles
resource "random_uuid" "view_role_uuid" {}
resource "random_uuid" "edit_role_uuid" {}

locals {
  default_app_roles = {
    "view" = {
      allowed_member_types = ["User", "Application"]
      description = "${var.app_name}-${substr(var.environment,0,4)} default view role"
      display_name = "${var.app_name}-${substr(var.environment,0,4)}-view"
      enabled = "true"
      id = random_uuid.view_role_uuid.result
      value = "view"
    },
    "edit" = {
      allowed_member_types = ["User", "Application"]
      description = "${var.app_name}-${substr(var.environment,0,4)} default edit role"
      display_name =  "${var.app_name}-${substr(var.environment,0,4)}-edit"
      enabled = "true"
      id = random_uuid.edit_role_uuid.result
      value = "edit"
    }
  }
}

#Construct definitions for defined app roles
resource "random_uuid" "defined_role_uuids" {
  for_each = var.app_roles
}

locals {
  defined_app_roles = {for role, properties in var.app_roles : 
    role => {
      allowed_member_types = properties.allowed_member_types
      description = properties.description
      display_name = "${var.app_name}-${substr(var.environment,0,4)}-${properties.value}"
      enabled = "true"
      id = random_uuid.defined_role_uuids[role].result
      value = properties.value
    }
  }
}

#Merge default app roles and defined app roles
locals {
  total_app_roles = merge(local.defined_app_roles,local.default_app_roles)
}

#Define default required resource access
locals {
  default_required_resource_access = [{
    resource_app_id = "00000003-0000-0000-c000-000000000000" #MS Graph API
    resource_access = [{
      id = "df021288-bdef-4463-88db-98f22de89214" #User.Read.All
      type = "Role"
    }]
  }]
  total_required_resource_access = flatten(concat(local.default_required_resource_access,var.required_resource_access))
}

#Define web authentication point URIs
locals {
  default_web_redirect_uris = [
  
  ]
}

#Define single page application URIs
locals {
  default_single_page_application_uris = [

  ]
}

#Create app registration
resource "azuread_application" "this" {
  display_name                   = "${var.app_name}-${substr(var.environment,0,4)}"
  sign_in_audience               = "AzureADMyOrg"
  fallback_public_client_enabled = true
  owners                         = [data.azurerm_client_config.current.object_id]
  identifier_uris = ["api://${var.app_name}-${substr(var.environment,0,4)}"]

  public_client {
    redirect_uris = ["https://login.microsoftonline.com/common/oauth2/nativeclient"]
  }

  api {
    mapped_claims_enabled = var.mapped_claims_enabled
    requested_access_token_version = var.requested_access_token_version
    known_client_applications = var.known_client_applications

    dynamic oauth2_permission_scope {
      for_each = local.total_apis
      content {
        admin_consent_display_name = oauth2_permission_scope.value.admin_consent_display_name
        admin_consent_description = oauth2_permission_scope.value.admin_consent_description
        enabled = oauth2_permission_scope.value.enabled
        id = oauth2_permission_scope.value.id
        type = oauth2_permission_scope.value.type
        value = oauth2_permission_scope.value.value
      }
    } 
  }
  

  dynamic app_role {
    for_each = local.total_app_roles
    content {
      allowed_member_types = app_role.value.allowed_member_types
      description = app_role.value.description
      display_name = app_role.value.display_name
      enabled = app_role.value.enabled
      id = app_role.value.id
      value = app_role.value.value
    }
  }

  dynamic required_resource_access {
    for_each = local.total_required_resource_access
    content {
      resource_app_id = required_resource_access.value["resource_app_id"]
      dynamic resource_access {
        for_each = required_resource_access.value["resource_access"]
        content {
          id = resource_access.value["id"]
          type = resource_access.value["type"]
        }
      }
    }
  }
  
  single_page_application {
    redirect_uris = distinct(concat(local.default_single_page_application_uris,var.single_page_application_uris))
  }

  web {
    redirect_uris = distinct(concat(local.default_web_redirect_uris,var.web_redirect_uris))
    implicit_grant {
      access_token_issuance_enabled = var.access_token_issuance_enabled
      id_token_issuance_enabled = var.id_token_issuance_enabled
    }
  }
}

#Create service principal for app registration
resource "azuread_service_principal" "this_spn" {
  application_id               = azuread_application.this.application_id
  app_role_assignment_required = false
  owners                       = [data.azurerm_client_config.current.object_id]
  feature_tags {
    hide = true
  }
}

#Create client secret
resource "azuread_application_password" "this_pswd" {
  application_object_id = azuread_application.this.id
  end_date              = "2099-12-30T01:01:01Z"
}