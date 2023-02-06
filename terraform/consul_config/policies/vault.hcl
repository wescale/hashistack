service "vault" {
  policy = "write"
}

service_prefix "" {
  policy = "read"
}

agent_prefix "" {
  policy = "read"
}

node_prefix "" {
  policy = "read"
}
