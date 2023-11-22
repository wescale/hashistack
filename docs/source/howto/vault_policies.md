# Manage Vault policies

```{admonition} Use case
:class: note

This describes some hints about managing vault policies and rights in order to
get efficient with it beyond the proof-of-concept state.
```

-----

## Pre-deployment: Select your add-ons

Hashistack aims at deploying a fullstack platform, but you may want to only use
it for Vault deployment. In this case, the automated policy generation included
in the `vault` role might be useless.

```{admonition} See also
:class: hint

* [Add-ons configuration in vault role](../reference/role_vault.md#add-ons)
* [`roles/vault/files/terraform`](https://github.com/wescale/hashistack/tree/main/roles/vault/files):
the terraform sources of the ansible vault role add-ons.
```

-----

## Some strategies

### Central repository for every policies

You could setup a single repository, with only terraform code inside, to:

* centralize all policy management
* centralize token creation/invalidation
* restrict code and state access rights to the happy few allowed.
* ease auditability of your emitted policies

The application of this code could be protected by a simple pipeline launched on 
code updates on the `main` branch. 

Also, keep the `main` protected from direct push, force a MR/PR process for code updates and
enforce explicit MR/PR acceptation by at leat 2 team members.

This approach eases the review cycles as it keeps the policy nicely management traced
and if needed, you have all policies at hand to tighten the allowed privileges.

### Delegation scopes

You could setup some delegated scopes that will allow:

* some scope administrators to read/write (only in the allowed perimeter).
* some scope users to read-only (still only in the allowed perimeter).

Depending on the level of trust you want to delegate, scope administrators could even be allowed
to manage their scope users by themselves.

This is trickier to maintain but gives more autonomy to the vault consumers tribes (and therefore
could ease your daily work).

```{admonition} See also
:class: hint

* [`terraform/vaut_realm_kv`](https://github.com/wescale/hashistack/tree/main/terraform/vault_realm_kv):
a Terraform module to create a kv-v2 space with admin and user token giving access to a prefixed 
path of the mount point. This is designed for delegating a bit of the kv to application teams
and allow them to self-organize in their usages.
```

### Policy management delegation

You could also delegate the policy management to someone in your organization by building
a specific policy that allows token owner to create more policies.

When building that specific policy, mind about denying management on core policies like
Consul, Nomad and telemetry policies, to avoid problems.


```{admonition} See also
:class: hint

* [`terraform/vaut_policy_management`](https://github.com/wescale/hashistack/tree/main/terraform/vault_policy_management):
a Terraform module to create a policy that allows globally managing policies, 
with explicit deny on certain ones.

```

-----

```{admonition} Hints
:class: warning

Defining the _Right Way_ of organizing and managing Vault policies is way beyond the scope
of this project. It would also limit your creativity or question your needs as a user, which
is not the intention.

We encourage you to:

* design your own management process in collaboration with your users
* Keep It Stupidly Simple
* review the potential abuses that can arise.
* once done, persist it in a clear [Architecture Decision Record](https://adr.github.io/madr/#overview)
* Review and amend it as often as needed.

Security is a process, it has no finish line.
```
