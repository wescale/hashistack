
```{include} ../../../roles/grafana/README.md
```

## Role defaults


```
tf_module_name: "grafana"
tf_action: apply

packages_list:
  - grafana
grafana_url: "https://{{ grafana_public_cluster_address }}"
