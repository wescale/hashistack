output "token" {
  sensitive = true
  value     = vault_token.pt.client_token
}

