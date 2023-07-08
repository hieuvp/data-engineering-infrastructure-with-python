#!/usr/bin/env bash

set -eoux pipefail

(
  cd scripts
  chmod +x ./*.sh
  shfmt -i 2 -ci -sr -bn -s -w ./*.sh
)

(
  prettier --write README.md
)

(
  cd terraform
  terraform fmt
  prettier --write ./*.yaml
)
