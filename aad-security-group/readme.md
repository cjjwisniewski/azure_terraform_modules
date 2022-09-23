# aad-security-group
Module for creation of an Azure Active Directory security group. This is primarily intended for use within other modules to ensure proper group name specification.

## Example
```
module "aad-security-group-viewers" {
  source = "$module_source"
  security_group_name = "${var.project_name}-${var.environment}-viewers"
  security_group_owners = var.viewers_group_owners
  security_group_members = var.viewers_group_members
}
```

## Parameters
### security_group_name | mandatory | type=string
String defining the name of the security group. Generally defined from other variables in the project to ensure group name conformity. In the example above, this is defined by the name of the project and the environment. For a key vault viewer group definition in prod, this name may be something similar to "testproject-prod-viewers". Maximum of 63 characters in length. 

### security_group_owners | optional | type=list(string)
String list defining a list of owners of the security group. This should contain a list of email addresses of users intended to belong to this category. Use of this parameter in code is not recommended except when necessary as it may become cumbersome to manage lists of individual email addresses. Will always contain the account executing the code. 

### security_group_members | optional | type=list(string)
String list defining a list of members of the security group. This should contain a list of email addresses of users intended to belong to this category. Use of this parameter in code is not recommended except when necessary as it may become cumbersome to manage lists of individual email addresses. Will always contain the account executing the code. 
