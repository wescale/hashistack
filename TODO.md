* check use of docker/ dir
* check use of sre_tooling playbook

* ansible-playbook wescale.hashistack.vault_tf_policies_samples
Executing playbook vault_tf_policies_samples.yml

- Renders terraform samples for policy management on hosts: localhost -
Load group vars...
  localhost failed | msg: The task includes an option with an undefined variable. The error was: 'hs_workspace_group_vars_dir' is undefined

* kill vault_vars role by backporting dr_recovery playbook
* balise SBOM binaires vault/consul/nomad


ROADMAP SEPTEMBRE:

* Support RHEL family - juillet
* tests mono node complet - aout
* tests offline complet - aout
* statuer sur version stable entre septembre 2024 et janvier 2025

* playbook : liens vers le github pour dive into code

ROADMAP 1.0 (wood-dragon):

* virer skopeo
* playbooks de back/restore à chaque étage.
* playbooks de montée de version avec maintien data.
* couverture de tests incluant multi mono et offline.
* debian + RHEL family


Alpine au printemps ?
ajouter openwrt à la liste ?

