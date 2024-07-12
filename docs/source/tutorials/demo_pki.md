# Vault private PKI

## Goals

* Create a PKI engine for Vault-signed certificate creation.
* Make hosts trust the PKI root certificate ancestor.
* Delegate to a host the capability to issue cetificates.

## Prerequisites

* Follow the [Install Vault](/tutorials/demo_vault) tutorial.
* Name your PKI engine. ('alpha' in our code sample).
* Choose the domain managed. ('alpha.internal' in our code sample).

## Steps

```{code-block}
:caption: Create the PKI engine in Vault
ansible-playbook wescale.hashistack.vault_pki_bootstrap \
    -e hs_vault_pki_name=alpha                          \
    -e hs_vault_pki_domain=alpha.internal
```

```{code-block}
:caption: Distribute trust of the root certificate
ansible-playbook wescale.hashistack.vault_pki_trust     \
    -e hs_vault_pki_name=alpha                          \
    -e scope=<group_form_inventory>
```

```{code-block}
:caption: Give a host the capability to issue certificates
ansible-playbook wescale.hashistack.vault_pki_enroll \
    -e hs_vault_pki_name=alpha                       \
    -e scope=epic-sre
```

* __From the target host__, as root, you now can run:

```{code-block}
:caption: Create a valid cetificate at /etc/ssl/private/<any subdomain>.alpha.internal.*
ssh -F ssh.cfg epic-sre
ansible-refresh-alpha-cert -e cert_domain=<any subdomain>.alpha.internal
```

```{admonition} Achievement Unlocked
:class: important

You have created a private PKI and made a host capable of issuing certificates.
```


