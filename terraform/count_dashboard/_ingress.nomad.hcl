variable "datacenter" {}
variable "domain" {}
variable "subdomain" {}

job "ingress-gateway" {
  type        = "system"
  datacenters = [
    var.datacenter
  ]
  
  group "ingress-gateway" {
    network {
      mode = "bridge"
      port "http" {
        static = 80
      }
    }

    service {
      name = "count-ingress"
      connect {
        gateway {
          proxy {}
          ingress {
            listener {
              port     = 80
              protocol = "http"
              service {
                name  = "count-dashboard-service"
                hosts = [
                  "count.${var.domain}"
                ]
              }
            }
          }
        }
      }
    }
  }
}
