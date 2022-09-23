data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "this" {
  name                            = "${substr(var.key_vault_name,0,12)}-${substr(var.environment,0,4)}-kv"
  location                        = var.location
  resource_group_name             = var.resource_group_name
  enabled_for_disk_encryption     = true
  tenant_id                       = var.tenant_id
  purge_protection_enabled        = true
  enabled_for_deployment          = true
  enabled_for_template_deployment = true
  sku_name                        = "standard"

  network_acls {
    default_action = "Allow"
    bypass         = "AzureServices"
  }

  tags = var.tags
}

module "aad_group_viewers" {
  source = "github.com/cjjwisniewski/azure_terraform_modules/tree/main/aad-security-group"
  security_group_name = "${substr(var.key_vault_name,0,12)}-${substr(var.environment,0,4)}-viewers"
  security_group_owners = var.viewers_group_owners
  security_group_members = var.viewers_group_members
}

resource "azurerm_key_vault_access_policy" "viewer_policy" {
  key_vault_id = azurerm_key_vault.this.id
  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = module.aad_group_viewers.security_group_object_id
  certificate_permissions = ["Get","List"]
  key_permissions = ["Get","List"]
  secret_permissions = ["Get","List"]
  storage_permissions = ["Get","List"]
}

module "aad_group_managers" {
  source = "github.com/cjjwisniewski/azure_terraform_modules/tree/main/aad-security-group"
  security_group_name = "${substr(var.key_vault_name,0,12)}-${substr(var.environment,0,4)}-managers"
  security_group_owners = var.managers_group_owners
  security_group_members = var.managers_group_members
}

resource "azurerm_key_vault_access_policy" "manager_policy" {
  key_vault_id = azurerm_key_vault.this.id
  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = module.aad_group_managers.security_group_object_id
  certificate_permissions = ["Backup","Create","Delete","DeleteIssuers","Get","GetIssuers","Import","List","ListIssuers","ManageContacts","ManageIssuers","Purge","Recover","Restore","SetIssuers","Update"]
  key_permissions = ["Backup","Create","Decrypt","Delete","Encrypt","Get","Import","List","Purge","Recover","Restore","Sign","UnwrapKey","Update","Verify","WrapKey"]
  secret_permissions = ["Backup","Delete","Get","List","Purge","Recover","Restore","Set"]
  storage_permissions = ["Backup","Delete","DeleteSAS","Get","GetSAS","List","ListSAS","Purge","Recover","RegenerateKey","Restore","Set","SetSAS","Update"]
}

resource "azurerm_key_vault_access_policy" "current_user_policy" {
  key_vault_id = azurerm_key_vault.this.id
  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = data.azurerm_client_config.current.object_id
  certificate_permissions = ["Backup","Create","Delete","DeleteIssuers","Get","GetIssuers","Import","List","ListIssuers","ManageContacts","ManageIssuers","Purge","Recover","Restore","SetIssuers","Update"]
  key_permissions = ["Backup","Create","Decrypt","Delete","Encrypt","Get","Import","List","Purge","Recover","Restore","Sign","UnwrapKey","Update","Verify","WrapKey"]
  secret_permissions = ["Backup","Delete","Get","List","Purge","Recover","Restore","Set"]
  storage_permissions = ["Backup","Delete","DeleteSAS","Get","GetSAS","List","ListSAS","Purge","Recover","RegenerateKey","Restore","Set","SetSAS","Update"]
}