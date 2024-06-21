# Setup Scaleway credentials

## Setup your Scaleway account

Go through these steps:

* [Open a Scaleway account](https://www.scaleway.com/en/docs/create-your-scaleway-account)
* [Retrieve your organization id](https://www.scaleway.com/en/docs/scaleway-organizations/#-Retrieving-your-Organization-ID)
* [Generate Scaleway API key](https://www.scaleway.com/en/docs/generate-api-keys)
* [Choose your deployment zone](https://www.scaleway.com/en/docs/compute/instances/concepts#availability-zone)

## Configure your Scaleway account

At the workspace root, create or edit a ``.env.secrets`` file with this content:

```{code-block} 
:caption: .env.secrets
:linenos:
export SCW_DEFAULT_ORGANIZATION_ID="..."
export SCW_DEFAULT_PROJECT_ID="..."
export SCW_ACCESS_KEY="..."
export SCW_SECRET_KEY="..."
# This value is only an example
export SCW_DEFAULT_REGION="fr-par"
# This value is only an example
export SCW_DEFAULT_ZONE="fr-par-2"
```

Then either:

```{code-block} 
:caption: Source it
> source .env.secrets
```

...or if you followed [how-to manage venv with direnv](/howto/direnv):

```{code-block} 
:caption: Reload it
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
