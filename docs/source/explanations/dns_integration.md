# DNS integration

Hashistack is heavily dynamic in its root. Deploying application as code implies also being able to manage
dynamic DNS records.

For that reason, any Hashistack needs to have a DNS domain delegation pointing at the `sre` host.
The delegated domain must match the `<name>.<parent_domain>` as supplied when you 
[initiate the instance directory](/tutorials/deploy_scw).

DNS is handled by Bind9.

A zone file is exposed to the outer world and another zone file is exposed for the inner world 
(aka the hashistack hosts).

Masters and Minions in an Hashistack instance have a local resolver with:

* cache enabled
* forward to local Consul agent for `*.consul.` domain requests
* forward to `sre` instance for everything else

The `sre` host accepts only recursive requests coming from the masters, minions or itself.
