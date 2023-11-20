data "vault_policy_document" "zone" {
  rule {
    path         = "${var.mount_point}/data/${var.zone}/*"
    capabilities = ["read"]
    description  = "allow all on secret ${var.zone} path"
  }
  rule {
    path         = "${var.mount_point}/metadata/${var.zone}"
    capabilities = ["read", "list"]
    description  = "webui list secret ${var.zone} path "
  }
  rule {
    path         = "${var.mount_point}/metadata/${var.zone}/*"
    capabilities = ["read", "list"]
    description  = "webui list secret ${var.zone} path "
  }
  rule {
  # Allow tokens to look up their own properties
    path = "auth/token/lookup-self" 
    capabilities = ["read"]
  }
  rule {
  # Allow tokens to renew themselves
    path = "auth/token/renew-self"
    capabilities = ["update"]
  }
  rule {
  # Allow tokens to revoke themselves
    path = "auth/token/revoke-self"
    capabilities = ["update"]
  }
}

data "vault_policy_document" "admin_token" {
  rule {
    path         = "${var.mount_point}/data/${var.zone}/*"
    capabilities = ["create", "update", "patch", "read", "delete"]
    description  = "allow all on secret ${var.zone} path"
  }
  rule {
    path         = "${var.mount_point}/metadata/${var.zone}/*"
    capabilities = ["read", "list"]
    description  = "webui list secret ${var.zone} path "
  }
  rule {
    path         = "${var.mount_point}/metadata/${var.zone}"
    capabilities = ["read", "list"]
    description  = "webui list secret ${var.zone} path "
  }
  rule {
    path         = "auth/token/create"
    capabilities = ["create", "read", "update", "list"]
  }
  rule {
  # Allow tokens to look up their own properties
    path = "auth/token/lookup-self" 
    capabilities = ["read"]
  }
  rule {
  # Allow tokens to renew themselves
    path = "auth/token/renew-self"
    capabilities = ["update"]
  }
  rule {
  # Allow tokens to revoke themselves
    path = "auth/token/revoke-self"
    capabilities = ["update"]
  }
}

resource "vault_policy" "admin_token" {
  name   = "${var.zone}_admin_token"
  policy = data.vault_policy_document.admin_token.hcl
}

resource "vault_token" "admin_token" {

  policies = ["${var.zone}_admin_token"]

  renewable = try(var.token.renewable, true)
  ttl       = try(var.token.ttl, "24h")

  ## Orphan token

  ## test renew

  renew_min_lease = try(var.token.renew_min_lease, 43200)
  renew_increment = try(var.token.renew_increment, 86400)

  metadata = {
    "purpose" = "zone-manager-admin_token"
  }
}

resource "vault_policy" "policies" {
  name   = "${var.zone}_policies"
  policy = data.vault_policy_document.zone.hcl
}

resource "vault_token" "policies" {

  policies = ["${var.zone}_policies"]

  renewable = try(var.token.renewable, true)
  ttl       = try(var.token.ttl, "24h")

  renew_min_lease = try(var.token.renew_min_lease, 43200)
  renew_increment = try(var.token.renew_increment, 86400)

  metadata = {
    "purpose" = "zone-manager"
  }
}