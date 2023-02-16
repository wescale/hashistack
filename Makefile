##
## —————————————————————————————————— HASHISTACK ————————————————————————————————
##

.DEFAULT_GOAL = help

.PHONY: help header-env
help: ## Display help
	@grep -E '(^[a-zA-Z_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | sed -e 's/Makefile://' | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-22s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'

header-env:
	@echo "—————————————————————————————————— HASHISTACK —————————————————————————————————"
	@echo

separator = "————————————————————————————————————————————————————————————————————————————————"

##
## —————————————————————————— ENVIRONMENT CONFIGURATION —————————————————————————
##

.PHONY: venv-check
venv-check: header-env
	@[ -d "$${PWD}/.direnv" ] || (echo "Venv not found: $${PWD}/.direnv" && exit 1)
	@direnv reload

.PHONY: install-requirements
install-requirements: ## Install system dependencies
	@echo "*************************** SYSTEM REQUIREMENTS *********************************"
	@sudo apt-get install python3 python3-dev python3-venv python3-pip direnv bash lsb-release unzip curl sshpass -y
	@grep -q 'eval "$$(direnv hook bash)"' ~/.bashrc || echo 'eval "$$(direnv hook bash)"' >> ~/.bashrc


.PHONY: prepare
prepare: venv-check ### Install workspace env dependencies
	@echo "************************** PYTHON REQUIREMENTS *********************************"
	@pip3 install -U pip --no-cache-dir --quiet &&\
	echo "[  ${Green}OK${Color_Off}  ] ${Yellow}INSTALL${Color_Off} PIP3" || \
	echo "[${Red}FAILED${Color_Off}] ${Yellow}INSTALL${Color_Off} PIP3"

	@pip3 install -U wheel --no-cache-dir --quiet &&\
	echo "[  ${Green}OK${Color_Off}  ] ${Yellow}INSTALL${Color_Off} WHEEL" || \
	echo "[${Red}FAILED${Color_Off}] ${Yellow}INSTALL${Color_Off} WHEEL"

	@pip3 install -U setuptools --no-cache-dir --quiet &&\
	echo "[  ${Green}OK${Color_Off}  ] ${Yellow}INSTALL${Color_Off} SETUPTOOLS" || \
	echo "[${Red}FAILED${Color_Off}] ${Yellow}INSTALL${Color_Off} SETUPTOOLS"

	@pip3 install -U --no-cache-dir -q -r requirements.txt &&\
	echo "[  ${Green}OK${Color_Off}  ] ${Yellow}INSTALL${Color_Off} PIP REQUIREMENTS" || \
	echo "[${Red}FAILED${Color_Off}] ${Yellow}INSTALL${Color_Off} PIP REQUIREMENTS"

	@pip3 install -U --no-cache-dir -q -r ${PWD}/docs/requirements.txt &&\
	cd docs/plugins/yaml2md &&\
	pip3 install -q -e . &&\
	echo "[  ${Green}OK${Color_Off}  ] ${Yellow}INSTALL${Color_Off} PIP DOC REQUIREMENTS" || \
	echo "[${Red}FAILED${Color_Off}] ${Yellow}INSTALL${Color_Off} PIP DOC REQUIREMENTS"
	@echo "***************************** ANSIBLE REQUIREMENTS *****************************"
	@ansible-galaxy collection install -fr ${PWD}/requirements.yml
	@ansible-galaxy role install -fr ${PWD}/requirements.yml


.PHONY: doc
doc: ### Build project static html documentation
	@echo ""
	@cd docs &&	make html
	@echo $(separator)
	@echo "Static documentation exported:"
	@echo "  file://${PWD}/docs/build/html/index.html"
	@echo $(separator)
	@echo ""


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

tf_fmt:
	find terraform/* -maxdepth 1 -type d -exec bash -c 'cd {} && pwd && terraform fmt' \;

##
## ———————————————————————————————————— INIT ————————————————————————————————————
##

init_instance: ## Init inventory dir for instance
	@ [ -n  "$(workspace)" ] && [ -n  "$(parent_domain)" ] && [ -n  "$(archi)" ] && \
	ansible-playbook playbooks/00_init_instance.yml -e hs_workspace=$(workspace) -e hs_parent_domain=$(parent_domain) -e hs_archi=$(archi) || \
	( \
	echo ----------------------------------- HASHISTACK --------------------------------- && \
	echo && \
	echo "Usage:\n\tmake init_instance workspace=NAME parent_domain=DOMAIN archi=[mono|multi]\n" && \
	exit 1 \
	)


##
## —————————————————————————— STAGE_0 - INFRASTRUCTURE ——————————————————————————
##

.PHONY: stage_0_scaleway
stage_0_scaleway:
	ansible-playbook ../../playbooks/01_infra_scaleway.yml

.PHONY: stage_0_scaleway_destroy
stage_0_scaleway_destroy:
	ansible-playbook ../../playbooks/01_infra_scaleway.yml -e tf_action=destroy

##
## —————————————————————————————— STAGE_1 - SYSTEMS —————————————————————————————
##

.PHONY: stage_1_bootstrap
stage_1_bootstrap:
	ansible-playbook ../../playbooks/11_core_bootstrap.yml
	ansible-playbook ../../playbooks/12_core_setup_dns.yml
	@echo ""
	@echo "Next steps:"
	@ echo "  - create a delegation"
	@ echo "  - have your root certificate"
	@ echo "  - run:"
	@ echo "      make stage_1_rproxy"
	@echo ""

stage_1_rproxy:
	ansible-playbook ../../playbooks/15_core_rproxy.yml

stage_1: stage_1_bootstrap stage_1_rproxy

stage_1_addon_delegation_scaleway:
	ansible-playbook ../../playbooks/13_core_scaleway_dns_delegation.yml -e tf_action=apply

stage_1_addon_delegation_scaleway_destroy:
	ansible-playbook ../../playbooks/13_core_scaleway_dns_delegation.yml -e tf_action=destroy

stage_1_addon_certs_letsencrypt:
	ansible-playbook ../../playbooks/14_core_letsencrypt.yml

stage_1_auto_prerequisites: stage_1_bootstrap stage_1_addon_delegation_scaleway stage_1_addon_certs_letsencrypt stage_1_rproxy

##
## ——————————————————————————— STAGE_2 - VAULT+CONSUL ———————————————————————————
##

stage_2_vault:
	ansible-playbook ../../playbooks/20_vault_install.yml

stage_2_consul:
	ansible-playbook ../../playbooks/21_consul_install.yml

stage_2: stage_2_vault stage_2_consul

##
## —————————————————————————————— STAGE_3 - NOMAD ———————————————————————————————
##

stage_3:
	ansible-playbook ../../playbooks/30_nomad_install.yml


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

# ***************************************
# *************************************** VAULT
# ***************************************

encrypt:
	ansible-vault encrypt group_vars/hashistack/secrets/*

decrypt:
	ansible-vault decrypt group_vars/hashistack/secrets/*


