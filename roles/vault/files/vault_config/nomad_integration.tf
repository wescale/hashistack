locals {
  nomad_allowed_vault_policies = var.nomad_allowed_vault_policies
}

resource "vault_policy" "nomad_server" {
  name   = "nomad_server"
  policy = file("${path.module}/policies/nomad_server.hcl")
}

resource "vault_token" "nomad_server" {
  policies        = [vault_policy.nomad_server.name]
  renewable       = true
  ttl             = "1h"
  no_parent       = true
  renew_min_lease = 60 * 45
  renew_increment = 60 * 60
}

resource "vault_token_auth_backend_role" "nomad_cluster" {
  role_name              = "nomad_cluster"
  allowed_policies       = local.nomad_allowed_vault_policies
  orphan                 = true
  token_period           = 60 * 60
  renewable              = true
  token_explicit_max_ttl = 0
}

