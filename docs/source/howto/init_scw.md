# Setup Scaleway credentials

## Prerequisites

* Follow the [](/tutorials/setup_workspace.md) guide.

## Setup your Scaleway account

Go through these steps:

* [Open a Scaleway account](https://www.scaleway.com/en/docs/create-your-scaleway-account)
* [Retrieve your organization id](https://www.scaleway.com/en/docs/scaleway-organizations/#-Retrieving-your-Organization-ID)
* [Generate Scaleway API key](https://www.scaleway.com/en/docs/generate-api-keys)
* [Choose your deployment zone](https://registry.terraform.io/providers/scaleway/scaleway/latest/docs/guides/regions_and_zones)

## Configure your Scaleway account

At the workspace root, create or edit a ``.env.secrets`` file with this content:

```{code-block} 
:caption: .env.secrets
:linenos:
export SCW_DEFAULT_ORGANIZATION_ID="..."
export SCW_ACCESS_KEY="..."
export SCW_SECRET_KEY="..."
export SCW_DEFAULT_REGION="..."
export SCW_DEFAULT_ZONE="..."
```

Then run:

```
> direnv reload
```

## Check

You should find your credentials when running:

```
> env | grep SCW
```

```{admonition} Achievement Unlocked
:class: important

Your Scaleway credentials are available for the project tooling.
```
