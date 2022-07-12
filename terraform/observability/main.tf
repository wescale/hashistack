resource "consul_config_entry" "tempo_svc_defaults" {
  name = "tempo"
  kind = "service-defaults"

  config_json = jsonencode({
    Protocol    = "http"
  })
}

resource "consul_config_entry" "loki_svc_defaults" {
  name = "loki-web"
  kind = "service-defaults"

  config_json = jsonencode({
    Protocol    = "tcp"
  })
}


resource "nomad_job" "tempo" {
  jobspec = file("${path.module}/_tempo.nomad.hcl")

  hcl2 {
    enabled = true
    vars = {
      datacenter = var.datacenter
      domain = var.domain
      subdomain = var.subdomain
      dns_resolver_ipv4 = var.dns_container_resolver 
    }
  }

  depends_on = [consul_config_entry.tempo_svc_defaults]
}

resource "consul_config_entry" "tns_svc_defaults" {
  name = "tns"
  kind = "service-defaults"

  config_json = jsonencode({
    Protocol    = "http"
  })
}

resource "nomad_job" "tns" {
  jobspec = file("${path.module}/tns.nomad.hcl")

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

resource "nomad_job" "ingress_loki" {
  jobspec = file("${path.module}/_ingress_loki.nomad.hcl")

  hcl2 {
    enabled = true
    vars = {
      datacenter = var.datacenter
      domain = var.domain
    }
  }
  depends_on = [consul_config_entry.loki_svc_defaults]
}


resource "nomad_job" "promtail" {
  jobspec = file("${path.module}/_promtail.nomad.hcl")

  hcl2 {
    enabled = true
    vars = {
      datacenter = var.datacenter
      domain = var.domain
      subdomain = var.subdomain
      dns_resolver_ipv4 = var.dns_container_resolver
    }
  }
}

resource "nomad_job" "loki" {
  jobspec = file("${path.module}/_loki.nomad.hcl")

  hcl2 {
    enabled = true
    vars = {
      datacenter = var.datacenter
      domain = var.domain
      subdomain = var.subdomain
      dns_resolver_ipv4 = var.dns_container_resolver    
    }
  }
  depends_on = [consul_config_entry.loki_svc_defaults]
}

resource "consul_config_entry" "prometheus_svc_defaults" {
  name = "prometheus"
  kind = "service-defaults"

  config_json = jsonencode({
    Protocol    = "tcp"
  })
}

resource "nomad_job" "ingress_prometheus" {
  jobspec = file("${path.module}/_ingress_prometheus.nomad.hcl")

  hcl2 {
    enabled = true
    vars = {
      datacenter = var.datacenter
      domain = var.domain
    }
  }
  depends_on = [consul_config_entry.prometheus_svc_defaults]
}

resource "nomad_job" "prometheus" {
  jobspec = file("${path.module}/_prometheus.nomad.hcl")

  hcl2 {
    enabled = true
    vars = {
      datacenter = var.datacenter
      domain = var.domain
      subdomain = var.subdomain
      dns_resolver_ipv4 = var.dns_container_resolver    
    }
  }
  depends_on = [consul_config_entry.prometheus_svc_defaults]
}


resource "dns_cname_record" "app" {
  zone  = "${var.domain}."
  name  = "tns"
  cname = "apps.${var.domain}."
  ttl   = 300
}


