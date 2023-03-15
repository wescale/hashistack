# Supply your own infrastructure

The deploy stages as described in the tutorial [](/tutorials/deploy_scw.md) only targets
the case where the infrastructure (the hosts in ansible inventory) are created by a cloud provider of
our choice.

Here are some hints to adapt the procedure to supply the ifnrastructure by your own means. 

If you refer to the [](/explanations/stages.md) section, the point here is to help you make your
own "stage 0" and still fulfill all the prerequisites for upper-level deployment stages.

```{admonition} Note
:class: note
The project is based on the APT repository for Hashiscorp binary installation. For that reason, we only [support
x86_64 architecture for now](https://developer.hashicorp.com/terraform/cli/install/apt#supported-architectures).
```

## Have your target DNS in mind

Hashistack is designed to be delegated a DNS domain authority. The parent domain is a root variable to supply to the
`make init_instance` command.

## Init

* Keep the init phase to setup a local directory dedicated to your hashistack deployment:

```{code-block}
:caption: Initiate an instance directory
> make init_instance name=dark-grass parent_domain=scw.wescale.fr archi=mono
> cd inventories/hs_dark_grass
```

That will generate a working framework.

Once done, fill the `ssh.cfg` and `inventory` files to get your desired topology (refer to [](/explanations/inventory.md)).

* Validate your inventory by running:

```{code-block}
> ansible -m ping -b all
```

## Network capability

For now, all hosts need a route to Internet. You can validate this by running (from your `inventories/hs_instance_name` directory):

```{code-block}
> ansible-playbook ../../playbooks/test_egress.yml
```

## DNS integration

You will have to deal with domain delegation to give authority to the `hashistack_sre` instance for that domain.

For example, if you intend to have an Hashistack managing `hashistack.your.org` then:

* the parent domain is `your.org`
* these records should exist in the `your.org` zone file:

```{code-block}
:linenos:
hashistack      NS     ns.hashistack.your.org.
ns.hashistack   A      <ipv4 of hashistack_sre host>
ns.hashistack   AAAA   <ipv6 of hashistack_sre host>
```

## Configuration

TO BE DETAILED.

Look for the generated files when we deploy to Scaleway and adapt to your case.

* `<project root>/roles/stage_0/templates/mono/out.stage0.hashistack.yml.j2`
* `<project root>/roles/stage_0/templates/multi/out.stage0.hashistack.yml.j2`
* `<project root>/roles/stage_0/templates/multi/out.stage0.hashistack_sre.yml.j2`

## TLS Certificates

Once you:
* can reach your hosts and become a privileged user on them.
* ensured that your hosts can reach Internet.

You are almost ready to start the automation storm.

### LetsEncrypt

If you want LetsEncrypt certificates, you need to have your hashistack_sre exposed to Internet 
(as any polite DNS authority server).

If that is the case you can run:

```{code-block}
> make stage_1_bootstrap stage_1_addon_certs_letsencrypt stage_1_rproxy
> make stage_2 stage_3 stage_4
```

### Supply your own certificates

Get by any means a wildcard certificate for the DNS domain delegated to the 
`hashistack_sre` host (covering `*.hashistack.your.org` for example). Place the files
under your `inventories/hs_instance_name` directory at these locations:

* `group_vars/hashistack/secrets/self.cert.key`
* `group_vars/hashistack/secrets/self.cert.pem`
* `group_vars/hashistack/secrets/self.fullchain.cert.pem`

Then install hashistack by running:

```{code-block}
> make stage_1_bootstrap stage_1_rproxy
> make stage_2 stage_3 stage_4
```

```{admonition} Note
:class: note
The project is currently mostly centered around our demo technical case based on Scaleway. This
will change to ease deployment on any infrastructure.

All feedbacks are welcome. Testing is contributing. Feel free to 
[raise issues](https://github.com/wescale/hashistack/issues).
```
