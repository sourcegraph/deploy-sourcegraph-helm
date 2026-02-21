# How to deploy this chart locally

!! Make sure you are pointing toward a local cluster
From the root of the repo

helm template test ./charts/sourcegraph -f ci/override.yaml | kubectl apply -f -
