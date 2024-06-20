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
  value = [local.master_1_ip, local.master_2_ip, local.master_3_ip]
}


output "sre_ipv4" {
  value = local.sre_ip
}

output "edge_private_ipv4" {
  value = scaleway_vpc_public_gateway_dhcp.internal.address
}


