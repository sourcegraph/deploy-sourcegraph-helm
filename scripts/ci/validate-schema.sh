#!/bin/bash

set -euf -o pipefail

### Install kubeval
wget https://github.com/yannh/kubeconform/releases/download/v0.4.12/kubeconform-linux-amd64.tar.gz
tar xf kubeconform-linux-amd64.tar.gz
chmod +x kubeconform
sudo cp kubeconform /usr/local/bin

### Run kubeconform, validate k8s schema
echo "Generating template output..."
helm template sourcegraph-helm-default ./sourcegraph >sourcegraph-helm-default.yaml

kubeconform -verbose -summary -strict -schema-location https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/ sourcegraph-helm-default.yaml
