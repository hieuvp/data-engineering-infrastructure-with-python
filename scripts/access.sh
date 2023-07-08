#!/usr/bin/env bash

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Open up ports from the remote host
# and access applications on your local machine
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

set -eou pipefail

export KUBECONFIG="terraform/kube/config"

set -x

# shellcheck disable=SC2046
kill -9 $(lsof -t -c kubectl) || true
sleep 2s

set +x

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Kibana
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

KIBANA_PORT=5601
elasticsearch_username=$(cd terraform && terraform output -raw elasticsearch_username)
elasticsearch_password=$(cd terraform && terraform output -raw elasticsearch_password)

kubectl port-forward --namespace elastic service/kibana $KIBANA_PORT:$KIBANA_PORT &> /dev/null &

echo
echo "Kibana: http://127.0.0.1:${KIBANA_PORT}/"
echo "${elasticsearch_username}/${elasticsearch_password}"

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# NiFi
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

nifi_port=$(cd terraform && terraform output -raw nifi_port)
nifi_password=$(cd terraform && terraform output -raw nifi_password)

kubectl port-forward --namespace nifi service/nifi "${nifi_port}:${nifi_port}" &> /dev/null &

echo
echo "NiFi: https://127.0.0.1:${nifi_port}/nifi/"
echo "admin/${nifi_password}"
