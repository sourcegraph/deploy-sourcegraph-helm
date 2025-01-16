#!/bin/bash

set -euf -o pipefail

### Install the helm-unittest plugin
helm plugin install https://github.com/helm-unittest/helm-unittest

### Run the helm tests
helm unittest -3q charts/sourcegraph
