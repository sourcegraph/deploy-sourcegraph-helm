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
  helm template sourcegraph-helm-default ./charts/$1 > $1-helm-default.yaml
  kubeconform -verbose -summary -strict -schema-location https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/ $1-helm-default.yaml
}

validate_schema "sourcegraph"
validate_schema "sourcegraph-migrator"
validate_schema "sourcegraph-executor/k8s"
validate_schema "sourcegraph-executor/dind"
