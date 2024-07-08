locals {
  policy_name          = "snapshot"
  policy_file_snapshot = "${path.module}/policies/snapshot.hcl"
}

resource "vault_policy" "snapshot" {
  name   = local.policy_name
  policy = file(local.policy_file_snapshot)
}

resource "vault_token" "snapshot" {
  policies  = [vault_policy.snapshot.name]
  no_parent = true
}

