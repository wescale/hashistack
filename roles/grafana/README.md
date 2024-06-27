# grafana

Manages [Grafana](https://grafana.com/grafana/) deployment.

```{admonition} Sensitive data
:class: warning

On first application, the role will generate the default password for `admin` user and store
it on ansible controller at:

* `{{ hs_workspace_secrets_dir }}//root_grafana.yml`
```

```{admonition} Tips
:class: important

If you want this sensitive content automatically encrypted:

* set the env var `ANSIBLE_VAULT_PASSWORD_FILE` on the ansible controler before running
the role.

It will be used to force a `ansible-vault encrypt` on the file.
```

