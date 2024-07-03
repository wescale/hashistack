# Auto-encrypt sensitive data

```{admonition} Tips
:class: important

If you want role-generated sensitive content automatically encrypted:

* set the env var `ANSIBLE_VAULT_PASSWORD_FILE` on the ansible controler before running
the role.

It will be used to force a `ansible-vault encrypt` on the generated files upon local write.
```

