service "vault" {
  policy = "write"
}

service "vault-sidecar-proxy" {
  policy = "write"
}

service_prefix "" {
  policy = "read"
}

node_prefix "" {
  policy = "read"
}
