
```{include} ../../../../roles/alloy/README.md
```

## Role defaults
* Loki endpoint to forward metrics to.

``` yaml
hs_alloy_loki_write_url: "http://grafana.{{ hs_public_domain }}:3100"
```

* Prometheus endpoint to forward metrics to.

``` yaml
hs_alloy_prometheus_write_url: "http://grafana.{{ hs_public_domain }}:9090"
alloy_version: "1.3.1"
alloy_local_cache_dir: "{{ hs_workspace_root }}"
```
