# Using Vault KV V2 Secrets with Docker Compose

This tutorial explains how to securely consume secrets stored in HashiCorp Vault Key-Value (KV) 
version 2 engine within a Docker Compose environment.

## As Vault Operators

Before the application can consume secrets, the Vault team must prepare the secret engine, 
the secret itself, and the access permissions.

### Store a kvv2 secret

Assuming the KV V2 engine is enabled at the path `secret/`, use the following command to store a secret:

```bash
vault kv put secret/my-application/config \
    api_key="secret-api-token-value" \
    db_password="very-secure-password"
```

To verify the secret was created:

```bash
vault kv get secret/my-application/config
```

### Create a read-only policy

Create a policy file named `my-app-policy.hcl` that grants read access specifically to this 
secret path. Note that for KV V2, the policy must target the `data/` subpath.

```hcl
# Access for KV V2
path "secret/data/my-application/config" {
  capabilities = ["read"]
}
```

Write the policy to Vault:

```bash
vault policy write my-app-read-policy my-app-policy.hcl
```

### Generate a service token

Generate a token for the application to use. It is recommended to use a periodic token or a 
token with a TTL that fits your deployment cycle.

```bash
vault token create -policy="my-app-read-policy" -period="24h" -display-name="docker-compose-app"
```

**Important:** Copy the `token` value (e.g., `hvs.CAES...`) and provide it securely to the application team.

---

## As Apps operators

Once you have the Vault address and a token, you can configure your Docker Compose setup to retrieve secrets.

### Option 1: Direct env vars

If your application or a sidecar can natively read from Vault, you can pass the configuration via environment variables.

In your `.env` file (ensure this file is NOT committed to version control):

```env
VAULT_ADDR=https://vault.example.com:8200
VAULT_TOKEN=hvs.your-app-token-here
```

In your `docker-compose.yml`:

```yaml
services:
  my-app:
    image: my-app-image:latest
    environment:
      - VAULT_ADDR=${VAULT_ADDR}
      - VAULT_TOKEN=${VAULT_TOKEN}
      - SECRET_PATH=secret/data/my-application/config
```

### Option 2: Pre-fetching via shell script

Most applications expect secrets to be present in environment variables or files at startup. 
You can use a wrapper script to fetch secrets from Vault before starting your main process.

#### Entrypoint script

```bash
#!/bin/sh
set -e

# Fetch secrets from Vault using curl and jq
# Note: KV V2 returns data nested under .data.data
VAULT_RESPONSE=$(curl -s -H "X-Vault-Token: $VAULT_TOKEN" "$VAULT_ADDR/v1/secret/data/my-application/config")

# Export values as environment variables
export API_KEY=$(echo $VAULT_RESPONSE | jq -r '.data.data.api_key')
export DB_PASSWORD=$(echo $VAULT_RESPONSE | jq -r '.data.data.db_password')

# Execute the main command
exec "$@"
```

Ensure the script is executable: `chmod +x entrypoint.sh`.

#### Docker compose config

Update your `docker-compose.yml` to use this script. You'll need `curl` and `jq` installed in your image.

```yaml
services:
  my-app:
    image: my-app-with-tools:latest
    volumes:
      - ./entrypoint.sh:/entrypoint.sh
    entrypoint: ["/entrypoint.sh"]
    command: ["npm", "start"]
    environment:
      - VAULT_ADDR=https://vault.example.com:8200
      - VAULT_TOKEN=${VAULT_TOKEN}
```

This approach ensures that your application never "sees" the Vault token directly if it doesn't need to, 
and it receives the actual secrets it needs to function.
