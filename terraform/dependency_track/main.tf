resource "consul_config_entry" "default_protocol" {
  name        = "dependency_track"
  kind        = "service-defaults"
  config_json = jsonencode({ Protocol = "http" })
}

resource "nomad_job" "dependency_track" {
  jobspec = file("${path.module}/_dependency_track.nomad.hcl")

  hcl2 {
    enabled = true
    vars = {
      datacenter = var.datacenter
      domain = var.domain
      dns_resolver_ipv4 = var.dns_container_resolver 
    }
  }

  depends_on = [consul_config_entry.default_protocol]
}

resource "nomad_job" "dependency_track_front" {
  jobspec = file("${path.module}/_front.nomad.hcl")

  hcl2 {
    enabled = true
    vars = {
      datacenter = var.datacenter
      domain = var.domain
      dns_resolver_ipv4 = var.dns_container_resolver 
    }
  }

  depends_on = [consul_config_entry.default_protocol]
}

resource "dns_cname_record" "dependency_track_front" {
  zone  = "${var.domain}."
  name  = "track"
  cname = "apps.${var.domain}."
  ttl   = 300
}

resource "dns_cname_record" "dependency_track_api" {
  zone  = "${var.domain}."
  name  = "track-api"
  cname = "apps.${var.domain}."
  ttl   = 300
}


resource "consul_config_entry" "dependency_track_allow_ingress" {
  name = "dependency_track_front"
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

resource "consul_config_entry" "dependency_track_allow_ingress_api" {
  name = "dependency_track_api"
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

