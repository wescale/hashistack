locals {
  service_name     = "drone"
  service_protocol = "http"
  nomad_job_spec   = file("${path.module}/_drone.nomad.hcl")
  nomad_job_vars = {
    datacenter        = var.datacenter
    domain            = var.domain
    subdomain         = var.subdomain
    dns_resolver_ipv4 = var.dns_container_resolver
  }
  dns_cname_zone    = "${var.domain}."
  dns_cname_record  = local.service_name
  dns_cname_target  = "apps.${var.domain}."
  dns_cname_ttl     = 300
  edge_service_name = "ingress-http"
}
resource "consul_config_entry" "service_protocol" {
  name = local.service_name
  kind = "service-defaults"

  config_json = jsonencode({
    Protocol = local.service_protocol
  })
}

resource "nomad_job" "service" {
  jobspec = local.nomad_jobspec

  hcl2 {
    enabled = true
    vars    = local.nomad_job_vars
  }

  depends_on = [consul_config_entry.service_protocol]
}

resource "consul_config_entry" "service_ingress" {
  name = local.service_name
  kind = "service-intentions"

  config_json = jsonencode({
    Sources = [
      {
        Action = "allow"
        Name   = local.edge_service_name
      }
    ]
  })
}

resource "dns_cname_record" "drone" {
  zone  = local.dns_cname_zone
  name  = local.dns_cname_record
  cname = local.dns_cname_target
  ttl   = local.dns_cname_ttl
}
