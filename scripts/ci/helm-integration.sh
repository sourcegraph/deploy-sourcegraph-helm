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
  --create-namespace -n sourcegraph \
  --set sourcegraph.localDevMode=true \
  sourcegraph charts/sourcegraph/. || true

# Set the default namespace
kubectl config set-context --current --namespace sourcegraph

# Add a delay for registration to occur
sleep 5

# Wait for frontend pods to stabilize
kubectl wait --for=condition=Ready --timeout=5m pod -l app=sourcegraph-frontend

# We would want to do actual tests here ... 
kubectl get pods -n sourcegraph

# Cleanup
cd scripts/ci/terraform
terraform destroy -auto-approve || true
