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
      port "data" {
        to = 3100
      }
      port "expose" {}
    }

    restart {
      attempts = 3
      delay    = "20s"
      mode     = "delay"
    }

    service {
      name = "loki-web"
      port = "data"
      tags = ["monitoring","prometheus"]

      meta {
        metrics_port = "${NOMAD_HOST_PORT_expose}"
      }

      connect {
        sidecar_service {
          proxy {
            expose {
              path {
                path            = "/metrics"
                protocol        = "http"
                local_path_port = 8080
                listener_port   = "expose"
              }
            }
          }
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
        ports = ["data"]
        args = [
          "-config.file",
          "/etc/loki/local-config.yaml",
        ]
      }

      resources {
        cpu    = 50
        memory = 100
      }
    }
  }
}
