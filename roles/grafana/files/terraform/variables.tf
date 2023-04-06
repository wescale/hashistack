variable "grafana_url" {
  type = string
  description = "Set Grafana base url"
}

variable "grafana_auth" {
  type = string
  description = "Set Grafana auth;  basic auth username:password or API key"
}

variable "grafana_ca_cert_file" {
  type    = string
  default = null
}

