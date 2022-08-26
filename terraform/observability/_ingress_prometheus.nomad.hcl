
variable "datacenter" {}
variable "domain" {}

job "ingress-prometheus" {
  type        = "system"
  datacenters = [
    var.datacenter
  ]
  
  group "ingress-prometheus" {
    network {
      mode = "bridge"
      port "inbound" {
        static = 8080
        to = 8080
      }
    }

    service {
      name = "ingress-prometheus"
      connect {
        gateway {
          proxy {}
          ingress {
            listener {
              port     = 8080
              protocol = "http"
              service {
                name  = "prometheus"
                hosts = [
                  "prom.${var.domain}"
                ]
              }
            }
          }
        }
      }
    }
  }
}
