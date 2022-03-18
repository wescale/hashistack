resource "consul_config_entry" "tempo_svc_defaults" {
  name = "tempo"
  kind = "service-defaults"

  config_json = jsonencode({
    Protocol    = "http"
  })
}

resource "nomad_job" "tempo" {
  jobspec = file("${path.module}/tempo.nomad.hcl")

  hcl2 {
    enabled = true
    vars = {
      datacenter = var.datacenter
      domain = var.domain
      subdomain = var.subdomain
      dns_resolver_ipv4 = var.dns_server
    }
  }

  depends_on = [consul_config_entry.tempo_svc_defaults]
}

