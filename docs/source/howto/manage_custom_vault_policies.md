# Manage your own Vault policies

```{admonition} Use case
:class: note

Hashistack aims at deploying a fullstack platform, but you may want to only use
it for Vault deployment. In this case, the automated policy generation included
in the `vault` role might be useless.
```

## Disable Hashistack's Vault policy install

* Before Vault install, add this variable to your `hashistack` variable namespace:

```{code-block}
> hs_vault_enable_default_policies: false
```

## Manage Vault policies by yourself

Once your cluster is up and unsealed, you are free top manage policies and token by yourself.
If you need guidance, you should have a look in the code at:

* `roles/vault/files/terraform`: which contains a Terraform stackl for policies management
* `roles/vault/tasks/_tf_configure.yml`: which contains Ansible tasks for handling the
above stack.
