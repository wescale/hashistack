
```{include} ../../../roles/loki/README.md
```

## Role defaults

```
loki_cluster_address: localhost
loki_url: 'http://{{ loki_cluster_address }}:3100'
loki_config_file: 'loki_config.yml.j2'
promtail_config_file: 'promtail_config.yml.j2'
retention_deletes_enabled: "false"
retention_period: 0s
s3_enabled: false
s3_insecure: "false"
s3_sse_encryption: "true"

packages_list:
  - loki
  - promtail

