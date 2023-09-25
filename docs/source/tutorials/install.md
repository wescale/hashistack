# Install hashistack

## Prerequisites

* [Install Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)

## Install

```{code-block}
> ansible-galaxy collection install wescale.hashistack
```

## Update

The behavior of `ansible-galaxy` is to first check for any version presence, so an update
needs to be done with the force option (`-f`).

```{code-block}
> ansible-galaxy collection install -f wescale.hashistack
```

----

```{admonition} Ansible Galaxy
:class: important

We maintain an official [Ansible Galaxy](https://galaxy.ansible.com/wescale/hashistack) page.
```

