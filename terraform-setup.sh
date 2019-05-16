#!/bin/sh

mkdir ~/bin/
mkdir ~/tmp/

# Terraform
cd ~/tmp/
curl -L https://releases.hashicorp.com/terraform/0.11.13/terraform_0.11.13_linux_amd64.zip > terraform.zip
unzip terraform.zip
mv ./terraform ~/bin


# provider sakuracloud
curl -L https://github.com/sacloud/terraform-provider-sakuracloud/releases/download/v1.11.4/terraform-provider-sakuracloud_1.11.4_linux-amd64.zip > terraform-provider-sakuracloud.zip
unzip terraform-provider-sakuracloud.zip

