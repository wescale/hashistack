output "raw_ssh_user" {
  value = local.raw_ssh_user
}

output "sre_ipv4" {
  value = aws_instance.sre.public_ip
}

output "sre_ipv6" {
  value = aws_instance.sre.ipv6_addresses[0]
}

output "masters_ipv4" {
  value = [
    for machine in aws_instance.masters : machine.private_ip
  ]
}

output "minions_ipv4" {
  value = aws_instance.minions.*.private_ip
}

output "private_network_id" {
  value = [
    for subnet in aws_subnet.sandbox-sb : subnet.id
  ]
}
