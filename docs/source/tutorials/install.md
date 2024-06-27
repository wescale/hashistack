# Install hashistack

## System requirements

* Python3 (we recommend `>= 3.11.2`)
* Pip3

```{admonition} Virtualenv
:class: important

Mind about virtualenv-ing your working directory to avoid spreading Python dependencies system-wide.
We advise the use of [direnv](../howto/direnv.md) but feel free.
```

## Runtime dependencies

### Python

Have these python packages installed:

```{code-block}
> pip install ansible-core netaddr passlib dnspython
```

### Terraform

Have [Terraform installed](https://developer.hashicorp.com/terraform/install) (tested against v1.7.X).

## Hashistack collection install

```{code-block}
> ansible-galaxy collection install -f wescale.hashistack
```

```{admonition} Good to know
:class: note
`ansible-galaxy` checks for any collection version occurence. Updating
needs to be forced with the `-f` flag.
```

