#!/usr/bin/env bash

set -eoux pipefail

source scripts/set-env.sh

trash "terraform/kube"
mkdir -p "terraform/kube"

scp "${REMOTE_USER}@${REMOTE_HOST}:/Users/${REMOTE_USER}/.kube/config" "terraform/kube/config"
scp "${REMOTE_USER}@${REMOTE_HOST}:/Users/${REMOTE_USER}/.minikube/profiles/minikube/client.crt" "terraform/kube/client.crt"
scp "${REMOTE_USER}@${REMOTE_HOST}:/Users/${REMOTE_USER}/.minikube/profiles/minikube/client.key" "terraform/kube/client.key"
scp "${REMOTE_USER}@${REMOTE_HOST}:/Users/${REMOTE_USER}/.minikube/ca.crt" "terraform/kube/ca.crt"

sed -i "s/https:\/\/127.0.0.1/https:\/\/${REMOTE_HOST}/g" "terraform/kube/config"
sed -i "s/\/Users\/${REMOTE_USER}\/.minikube\/profiles\/minikube\///g" "terraform/kube/config"
sed -i "s/\/Users\/${REMOTE_USER}\/.minikube\///g" "terraform/kube/config"
