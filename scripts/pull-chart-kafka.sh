#!/usr/bin/env bash

set -eoux pipefail

trash helm-charts/kafka
mkdir -p helm-charts/kafka
cd helm-charts/kafka

helm pull strimzi/strimzi-kafka-operator
tar -xvzf ./strimzi-kafka-operator-*.tgz --strip-components 1
trash ./strimzi-kafka-operator-*.tgz
