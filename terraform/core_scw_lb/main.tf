locals {
  admin_domain = var.admin_lb_domain
  cn_cert = ""
  private_network_id = var.private_network_id
  fullchain_cert_path = ""
  masters_private_ipv4 = var.masters_private_ipv4
  minions_private_ipv4 = var.minions_private_ipv4
}
resource "scaleway_lb_ip" "admin" {
    reverse = local.admin_domain
}

#resource "scaleway_lb_certificate" "admin" {
#  lb_id = scaleway_lb.admin.id
#  name  = local.cn_cert
#  custom_certificate {
#    certificate_chain = file(local.fullchain_cert_path)
#  }
#}

resource "scaleway_lb" "admin" {
  ip_id  = scaleway_lb_ip.admin.id
  name = terraform.workspace
  type   = "LB-S"
  release_ip = true

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
