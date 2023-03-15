FROM hs-installer:latest
WORKDIR /opt/cmc
SHELL ["/bin/bash", "-c"]
RUN apt install -y python3-apt apt-transport-https
COPY . ./
RUN curl -s -L "https://releases.hashicorp.com/terraform/1.3.8/terraform_1.3.8_linux_amd64.zip" -o /tmp/terraform_1.3.8.zip && \
    unzip /tmp/terraform_1.3.8.zip -d /usr/local/bin/ && \
    chmod +x /usr/local/bin/terraform && \
    rm -f /tmp/terraform_1.3.8.zip
ENV TF_PLUGIN_CACHE_DIR="/root/.terraform.d/plugin-cache"
RUN mkdir -p /root/.terraform.d/plugin-cache
#RUN rm /etc/apt/apt.conf.d/docker-clean
RUN ansible-playbook playbooks/00_offline.yml -i inventory -t prepare
# RUN ansible-playbook playbooks/01_infra_scaleway.yml -i inventory -t prepare && \
# 	ansible-playbook playbooks/11_core_bootstrap.yml -i inventory -t prepare && \
# 	ansible-playbook playbooks/12_core_setup_dns.yml -i inventory -t prepare && \
# 	ansible-playbook playbooks/20_vault_install.yml -i inventory -t prepare && \
# 	ansible-playbook playbooks/21_consul_install.yml -i inventory -t prepare && \
# 	ansible-playbook playbooks/30_nomad_install.yml -i inventory -t prepare && \
# 	ansible-playbook playbooks/04_sre_tooling.yml -i inventory -t prepare
# ansible-playbook playbooks/13_core_scaleway_dns_delegation.yml -e tf_action=apply