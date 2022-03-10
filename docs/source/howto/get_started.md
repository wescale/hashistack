# Get started

```{admonition} Important
:class: tip

This guide is tailored for a [Debian](https://www.debian.org/) system. 
Feel free to contribute distribution-specific guidelines.
```
## Prerequisites

### Binary dependencies

* `git`
* `make`
* [`direnv`](https://direnv.net/docs/installation.html)

You can get these by running:

```
sudo apt-get update && sudo apt-get install git make direnv -y
```

### Configuration

* `direnv` should be [hooked to your shell](https://direnv.net/docs/hook.html)

## Setup workspace

* Run:

```{code} bash
git clone https://github.com/wescale/hashistack.git
cd hashistack/
make prepare-debian
direnv allow
make env
```

```{admonition} CONGRATULATIONS
:class: important

You are ready to work with the project.
```
