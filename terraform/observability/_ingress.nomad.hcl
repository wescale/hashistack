variable "datacenter" {}
variable "domain" {}

job "ingress-gateway" {
  type        = "system"
  datacenters = [
    var.datacenter
  ]
  
  group "ingress-gateway" {
    network {
      mode = "bridge"
      port "inbound" {
        static = 8080
        to = 8080
      }
    }

    service {
      name = "ingress-web"
      connect {
        gateway {
          proxy {}
          ingress {
            listener {
              port     = 8080
              protocol = "http"
              service {
                name  = "tns-app"
                hosts = [
                  "tns.${var.domain}"
                ]
              }
              service {
                name  = "loki-web"
                hosts = [
                  "loki.${var.domain}"
                ]
              }
            }
          }
        }
      }
    }
  }
}
