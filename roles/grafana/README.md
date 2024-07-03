# grafana

```{admonition} Purpose
:class: tip

* Install [Grafana](https://grafana.com/grafana/).
```

```{admonition} Sensitive data
:class: warning

Generates default password for `admin` user and stores it on ansible controller at:

* `{{ hs_workspace_secrets_dir }}//root_grafana.yml`

See also: [How-to auto-encrypt sensitive data](/howto/auto_encrypt)
```

