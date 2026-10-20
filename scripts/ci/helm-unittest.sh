#!/bin/bash

set -euf -o pipefail

HELM_UNITTEST_VERSION="v1.2.1"

### Install the helm-unittest plugin
helm plugin install https://github.com/helm-unittest/helm-unittest --version "$HELM_UNITTEST_VERSION" --verify=false

### Run the helm tests
helm unittest -q charts/sourcegraph
