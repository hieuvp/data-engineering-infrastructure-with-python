#!/usr/bin/env bash

set -eoux pipefail

trash helm-charts/elastic
mkdir -p helm-charts/elastic
cd helm-charts/elastic

helm pull elastic/eck-operator
tar -xvzf ./eck-operator-*.tgz --strip-components 1
trash ./eck-operator-*.tgz
