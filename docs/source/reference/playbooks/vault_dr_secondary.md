# vault_dr_secondary
        
```{admonition} Goal
:class: tip

Interacts by API calls with 2 clusters that can contact each other to enable Disaster Recovery feature 
(Vault entreprise only).
```

## Usage

* Ideally launched from a directory that contains inventory and variables of the deployed primary Vault cluster.

```{code-block}
> ansible-playbook wescale.hashistack.vault_dr_secondary  \
>        -e hs_secondary_api_url=...    \
>        -e hs_secondary_api_token=...
```

## Variables

The playbook by default targets the host group `hashistack_masters`. If you
decided to name your master group differently, you can override this by setting
`hs_masters_group`. This is only for variable loading, no actual operation will occur
on the hosts of the group.
```{code-block}
- hosts: "{{ hs_vault_inventory_masters_group | default('hashistack_masters') }}"
```
----

The secondary cluster masters API url.
```{code-block}
hs_secondary_api_url: ~
```
----

The secondary cluster masters API vault token.
```{code-block}
hs_secondary_api_token: ~
```
