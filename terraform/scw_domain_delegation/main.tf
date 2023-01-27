locals {
  domain_name = var.domain_name
  subdomain_name = var.subdomain_name
  subdomain_authority_ipv4 = var.subdomain_authority_ipv4
  subdomain_authority_ipv6 = var.subdomain_authority_ipv6
  ttl = var.ttl

  ns_name = "ns.${local.subdomain_name}"
}

resource "scaleway_domain_record" "ns_ipv4" {
  dns_zone = local.domain_name
  name     = local.ns_name
  type     = "A"
  data     = local.subdomain_authority_ipv4
  ttl      = local.ttl
}

resource "scaleway_domain_record" "ns_ipv6" {

  count = local.subdomain_authority_ipv6 != null ? 1 : 0

  dns_zone = local.domain_name
  name     = local.ns_name
  type     = "AAAA"
  data     = local.subdomain_authority_ipv6
  ttl      = local.ttl
}

resource "scaleway_domain_record" "ns_domain" {
  dns_zone = local.domain_name
  name     = local.subdomain_name
  type     = "NS"
  data     = local.ns_name
  ttl      = local.ttl
}
