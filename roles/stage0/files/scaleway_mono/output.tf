output "raw_ssh_user" {
  value = local.raw_ssh_user
}

output "sre_ipv4" {
  value = scaleway_instance_server.mono.public_ip
}

output "sre_ipv6" {
  value = scaleway_instance_server.mono.ipv6_address
}

