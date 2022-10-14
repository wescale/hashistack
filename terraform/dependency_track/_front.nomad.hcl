#
# Inspired by:
# https://raw.githubusercontent.com/DependencyTrack/dependency-track/HEAD/src/main/docker/docker-compose.yml
#
variable "datacenter" {}
variable "dns_resolver_ipv4" {}
variable "domain" {}

job "dependency_track_front" {
  datacenters = [var.datacenter]

  type = "service"
  group "front" {
    count = 1

    network {
      mode        = "bridge"
      dns         { servers = [var.dns_resolver_ipv4] }

      port "front-http" { 
        to = 8080
      }
    }

    service {
      name = "dependency-track-front"
      port = "front-http"
      connect {
        sidecar_service {
          proxy {
            local_service_port = 8080
          }
        } 
      }
    }

    task "frontend" {
      driver = "docker"
      config {
        image = "dependencytrack/frontend"
        ports = ["front-http"]
      }

      env {
        API_BASE_URL = "https://track-api.tgb.wescale.fr"
      # OIDC_ISSUER = ""
      # OIDC_CLIENT_ID = ""
      # OIDC_SCOPE = ""
      # OIDC_FLOW="
      # OIDC_LOGIN_BUTTON_TEXT="
      # volumes:
      # - "/host/path/to/config.json:/app/static/config.json"
      }
    }
  }
}

