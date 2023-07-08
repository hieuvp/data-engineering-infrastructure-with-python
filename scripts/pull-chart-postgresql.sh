#!/usr/bin/env bash

set -eoux pipefail

trash helm-charts/postgresql
mkdir -p helm-charts/postgresql
cd helm-charts/postgresql

helm pull oci://registry-1.docker.io/bitnamicharts/postgresql
tar -xvzf ./postgresql-*.tgz --strip-components 1
trash ./postgresql-*.tgz
