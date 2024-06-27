# observability

```{admonition} Goal
:class: tip

Installs metric and log collectors, storage and visualization tooling.
```

## Usage

```{code-block}
> ansible-playbook wescale.hashistack.observability
```

## Effect

### On `hashistack_sre` host group

* Install roles:
    * `loki`
    * `prometheus`
    * `grafana`
* Configures grafana service with:
    * Datasources connected to local loki and prometheus instances
    * Dashboards for Vault/Consul/Nomad monitoring
    * Dashboards for hosts monitoring

### On `hashistack` host group

* Install roles:
    * `alloy`
* Configures alloy service to:
    * Collect and push host metrics to `hashistack_sre` prometheus instance
    * Collect and push journald logs to `hashistack_sre` loki instance
    * If vault service is detected: collect and push vault metrics to `hashistack_sre` prometheus instance

## Noticeable tags

* `-t grafana` will only apply grafana role on `hashistack_sre`
* `-t loki` will only apply loki role on `hashistack_sre`
* `-t prometheus` will only apply prometheus role on `hashistack_sre`
* `-t alloy` will apply alloy role on `hashistack`
