locals {
  admin_domain = var.admin_lb_domain
  apps_domain = var.apps_lb_domain
  private_network_id = var.private_network_id
  fullchain_cert_path = var.cert_path
  cert_key_path = var.cert_key_path
  masters_private_ipv4 = var.masters_private_ipv4
  minions_private_ipv4 = var.minions_private_ipv4
}
resource "scaleway_lb_ip" "admin" {
    reverse = local.admin_domain
}

resource "scaleway_lb_certificate" "apps" {
  lb_id = scaleway_lb.apps.id
  name  = local.apps_domain
  custom_certificate {
    certificate_chain = <<EOF
${file(local.fullchain_cert_path)}
${file(local.cert_key_path)}
EOF
  }
}

resource "scaleway_lb" "admin" {
  ip_id  = scaleway_lb_ip.admin.id
  name = "${terraform.workspace}-admin"
  type   = "LB-S"
  release_ip = false

  private_network {
    private_network_id = local.private_network_id
    dhcp_config = true
  }
}



resource "scaleway_lb_frontend" "vault" {
  lb_id        = scaleway_lb.admin.id
  backend_id   = scaleway_lb_backend.vault.id
  name         = "${terraform.workspace}_vault"
  inbound_port = "8200"
}

resource "scaleway_lb_backend" "vault" {
  lb_id            = scaleway_lb.admin.id
  name             = "${terraform.workspace}_vault"
  forward_protocol = "tcp"
  forward_port     = "8200"
  server_ips = local.masters_private_ipv4
}

resource "scaleway_lb_frontend" "consul" {
  lb_id        = scaleway_lb.admin.id
  backend_id   = scaleway_lb_backend.consul.id
  name         = "${terraform.workspace}_consul"
  inbound_port = "8501"
}

resource "scaleway_lb_backend" "consul" {
  lb_id            = scaleway_lb.admin.id
  name             = "${terraform.workspace}_consul"
  forward_protocol = "tcp"
  forward_port     = "8501"
  server_ips = local.masters_private_ipv4
}

resource "scaleway_lb_frontend" "nomad" {
  lb_id        = scaleway_lb.admin.id
  backend_id   = scaleway_lb_backend.nomad.id
  name         = "${terraform.workspace}_nomad"
  inbound_port = "4646"
}

resource "scaleway_lb_backend" "nomad" {
  lb_id            = scaleway_lb.admin.id
  name             = "${terraform.workspace}_nomad"
  forward_protocol = "tcp"
  forward_port     = "4646"
  server_ips = local.masters_private_ipv4
}


resource "scaleway_lb_ip" "apps" {
    reverse = local.apps_domain
}

resource "scaleway_lb" "apps" {
  ip_id  = scaleway_lb_ip.apps.id
  name = "${terraform.workspace}-apps"
  type   = "LB-S"
  release_ip = false

  private_network {
    private_network_id = local.private_network_id
    dhcp_config = true
  }
}

resource "scaleway_lb_frontend" "apps" {
  lb_id        = scaleway_lb.apps.id
  backend_id   = scaleway_lb_backend.envoy.id
  name         = "${terraform.workspace}_nomad"
  certificate_id = scaleway_lb_certificate.apps.id
  inbound_port = "443"

  acl {
    action {
      type = "allow"
    }
    match {
      ip_subnet = ["0.0.0.0"]
    }
  }
}

resource "scaleway_lb_backend" "envoy" {
  lb_id            = scaleway_lb.apps.id
  name             = "${terraform.workspace}_envoy"
  forward_protocol = "http"
  forward_port     = "8080"
  server_ips = local.minions_private_ipv4
}

