separator = "********************************************************************************"

.PHONY: prepare-debian
prepare-debian-desc = "Prepare a Debian-based Linux system for project operations"
prepare-debian:
	@echo ""
	@echo $(prepare-debian-desc)
	@echo $(separator)
	@sudo apt-get install direnv python3 python3-venv python3-pip sshpass

header:
	@[ -n "${HS_WORKSPACE}" ] || (echo "Please set the HS_WORKSPACE environment variable." && exit 1)
	@echo "**************************** HASHISTACK PROJECT ********************************"
	@echo ""
	@echo "CURRENT HASHISTACK WORKSPACE => ${HS_WORKSPACE}"
	@echo ""
	@echo $(separator)

header-env:
	@echo "**************************** HASHISTACK PROJECT ********************************"
	@echo ""
	@echo $(separator)

.PHONY: env
env-desc = "Build local workspace environment"
env: header-env
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


.PHONY: clean-doc-desc
clean-doc-desc = "Clean project static html documentation"
clean-doc:
	@echo ""
	@echo $(clean-doc-desc)
	@echo $(separator)
	@cd docs && make clean

# ***************************************
# *************************************** CORE_SCW
# ***************************************

core_scw_terraform_servers: header
	ansible-playbook playbooks/00_core_scw_servers.yml -e tf_action=apply

core_scw_terraform_servers_destroy: header
	ansible-playbook playbooks/00_core_scw_servers.yml -e tf_action=destroy

core_scw_terraform_lb: header
	ansible-playbook playbooks/00_core_scw_lb.yml -e tf_action=apply

core_scw_terraform_lb_destroy: header
	ansible-playbook playbooks/00_core_scw_lb.yml -e tf_action=destroy --skip-tags=rproxy

core_setup: header
	ansible-playbook playbooks/00_core_bootstrap.yml && \
	ansible-playbook playbooks/00_core_setup_dns.yml && \
	ansible-playbook rtnp.galaxie_clans.gandi_delegate_subdomain -e scope=${HS_WORKSPACE}-controller -e gandi_subdomain=${HS_WORKSPACE}

gandi-delegation: header
	ansible-playbook rtnp.galaxie_clans.gandi_delegate_subdomain -e scope=${HS_WORKSPACE}-controller -e gandi_subdomain=${HS_WORKSPACE}

gandi-delegation-clean: header
	ansible-playbook rtnp.galaxie_clans.gandi_delegate_subdomain -e scope=${HS_WORKSPACE}-controller -e gandi_subdomain=${HS_WORKSPACE} -e mode=destroy -e force=true

.PHONY: letsencrypt
letsencrypt-desc = "Automates a DNS challenge with the controller host and retrieves a wildcard certificate."
letsencrypt: header
	@echo ""
	@echo $(letsencrypt-desc)
	@echo $(separator)
	ansible-playbook playbooks/get_acme_certificate.yml

.PHONY: core_scw
core-scw-desc = "Builds a complete Scaleway Core"
core_scw: core_scw_terraform_servers core_setup letsencrypt core_scw_terraform_lb

.PHONY: core_scw_destroy
core-scw-destroy-desc = "Destroys a complete Scaleway Core"
core_scw_destroy: header core_scw_terraform_lb_destroy
	@echo ""
	@echo $(separator)
	@echo $(core-scw-destroy-desc)
	@echo $(separator)
	ansible-playbook rtnp.galaxie_clans.gandi_delegate_subdomain -e scope=${HS_WORKSPACE}-controller -e mode=destroy -e force=true && \
	ansible-playbook playbooks/00_core_scw_servers.yml -e tf_action=destroy

core_aws_destroy: header
	@echo ""
	@echo $(separator)
	@echo $(core-scw-destroy-desc)
	@echo $(separator)
	ansible-playbook rtnp.galaxie_clans.gandi_delegate_subdomain -e scope=${HS_WORKSPACE}-controller -e mode=destroy -e force=true && \
	ansible-playbook playbooks/00_core_aws_servers.yml -e tf_action=destroy

##### Aws Core ####
core_aws_terraform_servers: header
	ansible-playbook playbooks/00_core_aws_servers.yml -e tf_action=apply

core_aws_terraform_servers_destroy: header
	ansible-playbook playbooks/00_core_aws_servers.yml -e tf_action=destroy

.PHONY: core_aws
core_aws: core_aws_terraform_servers core_setup letsencrypt core_aws_terraform_lb

# ***************************************
# *************************************** VAULT
# ***************************************

.PHONY: vault_install
vault-install-desc = "Install Vault on master nodes"
vault_install: header
	ansible-playbook playbooks/01_vault_install.yml

.PHONY: vault_config
vault-config-desc = "Configure Vault through public API"
vault_config: header
	@echo ""
	@echo $(separator)
	@echo "==> $(vault-config-desc)"
	@echo $(separator)
	ansible-playbook playbooks/01_vault_config.yml -e tf_action=apply

.PHONY: vault_config_destroy
vault_config_destroy: header
	ansible-playbook playbooks/01_vault_config.yml -e tf_action=destroy

.PHONY: vault
vault: header vault_install vault_config

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
	ansible-playbook playbooks/02_consul_install.yml -l ${HS_WORKSPACE}_masters

.PHONY: consul_config
consul-config-desc = "Configure Consul through public API"
consul_config: header
	@echo ""
	@echo $(separator)
	@echo "==> $(consul-config-desc)"
	@echo $(separator)
	ansible-playbook playbooks/02_consul_config.yml -e tf_action=apply
	ansible-playbook playbooks/02_consul_install.yml

.PHONY: consul
consul: consul_install consul_config

consul_conf_destroy_hardcore:
	[ -n "${HS_WORKSPACE}" ] || echo "Set the HS_WORKSPACE env variable" && \
	rm -f group_vars/${HS_WORKSPACE}/secrets/tf_vault_config.yml && \
  rm -rf group_vars/${HS_WORKSPACE}/terraform/vault_config
	rm -f group_vars/${HS_WORKSPACE}/secrets/tf_consul_config.yml && \
  rm -rf group_vars/${HS_WORKSPACE}/terraform/consul_config

# ***************************************
# *************************************** NOMAD
# ***************************************

nomad_install:
	[ -n "${HS_WORKSPACE}" ] || echo "Set the HS_WORKSPACE env variable" && \
	ansible-playbook playbooks/03_nomad_install.yml

.PHONY: nomad
nomad: nomad_install

