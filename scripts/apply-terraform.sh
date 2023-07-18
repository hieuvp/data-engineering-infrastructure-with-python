#!/usr/bin/env bash

set -eou pipefail

readonly TERRAFORM_WORKSPACE_NAME="$1"
export KUBECONFIG="terraform/kube/config"

set -x

cd terraform
terraform workspace select "$TERRAFORM_WORKSPACE_NAME"
terraform apply
