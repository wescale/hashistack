# Setup workspace

```{admonition} Important
:class: tip

This guide is tailored for a [Debian Stable](https://www.debian.org/) system. If you have a diferent
system, have a look at hints in [](/howto/setup_workspace).
```

## Steps

* As __super-user__, run:

```{code-block}
> apt-get update && apt-get install git make sudo -y
```

* As __standard user with sudo capability on apt-get__, run: 

```{code-block}
> git clone https://github.com/wescale/hashistack.git && cd hashistack
> make install-requirements
```

* Then run:

```{code-block}
> source ~/.bashrc && direnv allow
> make prepare
```

## Validation

* Run the following command:

```
> which ansible
```

The outputs should give you a path like `/absolute/path/to/your/clone/.direnv/...`

----

```{admonition} CONGRATULATIONS
:class: important

You are ready to work with the project.
```

