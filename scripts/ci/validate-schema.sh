#!/bin/bash

set -euf -o pipefail

### Install kubeval
wget https://github.com/yannh/kubeconform/releases/download/v0.4.12/kubeconform-linux-amd64.tar.gz
tar xf kubeconform-linux-amd64.tar.gz
chmod +x kubeconform
sudo cp kubeconform /usr/local/bin

function validate_schema() {
  echo "Validating schema for $1"
  echo "Generating template output..."
  helm template sourcegraph-helm-default $1 > $2-helm-default.yaml
  kubeconform -verbose -summary -strict -schema-location https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/ $2-helm-default.yaml
}

validate_schema "./charts/sourcegraph" "sourcegraph"
validate_schema "./charts/sourcegraph-migrator" "sourcegraph-migrator"
validate_schema "./charts/sourcegraph-executor/k8s" "executor-k8s"
validate_schema "./charts/sourcegraph-executor/dind" "executor-dind"
