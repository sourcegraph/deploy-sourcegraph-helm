#!/bin/bash

set -euf -o pipefail


# Install asdf terraform plugin - managed by stateless agent configuration
# asdf plugin-add terraform https://github.com/asdf-community/asdf-hashicorp.git
#asdf plugin-add kubectl https://github.com/asdf-community/asdf-kubectl.git

# Install terraform via asdf
asdf install
asdf reshim

cd scripts/ci/terraform

terraform init
terraform apply -auto-approve

echo "TESTS would happen here"

terraform destroy -auto-approve
