#!/usr/bin/env bash

set -eoux pipefail

trash helm-charts/elastic-stack
mkdir -p helm-charts/elastic-stack
cd helm-charts/elastic-stack

helm pull elastic/eck-stack
tar -xvzf ./eck-stack-*.tgz --strip-components 1
trash ./eck-stack-*.tgz
