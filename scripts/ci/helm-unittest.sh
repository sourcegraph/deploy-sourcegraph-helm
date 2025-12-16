#!/bin/bash

set -euf -o pipefail

# 1.0.3 is broken now
# https://github.com/helm-unittest/helm-unittest/issues/790
HELM_UNITTEST_VERSION="v1.0.2"

### Install the helm-unittest plugin
helm plugin install https://github.com/helm-unittest/helm-unittest --version "$HELM_UNITTEST_VERSION"

### Run the helm tests
helm unittest -q charts/sourcegraph
