#!/bin/bash

set -euf -o pipefail

### Install kubeval
wget https://github.com/instrumenta/kubeval/releases/latest/download/kubeval-linux-amd64.tar.gz
tar xf kubeval-linux-amd64.tar.gz
sudo cp kubeval /usr/local/bin

### Run kubeval, validate k8s schema
helm template sourcegraph-helm-default ./sourcegraph >sourcegraph-helm-default.yaml
kubeval --strict --schema-location https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/ sourcegraph-helm-default.yaml
