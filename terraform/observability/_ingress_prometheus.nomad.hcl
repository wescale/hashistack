
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
        static = 9090
      }
    }

    service {
      name = "ingress-loki"
      connect {
        gateway {
          proxy {}
          ingress {
            listener {
              port     = 9090
              protocol = "tcp"
              service {
                name  = "prometheus"
              }
            }
          }
        }
      }
    }
  }
}
