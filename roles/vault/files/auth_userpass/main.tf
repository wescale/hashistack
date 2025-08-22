locals {
    ns = (var.namespace == "" || var.namespace == "root") ? null : var.namespace
}

# VAULT human_auth
resource "vault_auth_backend" "human_auth" {
  type = "userpass"
  path = var.userpass_path
  tune {
    allowed_response_headers     = []
    audit_non_hmac_request_keys  = []
    audit_non_hmac_response_keys = []
    default_lease_ttl            = var.userpass_default_lease_ttl # "7200s"
    listing_visibility           = "hidden"
    max_lease_ttl                = var.userpass_max_lease_ttl # "57600s"
    passthrough_request_headers  = []
  }
}

resource "vault_generic_endpoint" "user" {
  for_each = var.users

  path = "auth/${vault_auth_backend.human_auth.path}/users/${each.key}"
  namespace = local.ns

  ignore_absent_fields = true

  data_json = <<EOT
{
  "policies": ${ jsonencode(each.value.policies) },
  "password": "${ random_password.password.result }"
}
EOT
}

resource "random_password" "password" {
  length           = var.passlength < 16 ? 16 : var.passlength
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

# ACTIVATE OTP FOR OPERATOR
resource "vault_identity_mfa_totp" "human_auth-totp" {
  count = var.mfa ? 1 : 0

  issuer = "vault-${var.userpass_path}"
  qr_size = "400"
  algorithm = var.mfa_algorithm
  digits = var.mfa_digits
  key_size = var.mfa_key_size
  period = var.mfa_period
}

resource "vault_identity_mfa_login_enforcement" "human_auth" {
  count = var.mfa ? 1 : 0

  name = "totp-${var.userpass_path}"
  mfa_method_ids = [
    vault_identity_mfa_totp.human_auth-totp[0].method_id,
  ]
  auth_method_accessors = [vault_auth_backend.human_auth.accessor]
}