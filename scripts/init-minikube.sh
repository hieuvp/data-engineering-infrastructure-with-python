#!/usr/bin/env bash

set -eoux pipefail

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# In order to have a K8S environment to work,
# execute this script from the remote host.
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

minikube stop || true
minikube delete || true

minikube start --driver=docker \
  --memory=14000 \
  --cpus=6 \
  --apiserver-ips="$REMOTE_HOST" \
  --listen-address="0.0.0.0"

minikube update-context
