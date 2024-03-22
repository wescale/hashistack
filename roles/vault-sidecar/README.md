# Ansible Role: vault-sidecar

This Ansible role installs and configures the Vault-sidecar proxy to integrate Vault nodes into the Consul Service Mesh.

## Operation

This role automates the installation and configuration of the Vault-sidecar proxy to facilitate the integration of Vault nodes into the Consul Service Mesh. Here are the main operational steps:

1. **Dependency Installation**: The role installs necessary dependencies to run the proxy, such as Consul and Vault.

2. **Proxy Configuration**: Configuration files required for the proxy are generated using Jinja2 templates. These files include Consul service configuration for the proxy, system environment variables, and systemd service.

3. **Service Activation**: Once the configuration is generated, the systemd service for the proxy is activated and started.

## Usage

To utilize this role in your Ansible playbooks, you need to define the variable `hs_install_vault_sidecar` as `true` or `false` in your `playbooks/group_vars/all.yml` file, depending on your requirements. Here's how you can include it in your playbook:
