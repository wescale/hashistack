locals {
  instance_name_prefix       = terraform.workspace
  instance_type              = var.instance_type
  instance_image             = "debian_bullseye"
  instance_enable_ipv6       = true
  instance_enable_dynamic_ip = true

  ssh_public_key_name = "${local.instance_name_prefix}_key"
  ssh_public_key_file = var.ssh_public_key_file
  raw_ssh_user        = "root"
  ready_ssh_user      = "caretaker"
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

  name  = "${local.instance_name_prefix}-controller"
  type  = local.instance_type
  image = local.instance_image

  enable_ipv6       = local.instance_enable_ipv6
  enable_dynamic_ip = local.instance_enable_dynamic_ip

  security_group_id = scaleway_instance_security_group.server.id
}

resource "scaleway_instance_server" "masters" {

  count = 3

  name  = "${local.instance_name_prefix}-master-0${count.index}"
  type  = local.instance_type
  image = local.instance_image

  enable_ipv6       = local.instance_enable_ipv6
  enable_dynamic_ip = local.instance_enable_dynamic_ip
  security_group_id = scaleway_instance_security_group.server.id
}

resource "scaleway_instance_server" "minions" {

  count = 3

  name  = "${local.instance_name_prefix}-minion-0${count.index}"
  type  = local.instance_type
  image = local.instance_image

  enable_ipv6       = local.instance_enable_ipv6
  enable_dynamic_ip = local.instance_enable_dynamic_ip
  security_group_id = scaleway_instance_security_group.server.id
}
