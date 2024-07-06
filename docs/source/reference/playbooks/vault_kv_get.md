# vault_kv_get

```{admonition} Goal
:class: tip

Interacts by API calls with a vault cluster to read data from a kv-v2 datastore.
```

## Usage

* Launch from a directory that contains inventory and variables of the deployed Vault cluster.

```{code-block}
> export VAULT_TOKEN="..."
> ansible-playbook wescale.hashistack.vault_kv_get  \
>        -e hs_vault_key_mount=...  \
>        -e hs_vault_key_name=...   \
```

```{admonition} Target vault url
:class: tip

The playbook reads the `hashistack` group vars to retrieve `hs_vault_external_url` for vault
url. Force the variable `hs_vault_external_url` with an extra var if you like to target a custom address.
```

## Parameters

The playbook targets by default the first host group `hashistack_masters` for coherent
var loading. If you decided to name your master group differently, you can override
this by setting `hs_masters_group` on extra var. This is only for variable loading,
no actual operation will occur on the hosts of the group.
```{code-block}
- hosts: "{{ hs_masters_group | default('hashistack_masters') }}[0]"
```
----

Mount point of the targeted kv-v2 backend engine.
```{code-block}
hs_vault_key_mount: 'kv-v2'
```
----

Name of the targeted key inside the kv-v2 backend.
```{code-block}
hs_vault_key_name: 'hs_demo/custom_kv'
```
----

Version number of the value to read.
```{code-block}
hs_vault_key_version: ~
```
----

Boolean flag to force display of the retrieved value.
```{code-block}
hs_vault_force_display: false
```

