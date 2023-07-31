#!/usr/bin/env bash

# GKE cluster won't delete the persistent disks that are associated with PVCs during destruction.
# This step will perform a complete deletion of the persistent disks in order to save money.

set -eou pipefail

PROJECT_ID=$(cd kubernetes/gke && echo "var.project_id" | terraform console | sed 's/"//g')
CLUSTER_ZONE=$(cd kubernetes/gke && echo "var.zone" | terraform console | sed 's/"//g')

set -x

gcloud config set project "$PROJECT_ID"

set +x

gcloud compute disks list --format "value(uri())" --zones "$CLUSTER_ZONE" --filter="name~^gke-" \
  | while IFS= read -r line; do
    echo "Destroying disk... $line"
    gcloud compute disks delete --quiet "$line"
  done

gcloud compute disks list --format "value(uri())" --zones "$CLUSTER_ZONE" --filter="name~^pvc-" \
  | while IFS= read -r line; do
    echo "Destroying disk... $line"
    gcloud compute disks delete --quiet "$line"
  done
