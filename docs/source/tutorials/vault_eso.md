# Create a Vault backend for ESO

In this tutorial, we will connect a Kubernetes cluster to Vault for secret management using the 
External Secrets Operator. We will create a ClusterSecretStore with token authentication, 
configure Kubernetes RBAC so that namespaces have read-only access to their assigned secrets, 
and set up a Kubernetes CronJob to renew the Vault token. 

Along the way, we will create a Vault policy and token, sync secrets as an admin, and verify secure access.

## What you need

- A running Kubernetes cluster.
- External Secrets Operator installed (for example, in the `external-secrets` namespace).
- An existing Vault server, accessible from the cluster (for example, at `https://vault.example.com:8200`).
- Vault CLI installed on your local machine, with admin access to Vault.
- Kubernetes CLI (`kubectl`) with admin access.
- Vault's KV secrets engine (v2) enabled at the `secret/` path.

Now, create a dedicated namespace for credentials.

Run this command:

```
kubectl create namespace external-secrets-credentials
```

You will see output like this:

```
namespace/external-secrets-credentials created
```

## Create a Vault policy

First, create a policy file named `eso-readonly-policy.hcl` with this content:

```
path "secret/data/*" {
  capabilities = ["read", "list"]
}
```

Now, apply the policy in Vault.

Run this command:

```
vault policy write eso-readonly eso-readonly-policy.hcl
```

You will see output like this:

```
Success! Uploaded policy: eso-readonly
```

## Create a periodic Vault token

Now, create a renewable token attached to the policy.

Run this command:

```
vault token create \
  -policy=eso-readonly \
  -period=30d \
  -explicit-max-ttl=90d \
  -display-name="eso-cluster-token"
```

You will see output like this. Copy the `token` value (it starts with `hvs.` or `s.`).

```
Key                  Value
---                  -----
token                hvs.XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
token_accessor       XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
token_duration       720h
token_renewable      true
token_policies       ["eso-readonly"]
...
```

```{admonition} See also
:class: note
* [vault token create CLI options](https://developer.hashicorp.com/vault/docs/commands/token/create)
```

## Store the token in Kubernetes

Now, store the token in a Kubernetes Secret.

Run this command, replacing `<YOUR_TOKEN>` with the token value:

```
kubectl create secret generic vault-token \
  --namespace external-secrets-credentials \
  --from-literal=token=<YOUR_TOKEN>
```

You will see output like this:

```
secret/vault-token created
```

## Create the ClusterSecretStore

Create a file named `cluster-secret-store.yaml` with this content. Replace `https://vault.example.com:8200` with your Vault server URL.

```
apiVersion: external-secrets.io/v1beta1
kind: ClusterSecretStore
metadata:
  name: vault-cluster-store
spec:
  provider:
    vault:
      server: "https://vault.example.com:8200"
      path: "secret"
      version: "v2"
      auth:
        tokenSecretRef:
          name: vault-token
          key: token
          namespace: external-secrets-credentials
```

Now, apply it.

Run this command:

```
kubectl apply -f cluster-secret-store.yaml
```

You will see output like this:

```
clustersecretstore.external-secrets.io/vault-cluster-store created
```

Check that it is ready.

Run this command:

```
kubectl get clustersecretstore vault-cluster-store -o jsonpath='{.status.conditions[?(@.type=="Ready")].status}'
```

You will see:

```
True
```

If it shows `False`, run `kubectl describe clustersecretstore vault-cluster-store` to check for errors.

```{admonition} See also
:class: note
* [ClusterSecretStore CRD](https://external-secrets.io/main/api/clustersecretstore/)
```



## Set up Kubernetes RBAC for namespaces

Create a file named `namespace-developer-role.yaml` with this content:

```
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: namespace-developer
rules:
- apiGroups: [""]
  resources: ["secrets"]
  verbs: ["get", "list", "watch"]
- apiGroups: [""]
  resources: ["pods", "services", "configmaps"]
  verbs: ["create", "delete", "get", "list", "patch", "update", "watch"]
- apiGroups: ["apps"]
  resources: ["deployments", "replicasets", "statefulsets"]
  verbs: ["create", "delete", "get", "list", "patch", "update", "watch"]
```

