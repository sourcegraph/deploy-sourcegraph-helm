#!/bin/bash

set -euf -o pipefail

### Install the helm-unittest plugin
helm plugin install https://github.com/quintush/helm-unittest

### Run the helm tests
helm lint sourcegraph
