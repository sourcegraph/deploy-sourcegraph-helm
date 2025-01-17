# Sourcegraph Helm Chart Test Guide

This is a temporary test guide before we have more thorough automated integration tests.

## Lint

You shouldn't see any error.

```sh
helm lint charts/sourcegraph/.
```

## Unit testing

We utilize [helm-unittest](https://github.com/helm-unittest/helm-unittest/), a BDD styled unit test framework, to validate our helm chart.

helm-unittest can be installed with:

```bash
helm plugin install https://github.com/helm-unittest/helm-unittest
```

Once the plugin is installed, you can run the unit tests using the following:

```bash
helm unittest --helm3 ./charts/sourcegraph/.
```

We currently do not have testing best practices or require unit tests for new changes, so add test cases at your best judgement if possible.

You may check out our [existing test cases](https://github.com/sourcegraph/deploy-sourcegraph-helm/tree/main/charts/sourcegraph/tests) and helm-unittest [docs](https://github.com/helm-unittest/helm-unittest/blob/master/DOCUMENT.md).

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

Make sure you test both enabled and disabled toggles. For example, if you added a new values to conditional render some templates, turn it on and off in the `override.yaml` to make sure they both work. You can also include your `override.yaml` in the `Test plan` during PR review to help others understand your testing strategy.

### Inspect the entire rendered template

It's a good idea to inspect the rendered manifest to catch things that look off.

```sh
helm template -f ./override.yaml sourcegraph charts/sourcegraph/.
```

### Inspect the diff

Perform a diff of the rendered helm manifests before and after your change. There're many ways to produce the diff:

- Run `helm template` before and after the change, then run `diff bundle.old.yaml bundle.new.yaml`.
- Run `helm install` before the change, then run `helm diff` to inspect the diff.

### Deploy the chart

You should make sure your change can be deployed

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
