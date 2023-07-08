#!/usr/bin/env bash

set -eou pipefail

export KUBECONFIG="kube/config"

set -x

cd terraform

kubectl delete configmap kibana-helm-scripts --namespace elastic || true
kubectl delete serviceaccount pre-install-kibana --namespace elastic || true
kubectl delete roles pre-install-kibana --namespace elastic || true
kubectl delete rolebindings pre-install-kibana --namespace elastic || true
kubectl delete job pre-install-kibana --namespace elastic || true

terraform apply
