#!/usr/bin/env bash

set -eoux pipefail

cd terraform

trash .terraform .terraform.lock.hcl terraform.tfstate.d

terraform workspace new minikube
terraform workspace select minikube
terraform init

terraform workspace new gke
terraform workspace select gke
terraform init
