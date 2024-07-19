* check use of docker/ dir
* check use of sre_tooling playbook

* ansible-playbook wescale.hashistack.vault_tf_policies_samples
Executing playbook vault_tf_policies_samples.yml

- Renders terraform samples for policy management on hosts: localhost -
Load group vars...
  localhost failed | msg: The task includes an option with an undefined variable. The error was: 'hs_workspace_group_vars_dir' is undefined

* kill vault_vars role by backporting dr_recovery playbook
