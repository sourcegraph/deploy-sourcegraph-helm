# Network Policy: limit Executors to the Sourcegraph frontend API

## Why

- Executors run untrusted code from Batch Changes and auto-indexing jobs
- Kubernetes allows all pod-to-pod traffic by default, even across namespaces
- Executors only need the frontend API, so limit them to that

## What it does

`override.yaml` adds two `NetworkPolicy` resources to the Sourcegraph namespace via `extraResources`:

- `sourcegraph-executor-frontend-only`: only allows ingress to Sourcegraph pods from pods in the same namespace which are not Executors (`app.kubernetes.io/component=executor`) or Executor jobs (`sourcegraph/job-id`, `sourcegraph/run-id`)
- `sourcegraph-frontend-allow-http`: allows the authenticated frontend API (port `http`, 3080) from anywhere, so ingress controllers, users, and Executors keep working

## How to use

- Confirm your CNI enforces `NetworkPolicy` (most do; Cilium, Calico, and OpenShift SDN all do)
- Add the contents of `override.yaml` to your Helm values override file, or pass it as an extra `-f override.yaml`
- If pods outside the Sourcegraph namespace need to reach Sourcegraph pods (ex. a cluster-wide Prometheus), uncomment `namespaceSelector: {}`
- Upgrade the release, then verify from an Executor job pod that `gitserver` is unreachable and `sourcegraph-frontend` still works

## Cilium

If your cluster uses Cilium and this native policy does not take effect, use the egress-side `CiliumNetworkPolicy` example for your Executor chart instead:

- [`charts/sourcegraph-executor/k8s/examples/network-policy`](../../../sourcegraph-executor/k8s/examples/network-policy)
- [`charts/sourcegraph-executor/dind/examples/network-policy`](../../../sourcegraph-executor/dind/examples/network-policy)
