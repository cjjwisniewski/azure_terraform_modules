output "security_group_display_name" {
  value = azuread_group.this.display_name
}
output "security_group_object_id" {
  value = azuread_group.this.object_id
}