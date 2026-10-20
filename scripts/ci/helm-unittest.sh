#!/bin/bash

set -euf -o pipefail

# 1.0.3 is broken now
# https://github.com/helm-unittest/helm-unittest/issues/790
HELM_UNITTEST_VERSION="v1.0.2"

### Install the helm-unittest plugin
helm plugin install https://github.com/helm-unittest/helm-unittest --version "$HELM_UNITTEST_VERSION" --verify=false

### Run the helm tests
# helm unittest runs every chart even after a failure, prints a per-chart
# summary, and exits non-zero if any chart failed.
helm unittest \
  charts/sourcegraph \
  charts/sourcegraph-migrator \
  charts/sourcegraph-executor/k8s \
  charts/sourcegraph-executor/dind
