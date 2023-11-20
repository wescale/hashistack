# Manage Vault policies

```{admonition} Use case
:class: note

This describes some hints about managing vault policies and rights in order to
get efficient with it beyond the proof-of-concept state.
```

## Pre-deployment: Select your add-ons

Hashistack aims at deploying a fullstack platform, but you may want to only use
it for Vault deployment. In this case, the automated policy generation included
in the `vault` role might be useless.

```{admonition} See also
:class: hint

* [Add-ons configuration in vault role](../reference/role_vault.md#add-ons)
* [`roles/vault/files/terraform`](https://github.com/wescale/hashistack/tree/main/roles/vault/files):
the terraform sources of the ansible vault role add-ons.
```

## Some strategies

### Central repository for every policies

coming soon

### Delegation scopes

coming soon



```{admonition} Hints
:class: warning

Defining the _Right Way_ of organizing and managing Vault policies is way beyond the scope
of this project. It would also limit your creativity or question your needs as a user, which
is not the intention.

We encourage you to:

* design your own management process in collaboration with your users
* review the potential abuses that can arise.
* once done, persist it in a clear [Architecture Decision Record](https://adr.github.io/madr/#overview)
* Review and amend it as often as needed.

Security is a process, it has no finish line.
```
