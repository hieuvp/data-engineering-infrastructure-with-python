#!/usr/bin/env bash

set -eoux pipefail

trash helm-charts/elastic-operator
mkdir -p helm-charts/elastic-operator
cd helm-charts/elastic-operator

helm pull elastic/eck-operator
tar -xvzf ./eck-operator-*.tgz --strip-components 1
trash ./eck-operator-*.tgz
