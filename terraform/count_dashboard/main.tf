resource "consul_config_entry" "dashboard" {
  name = "count-dashboard-service"
  kind = "service-defaults"

  config_json = jsonencode({
    Protocol    = "http"
  })
}

resource "consul_config_entry" "api" {
  name = "count-api-service"
  kind = "service-defaults"

  config_json = jsonencode({
    Protocol    = "http"
  })
}

resource "nomad_job" "count-dashboard" {
  jobspec = file("${path.module}/_count_dashboard.nomad.hcl")

  hcl2 {
    enabled = true
    vars = {
      datacenter = var.datacenter
      domain = var.domain
      subdomain = var.subdomain
    }
  }

  depends_on = [consul_config_entry.dashboard, consul_config_entry.api]
}

resource "consul_config_entry" "ingress" {
  name = "count-ingress"
  kind = "service-defaults"

  config_json = jsonencode({
    Protocol    = "http"
  })
}

resource "nomad_job" "terminating" {
  jobspec = file("${path.module}/_ingress.nomad.hcl")

  hcl2 {
    enabled = true
    vars = {
      datacenter = var.datacenter
      domain = var.domain
    }
  }
  depends_on = [consul_config_entry.ingress]
}

resource "dns_cname_record" "app" {
  zone  = "${var.domain}."
  name  = "countdash"
  cname = "apps.${var.domain}."
  ttl   = 300
}
