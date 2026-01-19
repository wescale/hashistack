# vault\_kv\_realm

([Module sources](https://github.com/wescale/hashistack/tree/main/terraform/vault_kv_realm))

```{admonition} Purpose
:class: important

This module is provided as guiding sample for implementing your own delegation.
It creates 2 policies with associated tokens tied to a kv-v2 mount point:

* an `administrator` one, with read-write access to all subpaths beginning with the ``realm_name`` variable
* a `user` one, with read-only access to the same perimeter.
```

## Authentication

Provide your cluster address and token as environment variables.

```{code-block}
export VAULT_ADDR="..."
export VAULT_TOKEN="..."
```

## Providers

| Name | Version |
|------|---------|
| vault | 5.6.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| kv\_v2\_mount\_point | n/a | `string` | n/a | yes |
| realm\_name | n/a | `string` | n/a | yes |
| admin\_token\_renew\_increment | n/a | `number` | `86400` | no |
| admin\_token\_renew\_min\_lease | n/a | `number` | `43200` | no |
| admin\_token\_renewable | n/a | `bool` | `true` | no |
| admin\_token\_ttl | n/a | `string` | `"24h"` | no |
| user\_token\_renew\_increment | n/a | `number` | `86400` | no |
| user\_token\_renew\_min\_lease | n/a | `number` | `43200` | no |
| user\_token\_renewable | n/a | `bool` | `true` | no |
| user\_token\_ttl | n/a | `string` | `"24h"` | no |

## Outputs

| Name | Description |
|------|-------------|
| realm\_admin\_token | kv-realm administrator token (rw) |
| realm\_user\_token | kv-realm user token (ro) |
