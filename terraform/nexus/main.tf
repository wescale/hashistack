resource "consul_config_entry" "default_protocol" {
  name        = "nexus"
  kind        = "service-defaults"
  config_json = jsonencode({ Protocol = "http" })
}


resource "nomad_job" "nexus" {
  jobspec = file("${path.module}/_nexus.nomad.hcl")

  hcl2 {
    enabled = true
    vars = {
      datacenter        = var.datacenter
      domain            = var.domain
      dns_resolver_ipv4 = var.dns_container_resolver
    }
  }

  depends_on = [consul_config_entry.default_protocol]
}

resource "dns_cname_record" "nexus" {
  zone  = "${var.domain}."
  name  = "nexus"
  cname = "apps.${var.domain}."
  ttl   = 300
}


resource "consul_config_entry" "nexus_allow_ingress" {
  name = "nexus"
  kind = "service-intentions"

  config_json = jsonencode({
    Sources = [
      {
        Action = "allow"
        Name   = "ingress-http"
      }
    ]
  })
}

