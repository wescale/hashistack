# vault_pki_trust

```{admonition} Goal
:class: tip

TBD
Render and apply a terraform module for:
* setup a [pki engine](https://developer.hashicorp.com/vault/docs/secrets/pki)
* setup least privilege policy, role and initial token
```

----

```{admonition} Disclaimer
:class: note

This playbook and terraform module are provided _as-is_ for you to test
and hack around your own pki management strategy.
```

## Usage

* From an [instance management directory](/explanations/glossary).

```{code-block}
> ansible-playbook wescale.hashistack.vault_pki_bootstrap  \
>        -e hs_vault_pki_name=...                          \
>        -e hs_vault_pki_domain=...
```
## Parameters

* Name given to the [pki engine](https://developer.hashicorp.com/vault/docs/secrets/pki) you want to create.
```{code-block}
hs_vault_pki_name: ~
```

* Root domain that the pki engine will be allowed to issue certificates for.
```{code-block}
hs_vault_pki_domain: ~
```

