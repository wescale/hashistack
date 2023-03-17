
```{include} ../../../roles/prometheus/README.md
```

## Role defaults

```
prometheus_version: 2.42.0
prometheus_config_file: 'prometheus.yml.j2'
prometheus_config_dir: /etc/prometheus
prometheus_db_dir: /var/lib/prometheus

prometheus_scrape_configs: []
