#!/usr/bin/env bash

set -eou pipefail

readonly WORKSPACE_NAME="$1"
export KUBECONFIG="kube/config"

set -x

cd terraform

kubectl delete configmap kibana-helm-scripts --namespace elastic || true
kubectl delete serviceaccount pre-install-kibana --namespace elastic || true
kubectl delete role pre-install-kibana --namespace elastic || true
kubectl delete rolebinding pre-install-kibana --namespace elastic || true
kubectl delete job pre-install-kibana --namespace elastic || true

kubectl delete secret kibana-es-token --namespace elastic || true

terraform workspace select "$WORKSPACE_NAME"
terraform apply
