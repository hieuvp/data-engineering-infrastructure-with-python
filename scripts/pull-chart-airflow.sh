#!/usr/bin/env bash

set -eoux pipefail

trash helm-charts/airflow
mkdir -p helm-charts/airflow
cd helm-charts/airflow

helm pull apache-airflow/airflow
tar -xvzf ./airflow-*.tgz --strip-components 1
trash ./airflow-*.tgz
