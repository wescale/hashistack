# Install hashistack

## Prerequisites

* [Install Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)

## Command Line 

```{code-block}
> ansible-galaxy collection install -f wescale.hashistack
```
```{admonition} Good to know
:class: note
The behavior of `ansible-galaxy` is to first check for any version presence, so an update
needs to be done with the force option (`-f`).
```

## Requirement file

You can also add it to the `requirements.yml` file of any project like this:

```{code-block}

---
collections:
  - name: wescale.hashistack
# Optional, but advised in general, to pin the version that should be installed.
    version: "1.13.13"
````

Once done, you install/update by launching:

```{code-block}
> ansible-galaxy collection install -fr requirements.yml
```

----

```{admonition} Ansible Galaxy
:class: important

We maintain an official [Ansible Galaxy](https://galaxy.ansible.com/wescale/hashistack) page.
```

