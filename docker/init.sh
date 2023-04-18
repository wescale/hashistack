#!/bin/bash

TF_VERSION="1.3.8"
TF_URL_PREFIX="https://releases.hashicorp.com/terraform/${TF_VERSION}"
TF_URL="${TF_URL_PREFIX}/terraform_${TF_VERSION}_linux_amd64.zip"

echo "==> Downloading Terraform"

curl -s -L "${TF_URL}" -o /tmp/terraform_${TF_VERSION}.zip && \
  unzip /tmp/terraform_${TF_VERSION}.zip -d /usr/local/bin/ && \
  chmod +x /usr/local/bin/terraform && \
  rm -f /tmp/terraform_${TF_VERSION}.zip
mkdir -p /root/.terraform.d/plugin-cache


echo "==> Cleaning"
rm /etc/apt/apt.conf.d/docker-clean \
  /etc/apt/apt.conf.d/docker-autoremove-suggests

echo "==> Play with apt"
apt update
PACKAGES=$(apt list --installed | cut -d '/' -f1 | grep -v -e Listing)
apt install --reinstall -y -d ${PACKAGES}
apt install --reinstall -y -d \
  vim \
  direnv libxext6 libxmuu1 unzip xauth rsync \
  python3-pyasn1 python3-ldap python3-pyasn1-modules
apt install -y rsync skopeo

