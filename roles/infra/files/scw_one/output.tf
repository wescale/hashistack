data "scaleway_ipam_ip" "master_1" {
  private_network_id = scaleway_vpc_private_network.internal.id
  type               = "ipv4"
  resource {
    type = "instance_private_nic"
    id   = scaleway_instance_private_nic.master_1.id
  }
}
data "scaleway_ipam_ip" "master_2" {
  private_network_id = scaleway_vpc_private_network.internal.id
  type               = "ipv4"
  resource {
    type = "instance_private_nic"
    id   = scaleway_instance_private_nic.master_2.id
  }
}
data "scaleway_ipam_ip" "master_3" {
  private_network_id = scaleway_vpc_private_network.internal.id
  type               = "ipv4"
  resource {
    type = "instance_private_nic"
    id   = scaleway_instance_private_nic.master_3.id
  }
}

output "default_ssh_user" {
  value = local.instance_default_ssh_user
}

output "private_network_domain" {
  value = scaleway_vpc_private_network.internal.name
}

output "edge_public_ipv4" {
  value = scaleway_vpc_public_gateway_ip.internal.address
}

output "edge_bastion_port" {
  value = scaleway_vpc_public_gateway.internal.bastion_port
}

output "private_network_cidr" {
  value = local.internal_cidr
}

output "masters_ipv4" {
  value = [
    data.scaleway_ipam_ip.master_1.address,
    data.scaleway_ipam_ip.master_2.address,
    data.scaleway_ipam_ip.master_3.address,
  ]
}

data "scaleway_ipam_ip" "sre" {
  private_network_id = scaleway_vpc_private_network.internal.id
  type               = "ipv4"
  resource {
    type = "instance_private_nic"
    id   = scaleway_instance_private_nic.sre.id
  }
}

output "sre_ipv4" {
  value = data.scaleway_ipam_ip.sre.address
}

data "scaleway_ipam_ip" "edge" {
  ipam_ip_id = scaleway_ipam_ip.edge.id
}

output "edge_private_ipv4" {
  value = data.scaleway_ipam_ip.edge.address
}


