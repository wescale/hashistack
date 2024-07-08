output "snapshot_token" {
  sensitive = true
  value     = vault_token.snapshot.client_token
}


