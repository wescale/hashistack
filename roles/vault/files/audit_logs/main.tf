locals {
    ns = (var.namespace == "" || var.namespace == "root") ? null : var.namespace
}

resource "vault_audit" "auditlog" {
  type = var.auditlog.type
  namespace = local.ns

  options = var.auditlog.options
}
