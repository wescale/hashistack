output "realm_admin_token" {
  sensitive   = true
  value       = vault_token.realm_admin.client_token
  description = "kv-realm administrator token (rw)"
}

output "realm_user_token" {
  sensitive   = true
  value       = vault_token.realm_user.client_token
  description = "kv-realm user token (ro)"
}
