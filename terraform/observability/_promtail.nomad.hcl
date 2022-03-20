variable "datacenter" {}
variable "dns_resolver_ipv4" {}
variable "domain" {}
variable "subdomain" {}

job "promtail" {
  datacenters = [var.datacenter]
  # Runs on all nomad clients
  type = "system"

  group "promtail" {
    count = 1

    network {
      mode = "bridge"
      dns {
        servers = [var.dns_resolver_ipv4]
      }

      port "http" {
        static = 3200
      }
    }

    restart {
      attempts = 3
      delay    = "20s"
      mode     = "delay"
    }

    service {
      name = "loki-upstream"
      port = "3100"
      connect {
        sidecar_service {
          proxy {
            upstreams {
              destination_name = "loki"
              local_bind_port = 3100
            }
          }
        }
      }
    }

    service {
      name = "promtail"
      port = "http"
      tags = ["monitoring","prometheus"]

      connect {
        sidecar_service {}
      }

      check {
        name     = "Promtail HTTP"
        type     = "http"
        path     = "/targets"
        interval = "5s"
        timeout  = "2s"

        check_restart {
          limit           = 2
          grace           = "60s"
          ignore_warnings = false
        }
      }
    }

    task "promtail" {
      driver = "docker"

      env {
        HOSTNAME = "${attr.unique.hostname}"
      }
      template {
        data        = <<EOTC
positions:
  filename: /data/positions.yaml

server:
  log_level: debug

clients:
  - url: http://localhost:3100/loki/api/v1/push

scrape_configs:
- job_name: 'nomad-logs'
  consul_sd_configs:
    - server: 'consul.${var.domain}'
      scheme: 'https'
      refresh_interval: 1m
      token: "bb9aa9f2-0f11-ff92-7437-ad56174ac445"
  relabel_configs:
    - source_labels: [__meta_consul_node]
      target_label: __host__
    - source_labels: [__meta_consul_service_metadata_external_source]
      target_label: source
      regex: (.*)
      replacement: '$1'
    - source_labels: [__meta_consul_service_id]
      regex: '_nomad-task-([0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12})-.*'
      target_label:  'task_id'
      replacement: '$1'
    - source_labels: [__meta_consul_tags]
      regex: ',(app|monitoring),'
      target_label:  'group'
      replacement:   '$1'
    - source_labels: [__meta_consul_service]
      target_label: job
    - source_labels: ['__meta_consul_node']
      regex:         '(.*)'
      target_label:  'instance'
      replacement:   '$1'
    - source_labels: [__meta_consul_service_id]
      regex: '_nomad-task-([0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12})-.*'
      target_label:  '__path__'
      replacement: '/nomad/alloc/$1/alloc/logs/*std*.{?,??}'
EOTC
        destination = "/local/promtail.yml"
      }

      config {
        dns_servers = [var.dns_resolver_ipv4]
        image = "grafana/promtail:latest"
        ports = ["http"]
        args = [
          "-config.file=/local/promtail.yml",
          "-server.http-listen-port=${NOMAD_PORT_http}",
        ]
        volumes = [
          "/data/promtail:/data",
          "/opt/nomad/data/:/nomad/"
        ]
      }

      resources {
        cpu    = 50
        memory = 100
      }
    }
  }
}
