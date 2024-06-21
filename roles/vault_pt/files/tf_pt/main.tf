locals {
  fullname    = "${terraform.workspace}_pt_${var.pt_name}"
  policy_path = coalesce(var.pt_policy_path, "${path.module}/admin_policy.hcl")
}

resource "vault_policy" "pt" {
  name   = local.fullname
  policy = file(local.policy_path)
}

resource "vault_token" "pt" {
  policies = [
    vault_policy.pt.name
  ]
  renewable = true
  no_parent = true
  period    = "15d"
}

resource "vault_token_auth_backend_role" "pt" {
  role_name = local.fullname
  allowed_policies_glob = [
    vault_policy.pt.name
  ]
  orphan                 = true
  token_period           = 60 * 60
  renewable              = true
  token_explicit_max_ttl = 0
}
