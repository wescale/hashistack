# The HS_WORKSPACE

The HashiStack project is intended to be useful for full-HashiCorp platform management.
One of the threat of using Ansible is to assume a false sense of security in operations when you have playbooks on one side 
and multiple hosts and environments in the same inventory file on the other side.

The `HS_WORKSPACE` environment variable is our response to this problem. Playbooks host targeting rely on this variable
to select hosts on which playbooks should execute. Inventory structure has a convention of 3 groups to define a platform:

* `${HS_WORKSPACE}_masters` grouping master hosts
* `${HS_WORKSPACE}_minions` grouping worker hosts
* `${HS_WORKSPACE}` that is a parent group of the 2 others

If `HS_WORKSPACE` is not defined, no playbook will execute.

That is our response to ensure the respect of the principle: __[Primum non nocere](https://en.wikipedia.org/wiki/Primum_non_nocere)__
