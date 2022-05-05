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

# checkout main branch
git checkout main charts/sourcegraph

# integration test: install chart at main branch ref
helm upgrade \
  --install \
  --create-namespace -n sourcegraph \
  --wait \
  --set sourcegraph.localDevMode=true \
  sourcegraph charts/sourcegraph/. || true

# Set the default namespace
kubectl config set-context --current --namespace sourcegraph

# Wait for frontend pods to stabilize
kubectl wait --for=condition=Ready --timeout=5m pod -l app=sourcegraph-frontend

# checkout current branch
git reset HEAD --hard

# verify git-fu 
git status

# integration test: install chart with changes in this branch
helm upgrade \
  --install \
  --create-namespace -n sourcegraph \
  --wait \
  --set sourcegraph.localDevMode=true \
  sourcegraph charts/sourcegraph/. || true

# Wait for frontend pods to stabilize
kubectl wait --for=condition=Ready --timeout=5m pod -l app=sourcegraph-frontend

# We would want to do actual tests here ... 
kubectl get pods -n sourcegraph

# Cleanup
cd scripts/ci/terraform
terraform destroy -auto-approve || true
