#!/bin/sh

mkdir ~/bin/
mkdir ~/tmp/

# Terraform
cd ~/tmp/
curl -L https://releases.hashicorp.com/terraform/0.9.4/terraform_0.9.4_linux_amd64.zip > terraform.zip
unzip terraform.zip
mv ./terraform ~/bin


# provider sakuracloud
curl -L https://github.com/yamamoto-febc/terraform-provider-sakuracloud/releases/download/v0.9.0/terraform-provider-sakuracloud_linux-amd64.zip > terraform-provider-sakuracloud.zip
unzip terraform-provider-sakuracloud.zip
mv ./terraform-provider-sakuracloud ~/bin

