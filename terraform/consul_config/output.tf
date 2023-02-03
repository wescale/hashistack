
data "consul_acl_token_secret_id" "server" {
  accessor_id = consul_acl_token.nomad_server.accessor_id
}

data "consul_acl_token_secret_id" "client" {
  accessor_id = consul_acl_token.nomad_client.accessor_id
}

data "consul_acl_token_secret_id" "promtail" {
  accessor_id = consul_acl_token.promtail.accessor_id
}

data "consul_acl_token_secret_id" "minion" {
  accessor_id = consul_acl_token.minion_auto_encrypt_token.accessor_id
}

data "consul_acl_token_secret_id" "prometheus" {
  accessor_id = consul_acl_token.prometheus.accessor_id
}

data "consul_acl_token_secret_id" "telemetry" {
  accessor_id = consul_acl_token.telemetry.accessor_id
}

output "consul_acl_minion_token" {
  value     = data.consul_acl_token_secret_id.minion.secret_id
  sensitive = true
}


output "consul_acl_nomad_server_token" {
  value     = data.consul_acl_token_secret_id.server.secret_id
  sensitive = true
}

output "consul_acl_nomad_client_token" {
  value     = data.consul_acl_token_secret_id.client.secret_id
  sensitive = true
}

output "consul_acl_promtail_token" {
  value     = data.consul_acl_token_secret_id.promtail.secret_id
  sensitive = true
}

output "consul_acl_prometheus_token" {
  value     = data.consul_acl_token_secret_id.prometheus.secret_id
  sensitive = true
}

output "consul_acl_telemetry_token" {
  value     = data.consul_acl_token_secret_id.telemetry.secret_id
  sensitive = true
}
