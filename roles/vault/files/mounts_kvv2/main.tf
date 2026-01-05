locals {
    ns = (var.namespace == "" || var.namespace == "root") ? null : var.namespace
}

resource "vault_mount" "secret" {
  namespace = local.ns

  for_each = {for k,v in var.secret: v.name => v}

  path      = each.key
  description = each.value.conf.description
  type      = "kv"
  options = {
    version = "2"
  }
}

resource "vault_kv_secret_backend_v2" "secret" {
  namespace = local.ns

  for_each = {for k,v in var.secret: v.name => v}

  mount                = each.key
  max_versions         = each.value.conf.config.max_versions
  delete_version_after = each.value.conf.config.delete_version_after

  depends_on = [ vault_mount.secret ]
}
