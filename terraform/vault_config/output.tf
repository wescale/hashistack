output "consul_connect_client_token" {
  sensitive = true
  value     = vault_token.connect_ca.client_token
}

output "root_certificate" {
  sensitive = true
  value = vault_pki_secret_backend_root_cert.pki_root_cert.certificate
}

output "root_pki_path" {
  value = vault_mount.pki_root.path
}

output "inter_pki_path" {
  value = vault_mount.pki_inter.path
}
