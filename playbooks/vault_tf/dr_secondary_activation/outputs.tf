output "batch_token_auth_name" {
  sensitive = false
  value     = vault_token_auth_backend_role.failover_handler.role_name
}


