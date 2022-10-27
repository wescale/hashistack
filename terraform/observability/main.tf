resource "consul_config_entry" "tns_svc_defaults" {
  name = "tns"
  kind = "service-defaults"

  config_json = jsonencode({
    Protocol    = "http"
  })
}



resource "nomad_job" "tns" {
  jobspec = file("${path.module}/_tns.nomad.hcl")

  hcl2 {
    enabled = true
    vars = {
      datacenter = var.datacenter
      domain = var.domain
      subdomain = var.subdomain
      dns_resolver_ipv4 = var.dns_container_resolver 
    }
  }

  depends_on = [consul_config_entry.tns_svc_defaults]
}

resource "nomad_job" "ingress" {
  jobspec = file("${path.module}/_ingress.nomad.hcl")

  hcl2 {
    enabled = true
    vars = {
      datacenter = var.datacenter
      domain = var.domain
    }
  }
}

resource "consul_config_entry" "intention-ingress" {
  name = "tns-app"
  kind = "service-intentions"

  config_json = jsonencode({
   Sources = [
      {
        Action     = "allow"
        Name       = "ingress-http"
      }
    ] 
  })
}


resource "consul_config_entry" "intention-trackfront-ingress" {
  name = "dependency-track-front"
  kind = "service-intentions"

  config_json = jsonencode({
   Sources = [
      {
        Action     = "allow"
        Name       = "ingress-http"
      }
    ] 
  })
}

resource "consul_config_entry" "intention-trackapi-ingress" {
  name = "dependency-track-api"
  kind = "service-intentions"

  config_json = jsonencode({
   Sources = [
      {
        Action     = "allow"
        Name       = "ingress-http"
      }
    ] 
  })
}

resource "dns_cname_record" "app" {
  zone  = "${var.domain}."
  name  = "tns"
  cname = "apps.${var.domain}."
  ttl   = 300
}


