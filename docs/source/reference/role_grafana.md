
```{include} ../../../roles/grafana/README.md
```

## Variables


```
tf_module_name: "grafana"
tf_action: apply

grafana_url: "https://{{ grafana_public_cluster_address }}"

hs_grafana_version: "10.2.1"
hs_grafana_use_custom_ca: false
hs_grafana_custom_ca_cert: "{{ hs_workspace_secrets_dir }}/ca.cert.pem"

packages_list:
  - "grafana={{ hs_grafana_version }}"
