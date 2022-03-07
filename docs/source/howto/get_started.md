# Get started

## Prerequisites

### Binary dependencies

* `git`
* `make`
* [`direnv`](https://direnv.net/docs/installation.html)

### Configuration

* `direnv` should be [hooked to your shell](https://direnv.net/docs/hook.html)

## Setup workspace

* Run:

```{code} bash
git clone https://github.com/wescale/hashistack.git
cd hashistack/
make prepare_debian
direnv allow
make env
```

```{admonition} CONGRATULATIONS
:class: important

You are ready to work with the project.
```
