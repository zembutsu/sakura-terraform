#!/bin/sh

# Terraform
cd /tmp
curl -L https://releases.hashicorp.com/terraform/0.9.2/terraform_0.9.2_linux_amd64.zip > terraform.zip
unzip terraform.zip
mv ./terraform /usr/local/bin


# provider sakuracloud
curl -L https://github.com/yamamoto-febc/terraform-provider-sakuracloud/releases/download/v0.7.3/terraform-provider-sakuracloud_linux-amd64.zip > terraform-provider-sakuracloud.zip
unzip terraform-provider-sakuracloud.zip
mv ./terraform-provider-sakuracloud /usr/local/bin

