#
# Inspired by:
# https://blog.sonatype.com/sonatype-nexus-installation-using-docker 
#
variable "datacenter" {}
variable "dns_resolver_ipv4" {}
variable "domain" {}

job "nexus" {
  datacenters = [var.datacenter]

  type = "service"
  group "nexus" {
    count = 1

    network {
      mode        = "bridge"
      dns         { servers = [var.dns_resolver_ipv4] }

      port "http" { 
        to = 8081
      }
    }

    service {
      name = "nexus"
      port = "http"
      connect {
        sidecar_service {
          proxy {
            local_service_port = 8081
          }
        } 
      }
    }

    task "nexus" {
      driver = "docker"
      config {
        image = "sonatype/nexus"
        ports = ["http"]
      }

      resources {
        cpu    = 1000 # MHz
        memory = 768 # MB
      }

      env {
        CONTEXT_PATH = "/"
        MAX_HEAP = "768m"
        MIN_HEAP = "256m"
        # JAVA_OPTS = "-server -XX:MaxPermSize=192m -Djava.net.preferIPv4Stack=true"
        # LAUNCHER_CONF = "./conf/jetty.xml ./conf/jetty-requestlog.xml"
      }
    }
  }
}

