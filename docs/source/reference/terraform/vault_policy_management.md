# vault\_policy\_management

([Module sources](https://github.com/wescale/hashistack/tree/main/terraform/vault_policy_management))

```{admonition} Purpose
:class: important

This module is provided as guiding sample for implementing your own policy management.
It creates an ACL policy, with associated tokens, to create other policies, while
excplicitly denying any modification on a list of other policies.
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
| vault | 3.21.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| kv\_v2\_mount\_point | n/a | `string` | n/a | yes |
| policy\_management\_token\_renew\_increment | n/a | `number` | `86400` | no |
| policy\_management\_token\_renew\_min\_lease | n/a | `number` | `43200` | no |
| policy\_management\_token\_renewable | n/a | `bool` | `true` | no |
| policy\_management\_token\_ttl | n/a | `string` | `"24h"` | no |

## Outputs

| Name | Description |
|------|-------------|
| policy\_management\_token | n/a |
