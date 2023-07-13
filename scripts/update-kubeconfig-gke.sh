#!/usr/bin/env bash

set -eou pipefail

export KUBECONFIG="terraform/kube/config"

PROJECT_ID=$(cd kubernetes/gke && terraform output -raw project_id)
CLUSTER_NAME=$(cd kubernetes/gke && terraform output -raw cluster_name)
CLUSTER_ZONE=$(cd kubernetes/gke && terraform output -raw cluster_zone)

set -x

trash "terraform/kube"
mkdir -p "terraform/kube"

gcloud config set project "$PROJECT_ID"
gcloud container clusters get-credentials "$CLUSTER_NAME" --zone "$CLUSTER_ZONE"
