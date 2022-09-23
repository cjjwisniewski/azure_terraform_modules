output "display_name" {
  value = azuread_application.this.display_name
}
output "application_id" {
  value = azuread_application.this.application_id
}
output "client_secret" {
  value = azuread_application_password.this_pswd.value
}
output "object_id" {
  value = azuread_application.this.object_id
}
output "spn_object_id" {
  value = azuread_service_principal.this_spn.object_id
}