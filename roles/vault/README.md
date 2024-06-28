# vault

```{admonition} Purpose
:class: tip

* Install [Vault](https://developer.hashicorp.com/vault/docs).
* Initialize the service
* Unseal
* Setup the needed policies for Consul, Nomad and telemetry integration.
```

```{admonition} Sensitive data
:class: warning

Stores unseal key shares on ansible controller at:

* `{{ hs_workspace_secrets_dir }}/root_vault.yml`
```


