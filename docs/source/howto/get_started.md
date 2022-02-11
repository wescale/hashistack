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
git clone https://gitlab.com/rtnp/galaxie-clans.git
cd galaxie-clans/
make prepare-debian
direnv allow
make env
```

> You are ready to work with the project.
