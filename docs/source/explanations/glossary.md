# Glossary

## Instance Management directory

Initially created by the [`init` playbook](../reference/playbooks/init.md).

Contains all the ansible variables, terraform configuration and __root secrets__ to fully
administrate a stack deployment.

```{admonition} Warning
:class: warning

The content of such directories should be tightly secured. One practice could be to 
store them into dedicated git repository and restrict access to administrators only.

Some prefer to simply put a dedicated host into a safe for physical access enforcement.
```



