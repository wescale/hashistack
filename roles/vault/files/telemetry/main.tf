locals {
  policy_name           = "telemetry"
  policy_file_telemetry = "${path.module}/policies/telemetry.hcl"
}

resource "vault_policy" "telemetry" {
  name = local.policy_name
  policy = file(local.policy_file_telemetry)
}

resource "vault_token" "telemetry" {
  policies        = [vault_policy.telemetry.name]
  no_parent       = true
}

