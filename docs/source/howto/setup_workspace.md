# Setup your non-Debian workspace

If you have a non-Debian system and still wish to test Hashistack, you are welcome.
Let's try to give you some hints to meet the prerequisites and avoid problems.

## CLI tooling

* bash: ...or zsh but only these two are supported by direnv.
* direnv: handles a lot of environment variables wiring and Python virtualenv management. Install is not enough, 
mind about [hooking it to your shell](https://direnv.net/docs/hook.html).
* curl: binary dependencies like terraform are downloaded via curl.
* unzip: binary dependencies like terraform are unachived via unzip.

## Python

* python3: >=3.9
* python3-dev: needed for some Python dependencies installation.
* python3-venv: needed to avoid spreading hashistack python dependencies all accross the system.
* python3-pip (aka pip3): needed for python depdencies installation.

## Ok, then...

If you match these requirements, you can go to the [](/tutorials/setup_workspace) tutorial __and skip
the step__:

```{code-block}
> make install-requirements
```
