# key-vault
Module for the creation of a key vault resource and Azure Active Directory security groups for predefined manager and viewer access. Group membership definitions are optional for this module as these should generally not be managed in code. 

## Example:
```
module "key_vault" {
    source = "$module_source"
    key_vault_name = var.key_vault_name
    resource_group_name = module.resource_group.resource_group_name
    tenant_id = data.azurerm_client_config.current.tenant_id
    environment = var.environment
    tags = var.tags
}
```

## Parameters
### key_vault_name | mandatory | type=string
String defining the name of the key vault resource. This should generally be the same as the name of the project and will be limited to the first 12 characters of this value. The module will use this value alongside the value for environment to create a KV name in the following example pattern, where the provided value is "testproject":
`testproject-prod-kv`

### resource_group_name | mandatory | type=string
String defining the name of the resource group in which the key vault will reside. It is best practice to define this using the output of the resource group module used to create the project's RG.

### tenant_id | mandatory | type=string
String defining the tenant ID to which the key vault will be deployed. It is best practice to define this using the value of the tenant_id assigned to the account executing the code. 

### environment | mandatory | type=string
String defining the environment to which the key vault module is intended for. This will be used as part of the KV name and will be restricted to the first 4 characters. Recommended values are prod, uat, dev, test, and similar. 

### tags | optional | type=map(string)
String map defining the tags to be assigned to the resource. If not specified, the key vault will inherit the tags assigned to the resource group. It is recommended to assign tags to the resource to clean up terraform plan output. These should be defined through the tags module. 

### managers_group_owners | optional | type=list(string)
String list defining a list of owners of the KV managers security group. This should contain a list of email addresses of users intended to belong to this category. Use of this parameter in code is not recommended except when necessary as it may become cumbersome to manage lists of individual email addresses. Will always contain the account executing the code. 

### managers_group_members | optional | type=list(string)
String list defining a list of members of the KV managers security group. This should contain a list of email addresses of users intended to belong to this category. Use of this parameter in code is not recommended except when necessary as it may become cumbersome to manage lists of individual email addresses. Will always contain the account executing the code. 

### viewers_group_owners | optional | type=list(string)
String list defining a list of owners of the KV viewers security group. This should contain a list of email addresses of users intended to belong to this category. Use of this parameter in code is not recommended except when necessary as it may become cumbersome to manage lists of individual email addresses. Will always contain the account executing the code. 

### viewers_group_members | optional | type=list(string)
String list defining a list of members of the KV viewers security group. This should contain a list of email addresses of users intended to belong to this category. Use of this parameter in code is not recommended except when necessary as it may become cumbersome to manage lists of individual email addresses. Will always contain the account executing the code. 