Now, apply it.

Run this command:

```
kubectl apply -f namespace-developer-role.yaml
```

You will see output like this:

```
clusterrole.rbac.authorization.k8s.io/namespace-developer created
```

Now, create an example namespace.

Run this command:

```
kubectl create namespace my-app-ns
```

You will see:

```
namespace/my-app-ns created
```

Bind the role to a user in the namespace. Replace `dev-user` with a real user name.

Create a file named `role-binding.yaml` with this content:

```
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: developer-binding
  namespace: my-app-ns
subjects:
- kind: User
  name: dev-user
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: ClusterRole
  name: namespace-developer
  apiGroup: rbac.authorization.k8s.io
```

Apply it:

```
kubectl apply -f role-binding.yaml
```

You will see:

```
rolebinding.rbac.authorization.k8s.io/developer-binding created
```

Notice that this allows read-only access to secrets but no creation of ExternalSecret objects.

## Create a CronJob to renew the token

Create a ServiceAccount for the Job.

Run this command:

```
kubectl create serviceaccount token-renewer -n external-secrets-credentials
```

You will see:

```
serviceaccount/token-renewer created
```

No additional RBAC is needed since we are not updating the Secret—the renewal extends the existing token.

Now, create a file named `token-renew-cronjob.yaml` with this content. Replace `https://vault.example.com:8200` with your Vault URL.

```
apiVersion: batch/v1
kind: CronJob
metadata:
  name: vault-token-renewer
  namespace: external-secrets-credentials
spec:
  schedule: "0 */12 * * *"
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: renewer
            image: hashicorp/vault:1.15
            env:
            - name: VAULT_ADDR
              value: "https://vault.example.com:8200"
            - name: VAULT_TOKEN
              valueFrom:
                secretKeyRef:
                  name: vault-token
                  key: token
            command:
            - /bin/sh
            - -c
            - |
              vault token renew $VAULT_TOKEN
          restartPolicy: OnFailure
          serviceAccountName: token-renewer
```

```{admonition} See also
:class: note
* [vault token renew CLI options](https://developer.hashicorp.com/vault/docs/commands/token/renew)
```

Apply it:

```
kubectl apply -f token-renew-cronjob.yaml
```

You will see:

```
cronjob.batch/vault-token-renewer created
```

To test, run the Job manually.

Run this command:

```
kubectl create job --from=cronjob/vault-token-renewer test-renew -n external-secrets-credentials
```

Then check the pod logs.

Find the pod name with:

```
kubectl get pods -n external-secrets-credentials
```

Then:

```
kubectl logs <pod-name> -n external-secrets-credentials
```

You will see output like:

```
Success! Token renewed.
```

## Create and sync a secret as an admin

Now, create a secret in Vault.

Run this command:

```
vault kv put secret/my-app-ns/my-app-secret db_password=supersecure
```

You will see:

```
Success! Data written to: secret/my-app-ns/my-app-secret
```

Create a file named `external-secret.yaml` with this content:

```
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: my-app-external-secret
  namespace: my-app-ns
spec:
  refreshInterval: 1h
  secretStoreRef:
    name: vault-cluster-store
    kind: ClusterSecretStore
  target:
    name: my-app-secret
    creationPolicy: Owner
  data:
  - secretKey: db_password
    remoteRef:
      key: my-app-ns/my-app-secret
      property: db_password
```

Apply it:

```
kubectl apply -f external-secret.yaml
```

You will see:

```
externalsecret.external-secrets.io/my-app-external-secret created
```

Check the synced secret:

```
kubectl get secret my-app-secret -n my-app-ns -o jsonpath='{.data.db_password}' | base64 --decode
```

You will see:

```
supersecure
```

As a namespace user (switch context to dev-user if needed), you can get the secret, but trying to create one will fail.

You have set up secure, Vault-backed secret management in Kubernetes with automatic token renewal and controlled access.