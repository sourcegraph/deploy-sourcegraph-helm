#!/bin/bash

set -euf -o pipefail

### Install the helm-unittest plugin
helm plugin install https://github.com/quintush/helm-unittest --version v0.2.11

### Run the helm tests
helm unittest -3q charts/sourcegraph
