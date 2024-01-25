# Ansible and Terraform

```{admonition} Important
:class: important

This project is Ansible-centric.
```


## Ansible responsiblities

* orchestrate the whole deployment process.
* configure the hosts on which the platform rely.
* init, plan and apply Terraform modules.
* extract Terraform outputs and render them back in the Ansible variables for next stages.

## Terraform responsiblities

* Manage cloud resources for infrastructure. At the time of writing, only Scaleway is supported. Some AWS
code has been contributed but its maintenance over time is not ensured, due to contributors
disponibility.
* Inject configuration into Vault, Consul and Nomad.

Every piece of Terraform code is intended to be managed by the 
[cloud.terraform.terraform](https://github.com/ansible-collections/cloud.terraform/blob/main/docs/cloud.terraform.terraform_module.rst) Ansible module.

## Terraform code

Every `terraform apply` through a playbook starts with a copy of the target Terraform module into a 
work directory before init, plan and apply.

Every `terraform destroy` through a playbook is launched directly from the work directory that has been applied,
without preliminary copy. That is to ensure that resources being destroyed are the one that once were applied.
This helps avoiding error when the Terraform module's code has shifted between the apply and the destroy 
lifecycle phase.

## Debugging terraform

When debugging, we advise you to launche the concerned playbook with `ansible-playbook -vv`. That will output
you the command line used by the ansible module to start terraform. You can then position your terminal in
the terraofmr work dir, select the workspace used by ansible and play directly with terraform.
