variable "security_group_name" {
    type = string
    description = "Name of the security group"
}
variable "security_group_owners" {
    type = list(string)
    description = "List of UPNs for owners of this security group"
    default = []
}
variable "security_group_members" {
    type = list(string)
    description = "List of UPNs for members of this security group. Owners are added to this list by default."
    default = []
}