# Network Policy: limit Executors to the Sourcegraph frontend API

## Why

- Executors run untrusted code from Batch Changes and auto-indexing jobs
- Kubernetes allows all pod-to-pod traffic by default, even across namespaces
- Executors only need the frontend API, so limit them to that

## What it does

`CiliumNetworkPolicy.yaml` contains one deny-only `CiliumNetworkPolicy` for the Executor pods. Docker-in-Docker jobs run as containers inside the Executor pod and share its network path, so this one policy covers both the Executor and its jobs. It denies egress to:

- Every Sourcegraph pod (`deploy=sourcegraph`) except `sourcegraph-frontend`
- `sourcegraph-frontend`'s internal (3090) and debug (6060) ports
- The cloud instance metadata service (`169.254.169.254`), so jobs cannot read node credentials

All other egress (DNS, code hosts, package registries, the frontend API) is unchanged. Cilium deny rules take precedence over any allow rules, and `enableDefaultDeny.egress: false` keeps this from becoming a new default-deny policy.

## How to use

- Set `io.kubernetes.pod.namespace` to the namespace Sourcegraph is deployed in
- Apply in the Executor's namespace, ex. `kubectl apply -n sourcegraph-executor -f CiliumNetworkPolicy.yaml`
- Verify from a job that `gitserver` is unreachable and `sourcegraph-frontend` still works

## Other CNIs

For clusters without Cilium, use the ingress-side native `NetworkPolicy` example in [`charts/sourcegraph/examples/network-policy`](../../../../sourcegraph/examples/network-policy), which is applied to the Sourcegraph release instead
