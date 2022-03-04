separator = "********************************************************************************"

.PHONY: header
header:
	@echo "*********************** WESCALE HASHISTACK MAKEFILE ****************************"
	@echo "HOSTNAME        `uname -n`"
	@echo "KERNEL RELEASE  `uname -r`"
	@echo "KERNEL VERSION  `uname -v`"
	@echo "PROCESSOR       `uname -m`"
	@echo $(separator)

.PHONY: env
env-desc = "Build local workspace environment"
env: header
	@echo ""
	@echo $(env-desc)
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

core_scw_terraform_servers: header
	[ -n "${HS_WORKSPACE}" ] || echo "Set the HS_WORKSPACE env variable" && \
	ansible-playbook playbooks/00_core_scw_servers.yml -e tf_action=apply

core_scw_terraform_lb: header
	[ -n "${HS_WORKSPACE}" ] || echo "Set the HS_WORKSPACE env variable" && \
	ansible-playbook playbooks/00_core_scw_lb.yml -e tf_action=apply

core_scw_terraform_lb_destroy: header
	[ -n "${HS_WORKSPACE}" ] || echo "Set the HS_WORKSPACE env variable" && \
	ansible-playbook playbooks/00_core_scw_lb.yml -e tf_action=destroy


core_setup: header
	[ -n "${HS_WORKSPACE}" ] || echo "Set the HS_WORKSPACE env variable" && \
	ansible-playbook playbooks/00_core_setup_platform.yml && \
	ansible-playbook playbooks/00_core_setup_controller.yml && \
	ansible-playbook rtnp.galaxie_clans.gandi_delegate_subdomain -e scope=${HS_WORKSPACE}-controller -e gandi_subdomain=${HS_WORKSPACE}

letsencrypt:
	[ -n "${HS_WORKSPACE}" ] || echo "Set the HS_WORKSPACE env variable" && \
  ansible-playbook playbooks/get_acme_certificate.yml

.PHONY: core_scw
core_scw: core_scw_terraform_servers core_setup letsencrypt core_scw_terraform_lb install_vault


re-core: core
	rm -f group_vars/${HS_WORKSPACE}_platform/tf_core.tmp.yml

.PHONY: core-destroy
core-destroy-desc = "Destroy current workspace environment"
core_scw_destroy: core_scw_terraform_lb_destroy
	@echo ""
	@echo $(core-destroy-desc)
	@echo $(separator)
	[ -n "${HS_WORKSPACE}" ] || echo "Set the HS_WORKSPACE env variable" && \
	ansible-playbook rtnp.galaxie_clans.gandi_delegate_subdomain -e scope=${HS_WORKSPACE}-controller -e mode=destroy -e force=true && \
	ansible-playbook playbooks/00_core_scw_servers.yml -e tf_action=destroy


install_vault:
	[ -n "${HS_WORKSPACE}" ] || echo "Set the HS_WORKSPACE env variable" && \
	ansible-playbook playbooks/setup_vault.yml

vault_conf_destroy:
	[ -n "${HS_WORKSPACE}" ] || echo "Set the HS_WORKSPACE env variable" && \
	ansible-playbook playbooks/tf_vault_config.yml -e tf_action=destroy 

vault_conf_destroy_hardcore:
	[ -n "${HS_WORKSPACE}" ] || echo "Set the HS_WORKSPACE env variable" && \
	rm -f group_vars/${HS_WORKSPACE}/secrets/tf_vault_config.yml && \
  rm -rf group_vars/${HS_WORKSPACE}/terraform/vault_config

vault_conf:
	[ -n "${HS_WORKSPACE}" ] || echo "Set the HS_WORKSPACE env variable" && \
	ansible-playbook playbooks/tf_vault_config.yml -e tf_action=apply

.PHONY: vault
vault: install_vault vault_conf

.PHONY: install_consul
install_consul:
	[ -n "${HS_WORKSPACE}" ] || echo "Set the HS_WORKSPACE env variable" && \
	ansible-playbook playbooks/deploy_consul.yml

.PHONY: configure_consul
configure_consul:
	[ -n "${HS_WORKSPACE}" ] || echo "Set the HS_WORKSPACE env variable" && \
	ansible-playbook playbooks/tf_consul_config.yml -e tf_action=apply

.PHONY: consul
consul: install_consul configure_consul

consul_conf_destroy_hardcore:
	[ -n "${HS_WORKSPACE}" ] || echo "Set the HS_WORKSPACE env variable" && \
	rm -f group_vars/${HS_WORKSPACE}/secrets/tf_consul_config.yml && \
  rm -rf group_vars/${HS_WORKSPACE}/terraform/consul_config

install_nomad:
	[ -n "${HS_WORKSPACE}" ] || echo "Set the HS_WORKSPACE env variable" && \
	ansible-playbook playbooks/deploy_envoy.yml && \
	ansible-playbook playbooks/deploy_nomad.yml

.PHONY: nomad
nomad: install_nomad

demo:
	[ -n "${HS_WORKSPACE}" ] || echo "Set the HS_WORKSPACE env variable" && \
	ansible-playbook playbooks/tf_count_dashboard.yml -e tf_action=apply

demo-destroy:
	[ -n "${HS_WORKSPACE}" ] || echo "Set the HS_WORKSPACE env variable" && \
	ansible-playbook playbooks/tf_count_dashboard.yml -e tf_action=destroy

all: core vault consul nomad
