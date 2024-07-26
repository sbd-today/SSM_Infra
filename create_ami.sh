#!/bin/bash
root_path=$(pwd)
env=$1
if [[ -z $env ]]; then
  echo "Please specificy the enviornment" 
  exit 1
fi

cd live/${env}
terraform apply -target module.default_vpc.aws_default_vpc.default -var-file=terraform.tfvars
cd $root_path
cd packer/ami/
packer init ubuntu-ami.pkr.hcl && packer build ubuntu-ami.pkr.hcl
cd $root_path
