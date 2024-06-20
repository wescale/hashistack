resource "scaleway_domain_record" "delegation_ns" {
  dns_zone = local.parent_domain
  name     = local.delegated_subdomain
  type     = "NS"
  data     = local.delegation_ns_name
  ttl      = local.delegation_record_ttl
}

resource "scaleway_domain_record" "delegation_a" {
  dns_zone = local.parent_domain
  name     = local.delegation_ns_name
  type     = "A"
  data     = scaleway_vpc_public_gateway_ip.internal.address
  ttl      = local.delegation_record_ttl
}

