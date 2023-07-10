#!/usr/bin/env bash

set -eoux pipefail

trash "terraform/kube"
mkdir -p "terraform/kube"

set +x

KUBECONFIG=$(cd kubernetes/gke && terraform output -raw kubeconfig_raw)
echo "$KUBECONFIG" > "terraform/kube/config"
