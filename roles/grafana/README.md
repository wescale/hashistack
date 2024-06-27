# grafana

Manages [Grafana](https://grafana.com/grafana/) deployment.

```{admonition} Sensitive data
:class: warning

On first application, the role will generate the default password for `admin` user and store
it on ansible controller at:

* `{{ hs_workspace_secrets_dir }}//grafana.pass.yml`
```

