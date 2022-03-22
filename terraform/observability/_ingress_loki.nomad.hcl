variable "datacenter" {}
variable "domain" {}

job "ingress-loki" {
  type        = "system"
  datacenters = [
    var.datacenter
  ]
  
  group "ingress-loki" {
    network {
      mode = "bridge"
      port "inbound" {
        static = 3100
      }
    }

    service {
      name = "ingress-loki"
      connect {
        gateway {
          proxy {}
          ingress {
            listener {
              port     = 3100
              protocol = "tcp"
              service {
                name  = "loki-web"
              }
            }
          }
        }
      }
    }
  }
}
