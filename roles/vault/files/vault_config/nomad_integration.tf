resource "vault_mount" "kv" {
  path = "kv-v2"
  type = "kv-v2"
}

resource "vault_policy" "nomad_server" {
  name   = "nomad_server"
  policy = file("${path.module}/policies/nomad_server.hcl")
}

resource "vault_policy" "nomad_registry" {
  name   = "nomad_job_registry_credentials"
  policy = file("${path.module}/policies/nomad_job_registry_credentials.hcl")
}

resource "vault_token" "nomad_server" {
  policies        = [
    vault_policy.nomad_server.name
  ]
  renewable       = true
  explicit_max_ttl = 0
  no_parent       = true
  renew_min_lease = 60 * 45
  renew_increment = 60 * 60
}

resource "vault_token_auth_backend_role" "nomad_cluster" {
  role_name              = "nomad_cluster"
  allowed_policies_glob  = [
    "nomad_job_*"
  ]
  orphan                 = true
  token_period           = 60 * 60
  renewable              = true
  token_explicit_max_ttl = 0
}

