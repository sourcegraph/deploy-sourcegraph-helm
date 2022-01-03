#!/bin/bash

set -euf -o pipefail

### Run the helm tests
helm lint sourcegraph
