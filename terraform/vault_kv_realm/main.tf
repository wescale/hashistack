/**
 * # vault_kv_realm
 *
 * ([Module sources](https://github.com/wescale/hashistack/tree/main/terraform/vault_kv_realm))
 *
 * ```{admonition} Purpose
 * :class: important
 *
 * This module is provided as guiding sample for implementing your own delegation.
 * It creates 2 policies with associated tokens tied to a kv-v2 mount point:
 *
 * * an `administrator` one, with read-write access to all subpaths beginning with the ``realm_name`` variable
 * * a `user` one, with read-only access to the same perimeter.
 * ```
 *
 * ## Authentication
 *
 * Provide your cluster address and token as environment variables.
 *
 * ```{code-block}
 * export VAULT_ADDR="..."
 * export VAULT_TOKEN="..."
 * ```
 *
 */
locals {
  realm_name        = var.realm_name
  kv_v2_mount_point = var.kv_v2_mount_point

  realm_admin_token_ttl             = var.admin_token_ttl
  realm_admin_token_renewable       = var.admin_token_renewable
  realm_admin_token_renew_min_lease = var.admin_token_renew_min_lease
  realm_admin_token_renew_increment = var.admin_token_renew_increment

  realm_user_token_ttl             = var.user_token_ttl
  realm_user_token_renewable       = var.user_token_renewable
  realm_user_token_renew_min_lease = var.user_token_renew_min_lease
  realm_user_token_renew_increment = var.user_token_renew_increment

  realm_admin_policy_name = "${local.realm_name}_admin_policy"
  realm_user_policy_name  = "${local.realm_name}_user_policy"
}

resource "vault_policy" "realm_admin" {
  name = local.realm_admin_policy_name

  policy = templatefile("${path.module}/policies/realm_admin.tpl",
    {
      realm_name        = local.realm_name,
      kv_v2_mount_point = local.kv_v2_mount_point
    }
  )
}

resource "vault_token" "realm_admin" {

  policies = [
    local.realm_admin_policy_name
  ]

  no_parent = true
  ttl       = local.realm_admin_token_ttl
  renewable = local.realm_admin_token_renewable

  renew_min_lease = local.realm_admin_token_renew_min_lease
  renew_increment = local.realm_admin_token_renew_increment

  metadata = {
    "purpose" = "real_kv admin"
  }
}

resource "vault_policy" "realm_user" {
  name = local.realm_user_policy_name

  policy = templatefile("${path.module}/policies/realm_user.tpl",
    {
      realm_name        = local.realm_name,
      kv_v2_mount_point = local.kv_v2_mount_point
    }
  )
}

resource "vault_token" "realm_user" {

  policies = [
    local.realm_user_policy_name
  ]

  no_parent = true
  ttl       = local.realm_user_token_ttl
  renewable = local.realm_user_token_renewable

  renew_min_lease = local.realm_user_token_renew_min_lease
  renew_increment = local.realm_user_token_renew_increment

  metadata = {
    "purpose" = "realm_kv user"
  }
}

