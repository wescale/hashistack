
# vault_tf_policies_samples

```{admonition} Goal
:class: tip

Render the terraform samples designed for policy management, for you to test and hack around
your own policy management strategy.
```

## Usage

* Launch from a hashistack managed directory.

```{code-block}
> ansible-playbook wescale.hashistack.vault_tf_policies_samples
```

It will create/overwrite:

* [`${PWD}/terraform/vault_policy_management`](../terraform/vault_policy_management.md)
* [`${PWD}/terraform/vault_kv_realm`](../terraform/vault_kv_realm.md)

