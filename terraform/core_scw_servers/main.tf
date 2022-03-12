locals {
  instance_name_prefix       = terraform.workspace
  instance_type              = var.instance_type
  jump_host_instance_type    = "DEV1-L"
  masters_instance_type    = "DEV1-M"
  minions_instance_type    = "DEV1-M"
  instance_image             = "debian_bullseye"
  instance_enable_ipv6       = true
  instance_enable_dynamic_ip = true
  ssh_public_key_name        = "${local.instance_name_prefix}_key"
  ssh_public_key_file        = var.ssh_public_key_file
  raw_ssh_user               = "root"
  private_subnet_cidr        = "192.168.42.0/24"
  private_subnet_gw        = "192.168.42.1"
}

resource "scaleway_account_ssh_key" "admin" {
  name       = local.ssh_public_key_name
  public_key = file(local.ssh_public_key_file)
}

resource "scaleway_instance_security_group" "server" {

  inbound_rule {
    action   = "accept"
    port     = 22
    protocol = "TCP"
    ip_range = "0.0.0.0/0"
  }

  outbound_rule {
    action = "accept"
  }
}

resource "scaleway_instance_server" "controller" {

  name  = "${local.instance_name_prefix}-sre"
  type  = local.jump_host_instance_type
  image = local.instance_image

  enable_ipv6       = local.instance_enable_ipv6
  enable_dynamic_ip = local.instance_enable_dynamic_ip
  
  private_network {
    pn_id = scaleway_vpc_private_network.workspace.id
  }

  user_data = {
    cloud-init = templatefile("${path.module}/cloud-init.sre.yml", {})
  }

  security_group_id = scaleway_instance_security_group.server.id
}

resource "scaleway_instance_server" "masters" {

  count = 3

  name  = "${local.instance_name_prefix}-master-0${count.index + 1}"
  type  = local.masters_instance_type
  image = local.instance_image

  security_group_id = scaleway_instance_security_group.server.id

  private_network {
    pn_id = scaleway_vpc_private_network.workspace.id
  }

  user_data = {
    cloud-init = templatefile("${path.module}/cloud-init.yml", { private_subnet_gw = local.private_subnet_gw, controller_ip = scaleway_instance_server.controller.private_ip })
  }
  
  depends_on = [scaleway_vpc_gateway_network.workspace]
}

resource "scaleway_instance_server" "minions" {

  count = 3

  name  = "${local.instance_name_prefix}-minion-0${count.index + 1}"
  type  = local.minions_instance_type
  image = local.instance_image

  security_group_id = scaleway_instance_security_group.server.id
  private_network {
    pn_id = scaleway_vpc_private_network.workspace.id
  }

  user_data = {
    cloud-init = templatefile("${path.module}/cloud-init.yml", { private_subnet_gw = local.private_subnet_gw, controller_ip = scaleway_instance_server.controller.private_ip })
  }

  depends_on = [scaleway_vpc_gateway_network.workspace]
}

resource "scaleway_vpc_private_network" "workspace" {
  name = terraform.workspace
}

resource "scaleway_vpc_public_gateway_dhcp" "workspace" {
  subnet             = local.private_subnet_cidr
  push_default_route = false
  enable_dynamic     = true
}

resource "scaleway_vpc_public_gateway_ip" "workspace" {}

resource "scaleway_vpc_public_gateway" "workspace" {
  name  = terraform.workspace
  type  = "VPC-GW-M"
  ip_id = scaleway_vpc_public_gateway_ip.workspace.id
}

resource "scaleway_vpc_gateway_network" "workspace" {
  gateway_id         = scaleway_vpc_public_gateway.workspace.id
  private_network_id = scaleway_vpc_private_network.workspace.id
  dhcp_id            = scaleway_vpc_public_gateway_dhcp.workspace.id
  enable_masquerade  = true
  enable_dhcp        = true
  cleanup_dhcp       = true
}

