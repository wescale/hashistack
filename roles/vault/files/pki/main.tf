locals {
  root_pki_path         = "pki/${var.name}/root"
  intermediate_pki_path = "pki/${var.name}/inter"
  pki_role_name         = "pki_${var.name}_role"
  cn_root               = "${terraform.workspace}/${var.name} Root CA"
  cn_intermediate       = "${terraform.workspace}/${var.name} Intermediate CA"
  allowed_domain        = var.allowed_domain

  pki_root_issuing_server         = var.root_pki_issuing_server
  pki_root_crl_distribution_point = var.root_pki_crl_distribution_point

  pki_inter_issuing_server         = var.intermediate_pki_issuing_server
  pki_inter_crl_distribution_point = var.intermediate_pki_crl_distribution_point
  token_name                       = "${terraform.workspace}_pki_${var.name}"
  token_ttl                        = "15d"
  token_renew_min_lease            = 7 * 24 * 60 * 60
  token_renew_increment            = 15 * 24 * 60 * 60
}

resource "vault_policy" "pki" {
  name = local.token_name

  policy = templatefile("${path.module}/policies/pki.tpl",
    {
      root_pki_path         = local.root_pki_path,
      intermediate_pki_path = local.intermediate_pki_path
    }
  )
}

resource "vault_token" "pki" {
  no_parent = true
  renewable = true

  policies = [
    vault_policy.pki.name
  ]

  ttl             = local.token_ttl
  renew_min_lease = local.token_renew_min_lease
  renew_increment = local.token_renew_increment
}

resource "vault_pki_secret_backend_role" "role" {
  backend            = vault_mount.pki_inter.path
  name               = local.pki_role_name
  ttl                = 60 * 60 * 24
  allow_ip_sans      = true
  key_type           = "rsa"
  key_bits           = 4096
  allowed_domains    = [local.allowed_domain]
  allow_subdomains   = true
  allow_glob_domains = true
}

# =======
# Root CA
# =======
resource "vault_mount" "pki_root" {
  path = local.root_pki_path
  type = "pki"

  # 1 day
  default_lease_ttl_seconds = 60 * 60 * 24

  # 10 years
  max_lease_ttl_seconds = 60 * 60 * 24 * 365 * 10
}

resource "vault_pki_secret_backend_config_urls" "pki_root_config_urls" {
  backend = vault_mount.pki_root.path
  issuing_certificates = [
    "${local.pki_root_issuing_server}/v1/${vault_mount.pki_root.path}/ca"
  ]
  crl_distribution_points = [
    "${local.pki_inter_crl_distribution_point}/v1/${vault_mount.pki_root.path}/crl"
  ]
}

# ===============
# Intermediary CA
# ===============
resource "vault_mount" "pki_inter" {
  path = local.intermediate_pki_path
  type = "pki"

  # 1 day
  #  default_lease_ttl_seconds = 60 * 60 * 24
  default_lease_ttl_seconds = 60

  # 1 year
  max_lease_ttl_seconds = 60 * 60 * 24 * 365
}

resource "vault_pki_secret_backend_config_urls" "pki_inter_config_urls" {
  backend = vault_mount.pki_inter.path
  issuing_certificates = [
    "${local.pki_inter_issuing_server}/v1/${vault_mount.pki_inter.path}/ca"
  ]
  crl_distribution_points = [
    "${local.pki_inter_crl_distribution_point}/v1/${vault_mount.pki_inter.path}/crl"
  ]
}

# ================
# Generate Root CA
# ================
resource "vault_pki_secret_backend_root_cert" "pki_root_cert" {
  depends_on = [vault_mount.pki_root]

  backend = vault_mount.pki_root.path

  type        = "internal"
  common_name = local.cn_root
  ttl         = 60 * 60 * 24 * 365 * 10
}


# ==================
# Generate Inter CSR
# ==================
resource "vault_pki_secret_backend_intermediate_cert_request" "pki_inter" {
  depends_on = [vault_mount.pki_inter]

  backend = vault_mount.pki_inter.path

  type        = "internal"
  common_name = local.cn_intermediate
}



# ================
# Root signs Inter
# ================
resource "vault_pki_secret_backend_root_sign_intermediate" "pki_root_inter" {
  depends_on = [vault_pki_secret_backend_intermediate_cert_request.pki_inter]

  backend = vault_mount.pki_root.path

  csr         = vault_pki_secret_backend_intermediate_cert_request.pki_inter.csr
  common_name = local.cn_intermediate
  format      = "pem_bundle"
  ttl         = 60 * 60 * 24 * 365
}

# ============
# Set Inter CA
# ============
resource "vault_pki_secret_backend_intermediate_set_signed" "pki_inter" {
  backend     = vault_mount.pki_inter.path
  certificate = vault_pki_secret_backend_root_sign_intermediate.pki_root_inter.certificate
}

