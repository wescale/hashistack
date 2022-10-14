variable "datacenter" {}
variable "domain" {}

locals {
  envoy_exposed_port = 8082
}

job "ingress-gateway" {
  type        = "system"
  datacenters = [
    var.datacenter
  ]
  
  group "ingress-gateway" {
    network {
      mode = "bridge"
      port "inbound" {
        static = local.envoy_exposed_port
        to = local.envoy_exposed_port
      }
    }

    service {
      name = "ingress-http"
      connect {
        gateway {
          proxy {}
          ingress {
            listener {
              port     = local.envoy_exposed_port 
              protocol = "http"
              service {
                hosts = ["tns.${var.domain}"]
                name  = "tns-app"
              }
              service {
                hosts = ["drone.${var.domain}"]
                name  = "drone"
              }
              service {
                hosts = ["track.${var.domain}"]
                name  = "dependency-track-front"
              }
              service {
                hosts = ["track-api.${var.domain}"]
                name  = "dependency-track-api"
              }
              service {
                hosts = ["nexus.${var.domain}"]
                name  = "nexus"
              }


            }
          }
        }
      }
    }
  }
}


