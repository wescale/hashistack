separator = "********************************************************************************"

.PHONY: prepare-debian
prepare-debian-desc = "Prepare a Debian-based Linux system for project operations"
prepare-debian:
	@echo ""
	@echo $(prepare-debian-desc)
	@echo $(separator)
	@sudo apt-get install direnv python3 python3-venv python3-pip sshpass

header:
	@echo "**************************** HASHISTACK PROJECT ********************************"
	@echo ""
	@echo "CURRENT HASHISTACK WORKSPACE => $(shell basename ${PWD})"
	@echo ""
	@echo $(separator)

header-env:
	@echo "**************************** HASHISTACK PROJECT ********************************"
	@echo ""
	@echo $(separator)

.PHONY: env
env-desc = "Build local workspace environment"
prepare: header-env
	@echo ""
	@echo "==> $(env-desc)"
	@echo $(separator)
	@pip3 install -U pip --no-cache-dir --quiet &&\
	echo "[  OK  ] PIP3" || \
	echo "[FAILED] PIP3"

	@pip3 install -U wheel --no-cache-dir --quiet &&\
	echo "[  OK  ] WHEEL" || \
	echo "[FAILED] WHEEL"

	@pip3 install -U setuptools --no-cache-dir --quiet &&\
	echo "[  OK  ] SETUPTOOLS" || \
	echo "[FAILED] SETUPTOOLS"

	@pip3 install -U --no-cache-dir --quiet -r ${PWD}/requirements.txt &&\
	echo "[  OK  ] REQUIREMENTS" || \
	echo "[FAILED] REQUIREMENTS"
	
	@pip3 install -U --no-cache-dir --quiet -r ${PWD}/docs/requirements.txt &&\
	echo "[  OK  ] DOC REQUIREMENTS" || \
	echo "[FAILED] DOC REQUIREMENTS"

	@echo ""
	@echo "************************* IMPORT EXTERNAL ANSIBLE ROLES ************************"
	ansible-galaxy collection install -fr requirements.yml
	ansible-galaxy role install -fr requirements.yml


.PHONY: doc-desc
doc-desc = "Build project static html documentation"
doc:
	@echo ""
	@echo $(doc-desc)
	@echo $(separator)
	@cd docs &&	make html
	@echo $(separator)
	@echo "Static documentation exported:"
	@echo "  file://${PWD}/docs/build/html/index.html"
	@echo $(separator)


.PHONY: clean
clean = "Clean everything"
clean: clean-molecule

.PHONY: clean-molecule-cache
clean-molecule-cache-desc = "Clean molecule cache"
clean-molecule:
	@echo ""
	@echo $(clean-molecule-cache-desc)
	@echo $(separator)
	molecule destroy && molecule reset

.PHONY: clean-doc-desc
clean-doc-desc = "Clean project static html documentation"
clean-doc:
	@echo ""
	@echo $(clean-doc-desc)
	@echo $(separator)
	@cd docs && make clean

# ***************************************
# *************************************** LINT
# ***************************************

