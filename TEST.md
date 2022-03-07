# Sourcegraph Helm Chart Test Guide

This is a temporary test guide before we have more throughout automated integration tests.

## Lint

You shouldn't see any error.

```sh
helm lint charts/sourcegraph/.
```

## Unit testing

We utilize [helm-unittest], a BDD styled unit test framework, to validate our helm chart.

We currently do not have testing best practices or require unit tests for new changes, so add test cases at your best judgement if possible.

You may check out our [existing test cases](https://github.com/sourcegraph/deploy-sourcegraph-helm/tree/main/charts/sourcegraph/tests) and helm-unittest [docs](https://github.com/quintush/helm-unittest/blob/master/DOCUMENT.md).

## Manual testing

Create a local cluster with [kind]. You may also use [k3s] or [minikube].

```sh
kind create cluster
```

You should have a `override.yaml` file ready to verify your changes.

```yaml
# Disable SC creation
storageClass:
  create: false
  name: standard

# Disable resources requests/limits
sourcegraph:
  localDevMode: true
# More values to be added in order to test your change
```

It's a good idea to inspect the rendered manifest to catch things that look off.

```sh
helm template -f ./override.yaml sourcegraph charts/sourcegraph/.
```

Deploy the chart

```sh
helm upgrade --install --create-namespace -n sourcegraph -f ./override.yaml sourcegraph charts/sourcegraph/.
```

Follow the [confirm instance health] guide but use `kubectl port-forward` instead to validate instance health.

```sh
kubectl -n sourcegraph port-forward svc/sourcegraph-frontend 30080
```

[confirm instance health]: https://handbook.sourcegraph.com/departments/product-engineering/engineering/cloud/delivery/managed/upgrade_process/#8-confirm-instance-health
[k3s]: https://k3s.io/
[kind]: https://kind.sigs.k8s.io/
[minikube]: https://minikube.sigs.k8s.io/docs/start/
