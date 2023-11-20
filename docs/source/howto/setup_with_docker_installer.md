# Setup workspace (docker)

If you have a non-Debian system and still wish to test Hashistack, you are welcome.
Or want to build an docker image for offline installation.

## Docker-installer

You can use docker/Dockerfile-installer to build a Debian image with all the things needed to deploy the Hashistack.

```{code-block}
> docker build --platform=linux/amd64 --target hs-installer -t hs-installer:latest -f docker/Dockerfile .
```

## Offline installer

Build the previous docker image then build this final image contain all packages needed for offline installation.  

```{code-block}
> docker build --platform=linux/amd64 -t hs-offline:latest -f docker/Dockerfile . 
```

## Running

Run a container and follow the installation guide to deploy the Hashistack.  

```{code-block}
> docker run -it -h {{ hs-installer || hs-offline }} {{ hs-installer || hs-offline }}:latest bash
```

Also you can mount inventories path to local path to save precious files.  

```{code-block}
> docker run -it -h {{ hs-installer || hs-offline }} --name hashistack-installer --mount type=bind,source="$(pwd)"/inventories,target=/opt/hashistack/inventories {{ hs-installer || hs-offline }}:latest bash
```
