locals {
  auth_backend_path = var.auth_backend_path
  server_url = var.server_url
  user_dn = var.user_dn
  user_attr = var.user_attr
  user_principal_domain = var.user_principal_domain
  discover_dn = var.discover_dn
  group_dn = var.group_dn
  group_filter = var.group_filter
}

resource "vault_ldap_auth_backend" "ldap" {
    path        = locals.auth_backend_path
    url         = local.server_url
    userdn      = locals.user_dn
    userattr    = locals.user_attr
    upndomain   = locals.user_principal_domain
    discoverdn  = locals.discover_dn
    groupdn     = locals.group_dn
    groupfilter = locals.group_filter
}

