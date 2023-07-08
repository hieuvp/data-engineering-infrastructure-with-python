#!/usr/bin/env bash

set -eoux pipefail

trash helm-charts/pgadmin4
mkdir -p helm-charts/pgadmin4
cd helm-charts/pgadmin4

helm pull runix/pgadmin4
tar -xvzf ./pgadmin4-*.tgz --strip-components 1
trash ./pgadmin4-*.tgz
