output "consul_service_mesh_token" {
  sensitive = true
  value     = vault_token.consul_service_mesh.client_token
}

output "consul_service_mesh_root_ca_certificate" {
  sensitive = true
  value     = vault_pki_secret_backend_root_cert.pki_root_cert.certificate
}

output "root_pki_path" {
  value = vault_mount.pki_root.path
}

output "inter_pki_path" {
  value = vault_mount.pki_inter.path
}