tf_fmt:
	find terraform/* -maxdepth 1 -type d -exec bash -c 'cd {} && pwd && terraform fmt' \;

# ***************************************
# *************************************** INIT
# ***************************************

init_instance:
	ansible-playbook playbooks/00_init_instance.yml -e hs_workspace=$(hs_workspace) -e hs_parent_domain=$(hs_parent_domain) -e hs_archi=$(hs_archi)

# ***************************************
# *************************************** VAULT
# ***************************************

encrypt:
	ansible-vault encrypt group_vars/hashistack/secrets/*

decrypt:
	ansible-vault decrypt group_vars/hashistack/secrets/*

# ***************************************
# *************************************** STAGE
# ***************************************

stage_0: core_scw_terraform_server

stage_1: core_setup
	@echo ""
	@echo "Now create a delegation and have your root certificate:"
	@echo ""
	@echo "    make core_delegation_scw core_letsencrypt core_rproxy"
	@echo ""
	@echo $(separator)

stage_2: vault consul

stage_3: nomad

# ***************************************
# *************************************** CORE SCALEWAY
# ***************************************

core_scw_terraform_server: header
	ansible-playbook ../../playbooks/01_core_scaleway.yml -e tf_action=apply

core_scw_terraform_server_destroy: header
	ansible-playbook ../../playbooks/01_core_scaleway.yml -e tf_action=destroy

# ***************************************
# *************************************** CORE SETUP
# ***************************************

core_setup: header
	ansible-playbook ../../playbooks/11_core_bootstrap.yml
	ansible-playbook ../../playbooks/12_core_setup_dns.yml

# ***************************************
# *************************************** SCALEWAY DELEGATION
# ***************************************

core_delegation_scw: header
	ansible-playbook ../../playbooks/13_core_scaleway_dns_delegation.yml -e tf_action=apply

core_delegation_scw_destroy: header
	ansible-playbook ../../playbooks/13_core_scaleway_dns_delegation.yml -e tf_action=destroy

# ***************************************
# *************************************** GANDI DELEGATION
# ***************************************

gandi-delegation: header
	ansible-playbook rtnp.galaxie_clans.gandi_delegate_subdomain -e scope=${HS_WORKSPACE}-sre -e gandi_subdomain=${HS_WORKSPACE}

gandi-delegation-clean: header
	ansible-playbook rtnp.galaxie_clans.gandi_delegate_subdomain -e scope=${HS_WORKSPACE}-sre -e gandi_subdomain=${HS_WORKSPACE} -e mode=destroy -e force=true

gandi-delegation-mono: header
	ansible-playbook rtnp.galaxie_clans.gandi_delegate_subdomain -e scope=${HS_WORKSPACE}-mono -e gandi_subdomain=${HS_WORKSPACE}

gandi-delegation-mono-clean: header
	ansible-playbook rtnp.galaxie_clans.gandi_delegate_subdomain -e scope=${HS_WORKSPACE}-mono -e gandi_subdomain=${HS_WORKSPACE} -e mode=destroy -e force=true

# ***************************************
# *************************************** LETSENCRYPT
# ***************************************

.PHONY: core_letsencrypt
letsencrypt-desc = "Automates a DNS challenge with the sre host and retrieves a wildcard certificate."
core_letsencrypt: header
	@echo ""
	@echo $(letsencrypt-desc)
	@echo $(separator)
	ansible-playbook ../../playbooks/14_core_letsencrypt.yml

# ***************************************
# *************************************** REVERSE PROXY
# ***************************************

core_rproxy: header
	ansible-playbook ../../playbooks/15_core_rproxy.yml

# ***************************************
# *************************************** SCALEWAY LOAD BALANCER
# ***************************************

core_scw_terraform_lb: header
	ansible-playbook playbooks/00_core_scw_lb.yml -e tf_action=apply

core_scw_terraform_lb_destroy: header
	ansible-playbook playbooks/00_core_scw_lb.yml -e tf_action=destroy --skip-tags=rproxy

# .PHONY: core_scw
# core-scw-desc = "Builds a complete Scaleway Core"
# core_scw: core_scw_terraform_servers core_setup gandi-delegation letsencrypt core_scw_terraform_lb

# .PHONY: core_scw_destroy
# core-scw-destroy-desc = "Destroys a complete Scaleway Core"
# core_scw_destroy: header core_scw_terraform_lb_destroy
# 	@echo ""
# 	@echo $(separator)
# 	@echo $(core-scw-destroy-desc)
# 	@echo $(separator)
# 	ansible-playbook rtnp.galaxie_clans.gandi_delegate_subdomain -e scope=${HS_WORKSPACE}-sre -e mode=destroy -e force=true && \
# 	ansible-playbook playbooks/00_core_scw_servers.yml -e tf_action=destroy

# .PHONY: core_scw_mono
# core-scw-mono-desc = "Builds a complete Scaleway Core mono node"
# core_scw_mono: core_scw_terraform_mono_server core_setup_mono letsencrypt

# .PHONY: core_scw_destroy_mono
# core-scw-destroy-mono-desc = "Destroys a complete Scaleway Core mono node"
# core_scw_destroy_mono: header
# 	@echo ""
# 	@echo $(separator)
# 	@echo $(core-scw-destroy-mono-desc)
# 	@echo $(separator)
# 	ansible-playbook rtnp.galaxie_clans.gandi_delegate_subdomain -e scope=${HS_WORKSPACE}-mono -e mode=destroy -e force=true && \
# 	ansible-playbook playbooks/00_core_scw_mono_servers.yml -e tf_action=destroy

# ***************************************
# *************************************** CORE_AWS
# ***************************************

core_aws_terraform_servers: header
	ansible-playbook playbooks/01_core_aws.yml -e tf_action=apply

core_aws_terraform_servers_destroy: header
	ansible-playbook playbooks/01_core_aws.yml -e tf_action=destroy

.PHONY: core_aws
core_aws: core_aws_terraform_servers core_setup letsencrypt core_aws_terraform_lb

core_aws_destroy: header
	@echo ""
	@echo $(separator)
	@echo $(core-scw-destroy-desc)
	@echo $(separator)
	ansible-playbook rtnp.galaxie_clans.gandi_delegate_subdomain -e scope=${HS_WORKSPACE}-sre -e mode=destroy -e force=true && \
	ansible-playbook playbooks/01_core_aws.yml -e tf_action=destroy

# ***************************************
# *************************************** VAULT
# ***************************************

.PHONY: vault_install
vault-install-desc = "Install Vault on master nodes"
vault_install: header
	ansible-playbook ../../playbooks/20_vault_install.yml

# .PHONY: vault_config
# vault-config-desc = "Configure Vault through public API"
# vault_config: header
# 	@echo ""
# 	@echo $(separator)
# 	@echo "==> $(vault-config-desc)"
# 	@echo $(separator)
# 	ansible-playbook ../../playbooks/21_vault_config.yml -e tf_action=apply

.PHONY: vault
vault: header vault_install 
# ***************************************
# *************************************** CONSUL
# ***************************************

.PHONY: consul_install
consul-install-desc = "Install Consul masters and minions"
consul_install: header
	@echo ""
	@echo $(separator)
	@echo "==> $(consul-install-desc)"
	@echo $(separator)
	ansible-playbook ../../playbooks/30_consul_install.yml

.PHONY: consul
consul: consul_install

# ***************************************
# *************************************** NOMAD
# ***************************************

.PHONY: nomad_install
nomad-install-desc = "Install Nomad masters and minions"
nomad_install: header
	ansible-playbook ../../playbooks/40_nomad_install.yml

.PHONY: nomad
nomad: nomad_install

# ***************************************
# *************************************** HASHISTACK
# ***************************************

.PHONY: hashistack
hashistack: vault consul nomad

# ***************************************
# *************************************** SRE
# ***************************************

.PHONY: sre-tooling-install
sre-tooling-install-desc = "Install SRE tooling"
sre_tooling_install: header
	@echo ""
	@echo $(separator)
	@echo "==> $(sre-tooling-install-desc)"
	@echo $(separator)
	[ -n "${HS_WORKSPACE}" ] || echo "Set the HS_WORKSPACE env variable" && \
	ansible-playbook playbooks/04_sre_tooling.yml

.PHONY: sre_tooling
sre_tooling: sre_tooling_install 
