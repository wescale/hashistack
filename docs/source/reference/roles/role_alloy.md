
```{include} ../../../../roles/alloy/README.md
```

## Role defaults

* Loki endpoint to forward metrics to.
```
hs_alloy_loki_write_url: "http://grafana.{{ hs_public_domain }}:3100"

```
* Prometheus endpoint to forward metrics to.
```
hs_alloy_prometheus_write_url: "http://grafana.{{ hs_public_domain }}:9090"

