output "nomad_vault_token" {
  sensitive = true
  value     = vault_token.nomad_server.client_token
}

