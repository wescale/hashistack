#
# Allow global policy management with a known prefix.
#
path "sys/policies/acl/kv_realm_*" {
      capabilities = ["create", "read", "update", "list", "delete"]
}
#
# WARN: not sure of the least privilege here
#
path "auth/token/create" {
  capabilities = ["create", "update", "sudo"]
}
#
# WARN: not sure of the least privilege here
#
path "auth/token/lookup-accessor" {
      capabilities = ["create", "read", "update", "list"]
}
#
# WARN: not sure of the least privilege here
#
path "auth/token/revoke-accessor" {
      capabilities = ["create", "read", "update", "list"]
}
#
# ----- EXPLICIT DENIES
#
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

# ----- PERMISSIONS THAT SHOULD BE INCLUDED IN CHILDREN POLICIES

path "${kv_v2_mount_point}/*" {
  capabilities = ["create", "update", "patch", "read", "delete"]
}

# Allow tokens to look up their own properties
path "auth/token/lookup-self" {
  capabilities = ["read"]
}

# Allow tokens to renew themselves
path "auth/token/renew-self" {
  capabilities = ["update"]
}

# Allow tokens to revoke themselves
path "auth/token/revoke-self" {
  capabilities = ["update"]
}

