#!/bin/bash

set -euf -o pipefail


# Install asdf terraform plugin - managed by stateless agent configuration
# asdf plugin-add terraform https://github.com/asdf-community/asdf-hashicorp.git

# Install terraform via asdf
asdf install

cd scripts/ci/terraform

asdf exec terraform init
asdf exec terraform plan
