#!/usr/bin/env bash

set -eoux pipefail

trash helm-charts/elasticsearch
mkdir -p helm-charts/elasticsearch
cd helm-charts/elasticsearch

helm pull elastic/elasticsearch
tar -xvzf ./elasticsearch-*.tgz --strip-components 1
trash ./elasticsearch-*.tgz
