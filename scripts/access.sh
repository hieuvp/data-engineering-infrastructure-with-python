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
KIBANA_PORT=5601
elastic_enabled=$(cd terraform && terraform output -raw elastic_enabled)

if [ "$elastic_enabled" = "true" ]; then

  elasticsearch_username=$(cd terraform && terraform output -raw elasticsearch_username)
  elasticsearch_password=$(cd terraform && terraform output -raw elasticsearch_password)

  kubectl port-forward --namespace elastic service/elasticsearch $ELASTICSEARCH_PORT:$ELASTICSEARCH_PORT &> /dev/null &

  echo
  echo "Elasticsearch:"
  echo "https://${elasticsearch_username}:${elasticsearch_password}@127.0.0.1:${ELASTICSEARCH_PORT}/"

  kubectl port-forward --namespace elastic service/kibana $KIBANA_PORT:$KIBANA_PORT &> /dev/null &

  echo
  echo "Kibana: http://127.0.0.1:${KIBANA_PORT}/"
  echo "${elasticsearch_username} / ${elasticsearch_password}"

fi

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# NiFi
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

nifi_port=$(cd terraform && terraform output -raw nifi_port)
nifi_password=$(cd terraform && terraform output -raw nifi_password)

kubectl port-forward --namespace nifi service/nifi "${nifi_port}:${nifi_port}" &> /dev/null &

echo
echo "NiFi: https://127.0.0.1:${nifi_port}/nifi/"
echo "admin / ${nifi_password}"

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Airflow
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

AIRFLOW_PORT=30237

kubectl port-forward --namespace airflow service/airflow-webserver "${AIRFLOW_PORT}:8080" &> /dev/null &

echo
echo "Airflow: http://127.0.0.1:${AIRFLOW_PORT}/"
echo "admin / admin"

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# PostgreSQL and pgAdmin 4
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

POSTGRESQL_PORT=5432
postgresql_password=$(cd terraform && terraform output -raw postgresql_password)

kubectl port-forward --namespace postgres service/postgresql $POSTGRESQL_PORT:$POSTGRESQL_PORT &> /dev/null &

echo
echo "PostgreSQL:"
echo "PGPASSWORD=${postgresql_password} psql --host=127.0.0.1 --port=${POSTGRESQL_PORT} --username=postgres"

PGADMIN_PORT=30238
pgadmin_email=$(cd terraform && terraform output -raw pgadmin_email)
pgadmin_password=$(cd terraform && terraform output -raw pgadmin_password)

kubectl port-forward --namespace postgres service/pgadmin4 "${PGADMIN_PORT}:80" &> /dev/null &

echo
echo "pgAdmin 4: http://127.0.0.1:${PGADMIN_PORT}/"
echo "${pgadmin_email} / ${pgadmin_password}"
echo "PostgreSQL Password: ${postgresql_password}"
