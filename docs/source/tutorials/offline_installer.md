# Install an air-gapped environment

## Goal

This tutorial will guide you through building a docker container with all dependencies
inside, for installing Hashistack in an air-gapped environment.

## Prerequisistes

* Follow the [Docker Installer](/howto/setup_with_docker_installer.md) guide.

* Docker on your deploy system  
* Debian 11 fresh install and up to date  
* DNS delegation  
* Wildcard certificate for subdomain  
* SSH key

## Steps

* Start container from hashistack directory:

```{code-block}
> docker run -it -h hs-offline --name hashistack-installer --mount type=bind,source="$(pwd)"/,target=/opt/hashistack/ hs-offline:latest bash
```

* Enable direnv:

```{code-block}
> direnv allow
```

* Create instance directory
```{code-block}
> make init_instance name=XXXX parent_domain=%sub.domain.tld% archi=mono
> cd inventories/hs_XXXX
```

* Update ssh file and test
```{code-block}
> vim ssh.cfg
> ansible all -m ping -v
```

* Upload all dependencies
```{code-block}
> ansible-playbook ../../playbooks/00_offline_prepare.yml
```

* Deploy
```{code-block}
> make stage_1 stage_2 stage_3 stage_4 ARGS="--skip-tags=online"
```
