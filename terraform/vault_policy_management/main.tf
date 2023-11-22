locals {
  policy_management_policy_name = "${terraform.workspace}_policy_management_policy"

  policy_management_token_ttl             = var.policy_management_token_ttl
  policy_management_token_renewable       = var.policy_management_token_renewable
  policy_management_token_renew_min_lease = var.policy_management_token_renew_min_lease
  policy_management_token_renew_increment = var.policy_management_token_renew_increment
}

resource "vault_policy" "policy_management" {
  name = local.policy_management_policy_name

  policy = templatefile("${path.module}/policies/policy_management.tpl", {})
}

resource "vault_token" "policy_management" {
  metadata = {
    "purpose" = "Policy management"
  }

  policies = [
    vault_policy.policy_management.name
  ]

  renewable = local.policy_management_token_renewable
  ttl       = local.policy_management_token_ttl

  renew_min_lease = local.policy_management_token_renew_min_lease
  renew_increment = local.policy_management_token_renew_increment
}

