# Allow all on secret ${realm_name} path
path "${kv_v2_mount_point}/data/${realm_name}/*" {
  capabilities = ["create", "update", "patch", "read", "delete"]
}

# webui list secret ${realm_name} path
path "${kv_v2_mount_point}/metadata/${realm_name}/*" {
  capabilities = ["read", "list"]
}

path "${kv_v2_mount_point}/metadata/${realm_name}" {
  capabilities = ["read", "list"]
}

path "auth/token/create" {
  capabilities = ["create", "read", "update", "list"]
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

