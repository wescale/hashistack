# List existing leases
path "sys/leases/*" {
  capabilities = ["list","sudo"]
}

# Create and manage ACL policies broadly across Vault

# List existing policies
path "sys/policies/acl" {
  capabilities = ["list"]
}

# Create and manage ACL policies
path "sys/policies/acl/admin" {
  capabilities = ["deny"]
}

# Create and manage ACL policies
path "sys/policies/acl/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
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
path "sys/mounts/*" {
  capabilities = ["read", "list"]
}

# List existing secrets engines.
path "sys/mounts" {
  capabilities = ["read", "list"]
}

# Manage identity
path "identity/group*" {
  capabilities = ["create", "read", "update",  "list"]
}

path "identity/lookup/group" {
  capabilities = ["read","list"]
}

path "identity/lookup/identity" {
  capabilities = ["read","list"]
}