variable "datacenter" {}
variable "dns_resolver_ipv4" {}
variable "domain" {}
variable "subdomain" {}

job "loki" {
  datacenters = [var.datacenter]
  type        = "service"

  group "loki" {
    count = 1

    network {

      mode = "bridge"
      dns {
        servers = [var.dns_resolver_ipv4]
      }
      port "http" {
        static = 3100
      }
    }

    restart {
      attempts = 3
      delay    = "20s"
      mode     = "delay"
    }

    service {
      name = "loki-web"
      port = "http"
      tags = ["monitoring","prometheus"]

      connect {
        sidecar_service {}
      }

      check {
        name     = "Loki HTTP"
        type     = "http"
        path     = "/ready"
        interval = "5s"
        timeout  = "2s"

        check_restart {
          limit           = 2
          grace           = "60s"
          ignore_warnings = false
        }
      }
    }

    service {
      name = "local-tempo-write"
      port = "6831"
      connect {
        sidecar_service {
          proxy {
            upstreams {
              destination_name = "tempo-write"
              local_bind_port = 6831
            }
          }
        }
      }
    }

    task "loki" {
      driver = "docker"

      env {
        JAEGER_AGENT_HOST    = "localhost"
        JAEGER_TAGS          = "cluster=nomad"
        JAEGER_SAMPLER_TYPE  = "probabilistic"
        JAEGER_SAMPLER_PARAM = "1"
      }

      config {
        image = "grafana/loki:latest"
        ports = ["http"]
        args = [
          "-config.file",
          "/etc/loki/local-config.yaml",
        ]
      }

      resources {
        cpu    = 200
        memory = 200
      }

      
    }
  }
}
