// Add prometheus datasource
resource "grafana_data_source" "prometheus" {
  uid  = "prometheus"
  type = "prometheus"
  name = "prometheus"
  url  = "http://localhost:9090"
}

// Create Infra folder
resource "grafana_folder" "infra" {
  title = "Infra"
}

// Create Infra Dashboard
resource "grafana_dashboard" "infra" {
  for_each = fileset(path.module, "files/dashboards/*.json")

  folder      = grafana_folder.infra.id
  config_json = file("${path.module}/${each.value}")
}