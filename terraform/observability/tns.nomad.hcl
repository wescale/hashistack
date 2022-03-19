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
        static = 8000
      }
      port "dbgrpc" {
        static = 9900
      }
      port "app" {
        static = 8001
      }
      port "appgrpc" {
        static = 9901
      }
      port "loadgen" {
        static = 8002
      }
      port "loadgengrpc" {
        static = 9902
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
      port = "app"
      connect {
        sidecar_service {}
      }
    }
    service {
      name = "tns-loadgen"
      port = "loadgen"
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
          "-server.http-listen-port=${NOMAD_PORT_db}",
          "-server.grpc-listen-port=${NOMAD_PORT_dbgrpc}",
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
          "-server.http-listen-port=${NOMAD_PORT_app}",
          "-server.grpc-listen-port=${NOMAD_PORT_appgrpc}",
          "http://localhost:${NOMAD_PORT_db}",
        ]
      }
    }

    task "loadgen" {
      driver = "docker"
      env {
        JAEGER_AGENT_HOST    = "localhost"
        JAEGER_TAGS          = "cluster=nomad"
        JAEGER_SAMPLER_TYPE  = "probabilistic"
        JAEGER_SAMPLER_PARAM = "1"
      }
      config {
        image = "grafana/tns-loadgen:latest"
        ports = ["loadgen"]

        args = [
          "-log.level=debug",
          "-server.http-listen-port=${NOMAD_PORT_loadgen}",
          "-server.grpc-listen-port=${NOMAD_PORT_loadgengrpc}",
          "http://localhost:${NOMAD_PORT_app}",
        ]
      }
    }
  }
}
