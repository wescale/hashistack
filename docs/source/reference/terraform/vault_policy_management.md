# vault\_policy\_management

([Module sources](https://github.com/wescale/hashistack/tree/main/terraform/vault_policy_management))

```{admonition} Leading practice
:class: important

This module is produced as guiding sample for implementing your own policy management.
It creates an ACL policy, with associated tokens, to create other policies, while
excplicitly denying any modification on a list of other policies.
```

## Providers

| Name | Version |
|------|---------|
| vault | 3.21.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| policy\_management\_token\_renew\_increment | n/a | `number` | `86400` | no |
| policy\_management\_token\_renew\_min\_lease | n/a | `number` | `43200` | no |
| policy\_management\_token\_renewable | n/a | `bool` | `true` | no |
| policy\_management\_token\_ttl | n/a | `string` | `"24h"` | no |

## Outputs

| Name | Description |
|------|-------------|
| policy\_management\_token | n/a |
