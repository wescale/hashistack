variable "datacenter" {}
variable "dns_resolver_ipv4" {}

job "drone" {
  datacenters = [var.datacenter]

  type = "service"
  group "web" {
    count = 1
    network {
      mode = "bridge"

      dns {
        servers = [var.dns_resolver_ipv4]
      }

      port "http" {
        static = 80
      }
    }

    service {
      name = "drone"
      port = "http"
      connect {
        sidecar_service {}
      }
    }
 
    task "frontend" {
      driver = "docker"
      config {
        image = "drone/drone"
        ports = ["http"]
      }
      env {
        DRONE_GITLAB_SERVER = "https://gitlab.com"
        DRONE_GITLAB_CLIENT_ID = "demo-drone-manolito"
        DRONE_GITLAB_CLIENT_SECRET = ""
        DRONE_RPC_SECRET = "super-duper-secret"
        DRONE_SERVER_HOST = "drone.manolito.wescale.fr"
        DRONE_SERVER_PROTO= "https"
      }
      resources {
        cpu    = 500 # MHz
        memory = 128 # MB
      }
    }
  }
}
