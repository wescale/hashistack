service "vault" {
  policy = "write"
}

service "vault-sidecar-proxy" {
  policy = "write"
}

agent_prefix "" {
  policy = "read"
}


service_prefix "" {
  policy = "read"
}

node_prefix "" {
  policy = "read"
}
