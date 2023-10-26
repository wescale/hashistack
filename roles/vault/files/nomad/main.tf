resource "vault_mount" "kv" {
  path = "kv-v2"
  type = "kv-v2"
}

resource "vault_policy" "nomad_server" {
  name   = "nomad_server"
  policy = file("${path.module}/policies/masters.hcl")
}

resource "vault_policy" "nomad_registry" {
  name   = "nomad_job_registry_credentials"
  policy = file("${path.module}/policies/jobs_kv_read.hcl")
}

resource "vault_token" "nomad_server" {
  policies        = [
    vault_policy.nomad_server.name
  ]
  renewable       = true
  no_parent       = true
  period          = "15d"
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
