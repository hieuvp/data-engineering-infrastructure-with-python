#!/usr/bin/env bash

set -eoux pipefail

trash helm-charts/kibana
mkdir -p helm-charts/kibana
cd helm-charts/kibana

helm pull elastic/kibana
tar -xvzf ./kibana-*.tgz --strip-components 1
trash ./kibana-*.tgz
