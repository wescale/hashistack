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

	@echo ""
	@echo "************************* IMPORT EXTERNAL ANSIBLE ROLES ************************"
	ansible-galaxy collection install -fr requirements.yml

.PHONY: core
core-desc = "Build local workspace environment"
core: header
	@echo ""
	@echo $(core-desc)
	@echo $(separator)
	[ -n "${WORKSPACE}" ] || echo "Set the WORKSPACE env variable" && \
	ansible-playbook playbooks/tf_core.yml -e tf_action=apply

re-core: core
	rm -f group_vars/${WORKSPACE}_platform/tf_core.tmp.yml

.PHONY: core-destroy
core-destroy-desc = "Destroy current workspace environment"
core-destroy:
	@echo ""
	@echo $(core-destroy-desc)
	@echo $(separator)
	[ -n "${WORKSPACE}" ] || echo "Set the WORKSPACE env variable" && \
	ansible-playbook rtnp.galaxie_clans.gandi_delegate_subdomain -e scope=${WORKSPACE}-controller -e mode=destroy -e force=true && \
	ansible-playbook playbooks/tf_core.yml -e tf_action=destroy

setup-desc = "Install system configuration and controller as domain authority"
.PHONY: setup
setup:
	@echo ""
	@echo $(setup-desc)
	@echo $(separator)
	[ -n "${WORKSPACE}" ] || echo "Set the WORKSPACE env variable" && \
	ansible-playbook playbooks/setup_core.yml && \
	ansible-playbook playbooks/setup_controller.yml && \
	ansible-playbook rtnp.galaxie_clans.gandi_delegate_subdomain -e scope=${WORKSPACE}-controller

letsencrypt:
	@echo "just because"
	[ -n "${WORKSPACE}" ] || echo "Set the WORKSPACE env variable" && \
  ansible-playbook playbooks/get_acme_certificate.yml



install_vault:
	[ -n "${WORKSPACE}" ] || echo "Set the WORKSPACE env variable" && \
	ansible-playbook playbooks/setup_vault.yml

vault_conf_destroy:
	[ -n "${WORKSPACE}" ] || echo "Set the WORKSPACE env variable" && \
	ansible-playbook playbooks/tf_vault_config.yml -e tf_action=destroy 

vault_conf_destroy_hardcore:
	[ -n "${WORKSPACE}" ] || echo "Set the WORKSPACE env variable" && \
	rm -f group_vars/${WORKSPACE}/secrets/tf_vault_config.yml && \
  rm -rf group_vars/${WORKSPACE}/terraform/vault_config

vault_conf:
	[ -n "${WORKSPACE}" ] || echo "Set the WORKSPACE env variable" && \
	ansible-playbook playbooks/tf_vault_config.yml -e tf_action=apply

install_consul:
	[ -n "${WORKSPACE}" ] || echo "Set the WORKSPACE env variable" && \
	ansible-playbook playbooks/deploy_consul.yml

consul_conf:
	[ -n "${WORKSPACE}" ] || echo "Set the WORKSPACE env variable" && \
	ansible-playbook playbooks/tf_consul_config.yml -e tf_action=apply -vv

consul_conf_destroy_hardcore:
	[ -n "${WORKSPACE}" ] || echo "Set the WORKSPACE env variable" && \
	rm -f group_vars/${WORKSPACE}/secrets/tf_consul_config.yml && \
  rm -rf group_vars/${WORKSPACE}/terraform/consul_config

install_nomad:
	[ -n "${WORKSPACE}" ] || echo "Set the WORKSPACE env variable" && \
	ansible-playbook playbooks/deploy_envoy.yml && \
	ansible-playbook playbooks/deploy_nomad.yml

demo:
	[ -n "${WORKSPACE}" ] || echo "Set the WORKSPACE env variable" && \
	ansible-playbook playbooks/tf_count_dashboard.yml -e tf_action=apply

demo-destroy:
	[ -n "${WORKSPACE}" ] || echo "Set the WORKSPACE env variable" && \
	ansible-playbook playbooks/tf_count_dashboard.yml -e tf_action=destroy

consul_config:
	[ -n "${WORKSPACE}" ] || echo "Set the WORKSPACE env variable" && \
	ansible-playbook playbooks/tf_consul_config.yml -e tf_action=apply

all: core setup letsencrypt install_vault vault_conf install_consul consul_conf install_nomad
	@date
