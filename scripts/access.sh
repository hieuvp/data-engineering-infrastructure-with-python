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
# Elasticsearch and Kibana
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

ELASTICSEARCH_PORT=9200
KIBANA_LOCAL_PORT=5601
KIBANA_REMOTE_PORT=8080

elastic_enabled=$(cd terraform && terraform output -raw elastic_enabled)

if [ "$elastic_enabled" = "true" ]; then

  elasticsearch_password=$(kubectl get secret elasticsearch-es-elastic-user --namespace elastic --output go-template="{{.data.elastic | base64decode}}")

  kubectl port-forward --namespace elastic service/elasticsearch-es-http $ELASTICSEARCH_PORT:$ELASTICSEARCH_PORT &> /dev/null &

  echo
  echo "Elasticsearch:"
  echo "https://elastic:${elasticsearch_password}@127.0.0.1:${ELASTICSEARCH_PORT}/"

  kubectl port-forward --namespace elastic service/kibana-kb-http "${KIBANA_LOCAL_PORT}:${KIBANA_REMOTE_PORT}" &> /dev/null &

  echo
  echo "Kibana:"
  echo "https://127.0.0.1:${KIBANA_LOCAL_PORT}/"

  kibana_external_ip=$(kubectl get service kibana-kb-http --namespace elastic --output jsonpath="{.status.loadBalancer.ingress[0].ip}")

  if [ -n "$kibana_external_ip" ]; then
    echo "https://${kibana_external_ip}.nip.io:${KIBANA_REMOTE_PORT}/"
  fi

  echo "elastic / ${elasticsearch_password}"

fi

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# NiFi
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

nifi_port=$(cd terraform && terraform output -raw nifi_port)
nifi_password=$(cd terraform && terraform output -raw nifi_password)

kubectl port-forward --namespace nifi service/nifi "${nifi_port}:${nifi_port}" &> /dev/null &

echo
echo "NiFi:"
echo "https://127.0.0.1:${nifi_port}/nifi/"

nifi_external_ip=$(kubectl get service --selector app=nifi --namespace nifi --output jsonpath="{.items[0].status.loadBalancer.ingress[0].ip}")

if [ -n "$nifi_external_ip" ]; then
  echo "https://${nifi_external_ip}.nip.io:${nifi_port}/nifi/"
fi

echo "admin / ${nifi_password}"

NIFI_REGISTRY_LOCAL_PORT=18080
NIFI_REGISTRY_REMOTE_PORT=8080

kubectl port-forward --namespace nifi service/nifi-registry "${NIFI_REGISTRY_LOCAL_PORT}:${NIFI_REGISTRY_REMOTE_PORT}" &> /dev/null &

echo
echo "NiFi Registry:"
echo "http://127.0.0.1:${NIFI_REGISTRY_LOCAL_PORT}/nifi-registry/"

nifi_registry_external_ip=$(kubectl get service --selector app.kubernetes.io/name=registry --namespace nifi --output jsonpath="{.items[0].status.loadBalancer.ingress[0].ip}")

if [ -n "$nifi_registry_external_ip" ]; then
  echo "http://${nifi_registry_external_ip}.nip.io:${NIFI_REGISTRY_REMOTE_PORT}/nifi-registry/"
fi

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Airflow
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

AIRFLOW_LOCAL_PORT=30237
AIRFLOW_REMOTE_PORT=8080

airflow_password=$(cd terraform && terraform output -raw airflow_password)

kubectl port-forward --namespace airflow service/airflow-webserver "${AIRFLOW_LOCAL_PORT}:${AIRFLOW_REMOTE_PORT}" &> /dev/null &

echo
echo "Airflow:"
echo "http://127.0.0.1:${AIRFLOW_LOCAL_PORT}/"

airflow_external_ip=$(kubectl get service --selector component=webserver --namespace airflow --output jsonpath="{.items[0].status.loadBalancer.ingress[0].ip}")

if [ -n "$airflow_external_ip" ]; then
  echo "http://${airflow_external_ip}.nip.io:${AIRFLOW_REMOTE_PORT}/"
fi

echo "admin / ${airflow_password}"

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# PostgreSQL and pgAdmin 4
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

POSTGRESQL_PORT=5432

postgresql_password=$(cd terraform && terraform output -raw postgresql_password)

kubectl port-forward --namespace postgres service/postgresql $POSTGRESQL_PORT:$POSTGRESQL_PORT &> /dev/null &

echo
echo "PostgreSQL:"
echo "PGPASSWORD=${postgresql_password} psql --host=127.0.0.1 --port=${POSTGRESQL_PORT} --username=postgres"

PGADMIN_LOCAL_PORT=30238
PGADMIN_REMOTE_PORT=80

pgadmin_email=$(cd terraform && terraform output -raw pgadmin_email)
pgadmin_password=$(cd terraform && terraform output -raw pgadmin_password)

kubectl port-forward --namespace postgres service/pgadmin4 "${PGADMIN_LOCAL_PORT}:${PGADMIN_REMOTE_PORT}" &> /dev/null &

echo
echo "pgAdmin 4:"
echo "http://127.0.0.1:${PGADMIN_LOCAL_PORT}/"

pgadmin_external_ip=$(kubectl get service --selector app.kubernetes.io/name=pgadmin4 --namespace postgres --output jsonpath="{.items[0].status.loadBalancer.ingress[0].ip}")

if [ -n "$pgadmin_external_ip" ]; then
  echo "http://${pgadmin_external_ip}.nip.io/"
fi

echo "${pgadmin_email} / ${pgadmin_password}"
echo "PostgreSQL Password: ${postgresql_password}"
