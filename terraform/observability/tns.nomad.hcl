variable "datacenter" {}
variable "dns_resolver_ipv4" {}
variable "domain" {}
variable "subdomain" {}

job "tns" {
  datacenters = [var.datacenter]
  type        = "service"

  group "tns" {
    count = 1

    network {
      mode = "bridge"

      dns {
        servers = [var.dns_resolver_ipv4]
      }

      port "db" {
        to = 8000
      }
      port "db-grpc" {
        to = 9900
      }

      port "app" {
        to = 8001
      }
      port "app-grpc" {
        to = 9901
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

    service {
      name = "tns-app"
      port = "8001"
      connect {
        sidecar_service {}
      }
    }

    task "db" {
      driver = "docker"
      env {
        JAEGER_AGENT_HOST    = "localhost"
        JAEGER_TAGS          = "cluster=nomad"
        JAEGER_SAMPLER_TYPE  = "probabilistic"
        JAEGER_SAMPLER_PARAM = "1"
      }
      config {
        image = "grafana/tns-db:latest"
        ports = ["db"]

        args = [
          "-log.level=debug",
          "-server.http-listen-port=8000",
          "-server.grpc-listen-port=9900",
        ]
      }
    }

    task "app" {
      driver = "docker"
      env {
        JAEGER_AGENT_HOST    = "localhost"
        JAEGER_TAGS          = "cluster=nomad"
        JAEGER_SAMPLER_TYPE  = "probabilistic"
        JAEGER_SAMPLER_PARAM = "1"
      }
      config {
        image = "grafana/tns-app:latest"
        ports = ["app"]

        args = [
          "-log.level=debug",
          "-server.http-listen-port=8001",
          "-server.grpc-listen-port=9901",
          "http://localhost:8000",
        ]
      }
    }
  }
}
