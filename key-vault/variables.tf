variable "key_vault_name" {
  type = string
  description = "Name of the key vault. Will appear in this format - <key_vault_name>-<environment>-kv"
}

variable "environment" {
  type        = string
  description = "The environment of the application"
}

variable "resource_group_name" {
    type = string
    description = "Name of the resource group"
}

variable "location" {
  type = string
  description = "Region/location where the resource is created"
  default = "eastus2"
}

variable "tenant_id" {
    type = string
    description = "aad tenant id"
}

variable "managers_group_owners" {
    type = list(string)
    description = "List of UPNs for owners of the KV managers security group"
    default = []
}

variable "managers_group_members" {
    type = list(string)
    description = "List of UPNs for members of the KV managers security group. Owners are added to this list by default."
    default = []
}

variable "viewers_group_owners" {
    type = list(string)
    description = "List of UPNs for owners of the KV viewers security group"
    default = []
}

variable "viewers_group_members" {
    type = list(string)
    description = "List of UPNs for members of the KV viewers security group. Owners are added to this list by default."
    default = []
}

variable "tags" {
  type = map(string)
  description = "The tags to associate with your infrastructure"
  default = {}
}
