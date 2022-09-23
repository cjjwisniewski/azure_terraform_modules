terraform {
  required_version = ">=1.0"
}

data "azurerm_client_config" "current" {}

data "azuread_users" "owners" {
  user_principal_names = distinct(var.security_group_owners)
}

data "azuread_users" "members" {
  user_principal_names = distinct(concat(var.security_group_owners,var.security_group_members))
}

resource "azuread_group" "this" {
  display_name = var.security_group_name
  security_enabled = true
  owners = distinct(concat(tolist([data.azurerm_client_config.current.object_id]),data.azuread_users.owners.object_ids))
  members = distinct(concat(tolist([data.azurerm_client_config.current.object_id]),data.azuread_users.members.object_ids))
}