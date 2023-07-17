#!/usr/bin/env bash

set -eoux pipefail

trash helm-charts/spark
mkdir -p helm-charts/spark
cd helm-charts/spark

helm pull spark-operator/spark-operator
tar -xvzf ./spark-operator-*.tgz --strip-components 1
trash ./spark-operator-*.tgz
