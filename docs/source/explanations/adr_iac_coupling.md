# IaC coupling

## Context and Problem Statement

Ansible & Terraform are chosen for the strong points on differents perimeters.
There are many options on how to couple them together to achieve low maintenance
and ease IaC development. We need to state a method for tooling synergy.

## Decision Drivers

* 

## Considered Options

* Ansible playbooks that include Terraform
* Terraform stacks that run Ansible
* Bare Terraform then Ansible playbooks
* Terragrunt the Ansible playbooks

## Pros and Cons of the Options

### Ansible playbooks that include Terraform

Rely on Ansible module [cloud.terraform.terraform](https://github.com/ansible-collections/cloud.terraform/blob/main/docs/cloud.terraform.terraform_module.rst)
to manage Terraform operations through dedicated Ansible playbook.

* Good: Strong coupling forces to build coherent tooling.
* Good: You end up managing a single source of truth, embodied by Ansible variables files.
* Good: Flexibility to automate pre-tasks and post-tasks around Terraform execution in a single
run.
* Bad: Quite more verbose to code.
* Bad: Can become messy if not rigourous on component topology.

### Terraform stacks that run Ansible

Rely on terraform `null_resource` to make Terraform start an Ansible sub-process.

* Bad: Needs a lot of effort to ensure the execution plan of terraform runs the subprocess only when resources are available.
* Bad: No capacity for Terraform to `git clone` on the fly or manage dependencies.
* Bad: Terraform is a very good tool to manage API HTTP calls but not to call subprocess.

### Bare Terraform then Ansible playbooks

Manage Terraform on its own and, once done, use Ansible to retrieve the resources and execute
playbooks on the created resources.

* Good: Each tool lives its own life. Very loose coupling.
* Bad: Add a great tool on top of Terraform which could complexify diagnostic in case of troubleshooting

### Terragrunt the Ansible playbooks

Manage Terraform through Terragrunt, a complementary tooling that comes with Terraform
methodology and, once done, use Ansible to retrieve the resources and execute
playbooks on the created resources.

* Good: Helps with DRY approach on the Terraform code and management.
* Bad: Another approach to learn, getting juice out of Terragrunt implies following their guidance on code organization, module topology, etc.


