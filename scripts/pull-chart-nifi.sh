#!/usr/bin/env bash

set -eoux pipefail

trash helm-charts/nifi
mkdir -p helm-charts/nifi
cd helm-charts/nifi

helm pull cetic/nifi
tar -xvzf ./nifi-*.tgz --strip-components 1
trash ./nifi-*.tgz
