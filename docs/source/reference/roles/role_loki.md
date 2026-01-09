
```{include} ../../../../roles/loki/README.md
```

## Role defaults

``` yaml
loki_cluster_address: localhost
loki_url: 'http://{{ loki_cluster_address }}:3100'
loki_config_file: 'loki_config.yml.j2'
promtail_config_file: 'promtail_config.yml.j2'
promtail_sre_target_config: []
retention_deletes_enabled: "false"
retention_period: 0s
s3_enabled: false
s3_insecure: "false"
s3_sse_encryption: "true"
s3_bucketnames: ""
s3_endpoint: ""
s3_access_key: ""
s3_secret_key: ""
hs_loki_version: "2.7.5"
packages_list:
  - "loki={{ hs_loki_version }}"
  - "promtail={{ hs_loki_version }}"
loki_local_cache_dir: "{{ hs_workspace_root }}"
promtail_local_cache_dir: "{{ hs_workspace_root }}"
```
