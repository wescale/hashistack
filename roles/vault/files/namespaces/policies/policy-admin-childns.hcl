# Read system health check
path "sys/health"
{
  capabilities = ["read", "sudo"]
}

# List existing leases
path "sys/leases/*"
{
  capabilities = ["list"]
}

# Create and manage ACL policies broadly across Vault

# List existing policies
path "sys/policies/acl"
{
  capabilities = ["list"]
}

# Create and manage ACL policies
path "sys/policies/acl/*"
{
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# Enable and manage authentication methods broadly across Vault

# Manage auth methods broadly across Vault # NO READER
# path "auth/*"
# {
#   capabilities = ["create", "read", "update", "delete", "list", "sudo"]
# }

# Create, update, and delete auth methods # NO READER
# path "sys/auth/*"
# {
#   capabilities = ["create", "update", "delete", "sudo"]
# }

# List auth methods
path "sys/auth"
{
  capabilities = ["read"]
}

# Enable and manage the key/value secrets engine at `secret/` path

# List, create, update, and delete key/value secrets
path "secure-secrets/*"
{
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}
path "k8s-secrets/*"
{
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}


# Manage secrets engines
path "sys/mounts/*"
{
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# List existing secrets engines.
path "sys/mounts"
{
  capabilities = ["read"]
}

# Manage identity
path "identity/group*"
{
  capabilities = ["create", "read", "update",  "list"]
}

path "identity/lookup/group" {
  capabilities = ["read","list"]
}

path "identity/lookup/identity" {
  capabilities = ["read","list"]
}