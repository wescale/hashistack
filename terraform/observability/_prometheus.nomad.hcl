variable "datacenter" {}
variable "dns_resolver_ipv4" {}
variable "domain" {}
variable "subdomain" {}

job "prometheus" {
  datacenters = [var.datacenter]

  type        = "service"

  group "prometheus" {
    count = 1

    network {
      mode = "bridge"
      dns {
        servers = [var.dns_resolver_ipv4]
      }
      port "http" {
        static = 9090
      }
    }
    
    service {
      name = "prometheus"
      port = "http"
      tags = ["monitoring","prometheus"]
      connect {
        sidecar_service {}
      }

      check {
        name     = "Prometheus HTTP"
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

    restart {
      attempts = 3
      delay    = "20s"
      mode     = "delay"
    }

    task "prometheus" {
      driver = "docker"

      template {
        data        = <<EOTC
global:
  scrape_interval: 15s
scrape_configs:
  - job_name: 'self'
    consul_sd_configs:
      - server: 'consul.${var.domain}'
        scheme: 'https'
        token: '13dd71cb-86c4-50c8-5397-6b6801f5f483'
    relabel_configs:
      - source_labels: [__meta_consul_service_metadata_external_source]
        target_label: source
        regex: '(.*)'
        replacement: '$1'
      - source_labels: [__meta_consul_service_id]
        regex: '_nomad-task-([0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12})-.*'
        target_label:  'task_id'
        replacement: '$1'
      - source_labels: [__meta_consul_tags]
        regex: '.*,prometheus,.*'
        action: keep
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
EOTC
        destination = "/local/prometheus.yml"
      }
      config {
        image = "prom/prometheus:latest"
        ports = ["http"]
        args = [
          "--config.file=/local/prometheus.yml",
          "--web.enable-admin-api"
        ]
      }

      resources {
        cpu    = 200
        memory = 200
      }

    }
  }
}
