# Allow global policy management
path "sys/policies/acl/*" {
      capabilities = ["create", "read", "update", "list"]
}

# Explicit deny to restrict the delegation perimeter
path "sys/policies/acl/default" {
  capabilities = ["deny"]
}

path "sys/policies/acl/nomad_job_registry_credentials" {
  capabilities = ["deny"]
}

path "sys/policies/acl/nomad_server" {
  capabilities = ["deny"]
}

path "sys/policies/acl/telemetry" {
  capabilities = ["deny"]
}

path  "sys/policies/acl/consul_service_mesh" {
  capabilities = ["deny"]
}

