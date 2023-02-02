locals {
  root_pki_path         = var.root_pki_path
  intermediate_pki_path = var.intermediate_pki_path
  vault_address         = var.vault_address
  cn_root               = "${terraform.workspace} Root CA"
  cn_intermediary       = "${terraform.workspace} Intermediary CA"
  cn_leaf               = "${terraform.workspace} Leaf"
}

resource "vault_policy" "consul_template" {
  name = "consul_template"

  policy = templatefile("${path.module}/policy.consul.tpl", {
    intermediate_pki_path = local.intermediate_pki_path
    }
  )
}

resource "vault_token" "consul_template" {
  policies        = [vault_policy.consul_template.name]
  renewable       = true
  ttl             = "10m"
  no_parent       = true
  renew_min_lease = 600
  renew_increment = 600
}

resource "vault_policy" "telemetry" {
  name = "telemetry"

  policy = file("${path.module}/policy.nomad_server.hcl")
}

resource "vault_token" "telemetry" {
  policies        = [vault_policy.telemetry.name]
  renewable       = true
  ttl             = "24h"
  no_parent       = true
  renew_min_lease = 21600
  renew_increment = 21600
}

resource "vault_policy" "connect_ca" {
  name = "connect_ca"

  policy = templatefile("${path.module}/policy.consul_connect_ca.tpl", {
    root_pki_path         = local.root_pki_path,
    intermediate_pki_path = local.intermediate_pki_path
    }
  )
}

resource "vault_pki_secret_backend_role" "role" {
  backend            = vault_mount.pki_inter.path
  name               = "${terraform.workspace}_consul"
  ttl                = 60 * 60 * 24
  allow_ip_sans      = true
  key_type           = "rsa"
  key_bits           = 4096
  allowed_domains    = ["${terraform.workspace}.consul"]
  allow_subdomains   = true
  allow_glob_domains = true
}

resource "vault_pki_secret_backend_role" "healthcheck" {
  backend            = vault_mount.pki_inter.path
  name               = "healthcheck"
  ttl                = 60 * 24
  allow_ip_sans      = true
  key_type           = "rsa"
  key_bits           = 4096
  allowed_domains    = ["health.check"]
  allow_subdomains   = true
  allow_glob_domains = false
}


resource "vault_token" "connect_ca" {
  policies        = [vault_policy.connect_ca.name]
  renewable       = true
  ttl             = "1h"
  no_parent       = true
  renew_min_lease = 21600
  renew_increment = 21600
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
  backend                 = vault_mount.pki_root.path
  issuing_certificates    = ["${local.vault_address}/v1/${vault_mount.pki_root.path}/ca"]
  crl_distribution_points = ["${local.vault_address}/v1/${vault_mount.pki_root.path}/crl"]
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
  backend                 = vault_mount.pki_inter.path
  issuing_certificates    = ["${local.vault_address}/v1/${vault_mount.pki_inter.path}/ca"]
  crl_distribution_points = ["${local.vault_address}/v1/${vault_mount.pki_inter.path}/crl"]
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
  common_name = local.cn_intermediary
}



# ================
# Root signs Inter
# ================
resource "vault_pki_secret_backend_root_sign_intermediate" "pki_root_inter" {
  depends_on = [vault_pki_secret_backend_intermediate_cert_request.pki_inter]

  backend = vault_mount.pki_root.path

  csr         = vault_pki_secret_backend_intermediate_cert_request.pki_inter.csr
  common_name = local.cn_leaf
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
