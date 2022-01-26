
data "consul_acl_token_secret_id" "server" {
    accessor_id = consul_acl_token.nomad_server.accessor_id
}

data "consul_acl_token_secret_id" "client" {
    accessor_id = consul_acl_token.nomad_client.accessor_id
}


output "consul_acl_nomad_server_token" {
  value = data.consul_acl_token_secret_id.server.secret_id
  sensitive = true
}

output "consul_acl_nomad_client_token" {
  value = data.consul_acl_token_secret_id.client.secret_id
  sensitive = true
}
