output "telemetry_token" {
  sensitive = true
  value     = vault_token.telemetry.client_token
}


