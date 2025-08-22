# Read system health check
path "sys/health" {
  capabilities = ["read", "sudo"]
}

# Create and manage ACL policies broadly across Vault

# List existing policies
path "sys/policies/acl" {
  capabilities = ["list"]
}

# Create and manage ACL policies
path "sys/policies/acl/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# Enable and manage authentication methods broadly across Vault
# Allow managing leases
path "sys/leases/*" {
  capabilities = ["read", "update", "list"]
}
 

# Manage auth methods broadly across Vault
path "auth/*" {
  capabilities = [ "read", "list", "sudo"]
}

# Manage auth methods broadly across Vault
path "auth/k8s-*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}
# Manage auth methods broadly across Vault
path "auth/vm-approle*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}
# Manage auth methods broadly across Vault
path "auth/ci-approle*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}
# List auth methods
path "sys/auth" {
  capabilities = ["read"]
}

# Manage secrets engines
path "sys/mounts/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# List existing secrets engines.
path "sys/mounts" {
  capabilities = ["read"]
}

# Manage identity
path "identity/entity*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "identity/group*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "identity/lookup/group" {
  capabilities = ["read","list"]
}

path "identity/lookup/identity" {
  capabilities = ["read","list"]
}

# Manage K8S
path "transit-k8s*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

# Manage secrets/config
path "secure-secrets/config*" {
  capabilities = ["create", "read", "update", "list"]
}
path "k8s-secrets/config*" {
  capabilities = ["create", "read", "update", "list"]
}
