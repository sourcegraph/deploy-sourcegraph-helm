#!/bin/bash

set -euf -o pipefail

### Install kubeval
wget https://github.com/yannh/kubeconform/releases/download/v0.4.12/kubeconform-linux-amd64.tar.gz
tar xf kubeconform-linux-amd64.tar.gz 
sudo cp kubeconform /usr/local/bin

### Run kubeval, validate k8s schema
helm template sourcegraph-helm-default ./sourcegraph >sourcegraph-helm-default.yaml
kubeconform -strict -schema-location https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/ sourcegraph-helm-default.yaml
