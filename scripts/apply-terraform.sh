#!/usr/bin/env bash

set -eou pipefail

readonly TERRAFORM_WORKSPACE_NAME="$1"
export KUBECONFIG="terraform/kube/config"

set -x

# Steps to fix the Kibana helm chart when reinstalling
kubectl delete configmap kibana-helm-scripts --namespace elastic || true
kubectl delete serviceaccount pre-install-kibana --namespace elastic || true
kubectl delete role pre-install-kibana --namespace elastic || true
kubectl delete rolebinding pre-install-kibana --namespace elastic || true
kubectl delete job pre-install-kibana --namespace elastic || true

# Steps to fix the Kibana helm chart when upgrading
# kubectl delete secret kibana-es-token --namespace elastic || true

cd terraform
terraform workspace select "$TERRAFORM_WORKSPACE_NAME"
terraform apply
