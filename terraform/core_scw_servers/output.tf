output "raw_ssh_user" {
  value = local.raw_ssh_user
}

output "sre_ipv4" {
  value = scaleway_instance_server.sre.public_ip
}

output "sre_ipv6" {
  value = scaleway_instance_server.sre.ipv6_address
}

output "masters_ipv4" {
  value = scaleway_instance_server.masters.*.private_ip
}

output "minions_ipv4" {
  value = scaleway_instance_server.minions.*.private_ip
}

output "private_network_id" {
  value = scaleway_vpc_private_network.workspace.id
}
