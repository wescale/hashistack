FROM hs-installer:latest
WORKDIR /opt/cmc
SHELL ["/bin/bash", "-c"]
COPY . ./
ENV TF_PLUGIN_CACHE_DIR="/root/.terraform.d/plugin-cache"
RUN mkdir -p /root/.terraform.d/plugin-cache
RUN rm /etc/apt/apt.conf.d/docker-clean
RUN ansible-playbook playbooks/01_infra_scaleway.yml -i inventory -t prepare && \
 	ansible-playbook playbooks/11_core_bootstrap.yml -i inventory -t prepare && \
 	ansible-playbook playbooks/12_core_setup_dns.yml -i inventory -t prepare && \
 	ansible-playbook playbooks/20_vault_install.yml -i inventory -t prepare && \
 	ansible-playbook playbooks/21_consul_install.yml -i inventory -t prepare && \
 	ansible-playbook playbooks/30_nomad_install.yml -i inventory -t prepare
# WiP
# 	ansible-playbook playbooks/04_sre_tooling.yml -i inventory -t prepare