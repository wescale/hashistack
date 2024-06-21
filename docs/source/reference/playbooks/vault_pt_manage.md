# vault_pt_manage

```{admonition} Goal
:class: tip

Create a single policy+token couple on the target vault instance. By default, creates and links
an admin policy.
```

## Usage

* From an [instance management directory](/explanations/glossary).

```{code-block}
> ansible-playbook wescale.hashistack.vault_pt_manage  \
>        -e hs_vault_pt_name=...
```

```{admonition} Target vault url
:class: tip

The playbook reads the `hashistack` group vars to retrieve `hs_vault_external_url` for vault
url. Force the variable `hs_vault_external_url` with an extra var if you like to target a custom address.
```

## Variables

Anchor name for policy and token creation.
```{code-block}
hs_vault_pt_name: ""
```
----

If you want to override the default admin policy linked to the token, set full path
to your own policy file.
```{code-block}
hs_vault_pt_policy_path: '<absolute path to hcl vault policy>'
```

## Outputs

Terraform code applied to vault will be rendered at:
* `terraform/vault_pt_{{ hs_vault_pt_name }}`

Token value will be rendered at:
* `group_vars/hashistack/secrets/vault_pt_{{ hs_vault_pt_name }}.yml`

