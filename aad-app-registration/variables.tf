variable "app_name" {
    type = string
    description = "Name of the application."
}
variable "environment" {
    type = string
    description = "Environment in which the application exists."
}
variable "mapped_claims_enabled" {
    type = string
    description = "Boolean value defining whether mapped claims are enabled."
    default = "false"
}
variable "requested_access_token_version" {
    type = number
    description = "Version number for requested access tokens"
    default = 1
}
variable "known_client_applications" {
    type = list(string)
    description = "String list of known client applications."
    default = []
}
variable "apis" {
    type = map(object({
        admin_consent_display_name = string
        admin_consent_description = string
        enabled = string
        type = string
        value = string
    }))
    description = "Custom API definitions."
    default = {}
}

variable "app_roles" {
    type = map(object({
        allowed_member_types = list(string)
        description = string
        value = string
    }))
    description = "Custom app role definitions."
    default = {}
}

variable required_resource_access {
  type = list(object({
    resource_app_id = string
    resource_access = list(object({
      id   = string
      type = string
    }))
  }))
  description = "Custom required resource access"
  default = []
}

variable "single_page_application_uris" {
    type = list(string)
    description = "String list defining additional URIs for Single Page Applications."
    default = []
}
variable "web_redirect_uris" {
    type = list(string)
    description = "String list defining additional Web redirect URIs."
    default = []
}
variable "access_token_issuance_enabled" {
    type = string
    description = "Boolean value defining whether access token issuance is enabled. Defaults to false."
    default = "false"
}
variable "id_token_issuance_enabled" {
    type = string
    description = "Boolean value defining whether id token issuance is enabled. Defaults to false. "
    default = "false"
}