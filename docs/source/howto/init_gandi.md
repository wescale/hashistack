# Setup Gandi credentials

```{admonition} Important
:class: tip

This how-to is only useful if you intend to manage your HashiStack platform domain delegation from a 
[Gandi](https://www.gandi.net/) managed parent domain.
```

## Prerequisites

* Follow the [How To Get Started](get_started.md) guide.

## Setup you Gandi account

* [Open a Gandi account](https://account.gandi.net/en/create_account)
* [Buy or link a domain name](https://www.gandi.net/en-US/domain) to your Gandi account.
* Generate a production API key from the [API Key Page](https://account.gandi.net) (in the Security section).

## Configure your Gandi account

At the workspace root, create or edit a ``.env.secrets`` file with this content:

```
export GANDI_API_KEY="..."
export GANDI_DOMAIN="..."
```

Then run:

```
direnv reload
```

## Check

You should find your credentials when running:

```
env | grep GANDI
```

```{admonition} Achievement Unlocked
:class: important

Your Gandi credentials are available for the HashiStack tooling.
```

