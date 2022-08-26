variable "datacenter" {}
variable "domain" {}

locals {
  envoy_exposed_port = 8080
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
                hosts = ["prom.${var.domain}"]
                name  = "prometheus"
              }
              service {
                hosts = ["tns.${var.domain}"]
                name  = "tns-app"
              }
            }
          }
        }
      }
    }
  }
}


