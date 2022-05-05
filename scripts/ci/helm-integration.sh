#!/bin/bash

set -euf -o pipefail


# Install asdf terraform plugin - managed by stateless agent configuration
# asdf plugin-add terraform https://github.com/asdf-community/asdf-hashicorp.git
#asdf plugin-add kubectl https://github.com/asdf-community/asdf-kubectl.git

# Install terraform via asdf
asdf install
asdf reshim

pushd $(pwd)
cd scripts/ci/terraform

terraform init
terraform apply -auto-approve || true

popd

# Smoke test, replaces manual testing
helm upgrade \
  --install \
  --create-namespace -n sourcegraph-${BUILDKITE_BUILD_NUMBER} \
  --set sourcegraph.localDevMode=true \
  sourcegraph charts/sourcegraph/. || true

sleep 10

kubectl get pods -n sourcegraph-${BUILDKITE_BUILD_NUMBER}

sleep 10

kubectl get pods -n sourcegraph-${BUILDKITE_BUILD_NUMBER}

# Cleanup
cd scripts/ci/terraform
terraform destroy -auto-approve || true
