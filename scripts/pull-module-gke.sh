#!/usr/bin/env bash

set -eoux pipefail

trash terraform-modules/google-kubernetes-engine
git clone https://github.com/terraform-google-modules/terraform-google-kubernetes-engine.git terraform-modules/google-kubernetes-engine

trash terraform-modules/google-kubernetes-engine/.git
trash terraform-modules/google-kubernetes-engine/.github
trash terraform-modules/google-kubernetes-engine/build
