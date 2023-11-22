output "policy_management_token" {
  sensitive = true
  value     = vault_token.policy_management.client_token
}

