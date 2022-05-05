#!/bin/bash

set -euf -o pipefail


# Install asdf terraform plugin - managed by stateless agent configuration
# asdf plugin-add terraform https://github.com/asdf-community/asdf-hashicorp.git

# Install terraform via asdf
asdf install


asdf terraform init
asdf terraform plan
