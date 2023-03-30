#!/bin/bash
echo "Downloading Terraform"
curl -s -L "https://releases.hashicorp.com/terraform/1.3.8/terraform_1.3.8_linux_amd64.zip" -o /tmp/terraform_1.3.8.zip && \
    unzip /tmp/terraform_1.3.8.zip -d /usr/local/bin/ && \
    chmod +x /usr/local/bin/terraform && \
    rm -f /tmp/terraform_1.3.8.zip
mkdir -p /root/.terraform.d/plugin-cache

echo "Play with apt"
rm /etc/apt/apt.conf.d/docker-clean /etc/apt/apt.conf.d/docker-autoremove-suggests
apt update
PACKAGES=$(apt list --installed | cut -d "/" -f1 | grep -v -e Listing )
apt install --reinstall -d $PACKAGES
apt install --reinstall -y -d direnv libxext6 libxmuu1 unzip xauth rsync python3-pyasn1 python3-ldap python3-pyasn1-modules
apt install -y rsync skopeo