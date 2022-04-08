variable "datacenter" {}
variable "domain" {}
variable "subdomain" {}

job "countdash" {
  datacenters = [var.datacenter]

  group "api" {
    network {
      mode = "bridge"
    }

    service {
      name = "count-api-service"
      port = "9001"
      connect {
        sidecar_service {}
      }
    }

    task "web" {
      driver = "docker"
      config {
        image = "hashicorpnomad/counter-api:v1"
      }
    }
  }

  group "dashboard" {
    network {
      mode ="bridge"
    }

    service {
      name = "count-dashboard-service"
      port = "9002"
      connect {
        sidecar_service {
          proxy {
            upstreams {
              destination_name = "count-api-service"
              local_bind_port = 9001
            }
          }
        }
      }
    }

    task "dashboard" {
      driver = "docker"
      env {
        COUNTING_SERVICE_URL = "http://${NOMAD_UPSTREAM_ADDR_count_api_service}"
      }
      config {
        image = "hashicorpnomad/counter-dashboard:v1"
      }
    }
  }
}
