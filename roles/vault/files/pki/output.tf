output "pki_path" {
  sensitive = true
  value     = local.intermediate_pki_path
}

output "pki_token" {
  sensitive = true
  value     = vault_token.pki.client_token
}

output "pki_role" {
  sensitive = true
  value     = local.pki_role_name
}

output "pki_root_ca_cert" {
  sensitive = true
  value     = vault_pki_secret_backend_root_cert.pki_root_cert.certificate
}

output "pki_intermediate_path" {
  value = vault_mount.pki_inter.path
}
