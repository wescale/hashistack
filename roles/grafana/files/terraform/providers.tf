terraform {
  required_providers {
    grafana = {
      source = "grafana/grafana"
      version = "1.35.0"
    }
  }
}

provider "grafana" {
  url  = var.grafana_url
  auth = var.grafana_auth
}
