
```{include} ../../../../roles/grafana/README.md
```

## Role defaults
* Grafana API endpoint exposure. Will be used from ansible controller to configure
via API.

``` yaml
hs_grafana_url: "https://{{ grafana_public_cluster_address }}"
```

* Enable/disable usage of custom CA file for Grafana API certificate validation.

``` yaml
hs_grafana_use_custom_ca: false
```

* Ansible controler path to custom CA file for API certificate validation.

``` yaml
hs_grafana_custom_ca_cert: "{{ hs_workspace_secrets_dir }}/ca.cert.pem"
```

* Expected Grafana version to install.

``` yaml
hs_grafana_version: "10.2.1"
```

* Ansible controler directory path where the role should
copy terraform modules for configuration.

``` yaml
hs_grafana_tf_work_dir: >-
  {{
    hs_workspace_tf_modules_dir
    | default(lookup('env', 'PWD') + '/terraform')
  }}
grafana_local_cache_dir: "{{ hs_workspace_root }}"
```
