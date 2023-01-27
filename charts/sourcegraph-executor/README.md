<!--
  DO NOT EDIT README.md directly.
  README.md is automatically generated from README.md.gotmpl
-->

# Sourcegraph Exexutor Helm Chart

This chart contains two deployments, Sourcegraph Executors and a private Docker Registry. It is a supplemental chart for the parent [sourcegraph/sourcegraph] Helm Chart if you wish to deploy executors

Use cases:

- Deploy Sourcegraph Executors on Kubernetes

## Requirements

* [Helm 3 CLI](https://helm.sh/docs/intro/install/)
* Kubernetes 1.19 or greater

## Installation

Add the Sourcegraph charts repo to Helm:

```sh
helm repo add sourcegraph https://helm.sourcegraph.com/release
```

## Usage

> The chart has to be installed in the same namespace as the parent [sourcegraph/sourcegraph] chart

## Rendering manifests for kubectl deployment

Manifests rendered using the `helm template` command can be used for direct deployment using `kubectl`.

## Configuration Options

Reference the table below for available configuration parameters and consult [executor] documentation.

In addition to the documented values, the `executor` and `private-docker-registry` services also supports the following values

- `executor.affinity` - [learn more](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#affinity-and-anti-affinity)
- `executor.nodeSelector` - [learn more](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector)
- `executor.tolerations` - [learn more](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/)
- `executor.podSecurityContext` - [learn more](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod)
- `executor.env` - consult `values.yaml`

- `privateDockerRegistry.affinity` - [learn more](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#affinity-and-anti-affinity)
- `privateDockerRegistry.nodeSelector` - [learn more](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector)
- `privateDockerRegistry.tolerations` - [learn more](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/)
- `privateDockerRegistry.podSecurityContext` - [learn more](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod)
- `privateDockerRegistry.env` - consult `values.yaml` file

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| executor.dind.image.repository | string | `"index.docker.io/docker:20.10.22-dind@sha256"` |  |
| executor.dind.image.tag | string | `"03f2d563100b9776283de1e18f10a1f0b66d2fdc7918831bf8db1cda767d6b37"` |  |
| executor.enabled | bool | `true` |  |
| executor.executor.image.defaultTag | string | `"4.4.1@sha256:ec8bd27e8599694cfb24341c564b0e4e8947f863d98c4f5b1cb6e67dd8697f53"` |  |
| executor.executor.image.env.EXECUTOR_FRONTEND_PASSWORD.value | string | `nil` |  |
| executor.executor.image.env.EXECUTOR_FRONTEND_URL.value | string | `nil` |  |
| executor.executor.image.env.EXECUTOR_QUEUE_NAME.value | string | `nil` |  |
| executor.executor.image.env.SRC_ACCESS_TOKEN.value | string | `nil` |  |
| executor.executor.image.env.SRC_ENDPOINT.value | string | `nil` |  |
| executor.executor.image.name | string | `"executor"` |  |
| privateDockerRegistry.enabled | bool | `true` |  |
| privateDockerRegistry.image.repository | string | `"index.docker.io/registry:2@sha256"` |  |
| privateDockerRegistry.image.tag | string | `"03f2d563100b9776283de1e18f10a1f0b66d2fdc7918831bf8db1cda767d6b37"` |  |
| sourcegraph.affinity | object | `{}` | Affinity, learn more from the [Kubernetes documentation](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#affinity-and-anti-affinity) |
| sourcegraph.image.defaultTag | string | `"{{ .Chart.AppVersion }}"` | Global docker image tag |
| sourcegraph.image.pullPolicy | string | `"IfNotPresent"` | Global docker image pull policy |
| sourcegraph.image.repository | string | `"index.docker.io/sourcegraph"` | Global docker image registry or prefix |
| sourcegraph.image.useGlobalTagAsDefault | bool | `false` | When set to true, sourcegraph.image.defaultTag is used as the default defaultTag for all services, instead of service-specific default defaultTags |
| sourcegraph.imagePullSecrets | list | `[]` | Mount named secrets containing docker credentials |
| sourcegraph.labels | object | `{}` | Add a global label to all resources |
| sourcegraph.nameOverride | string | `""` | Set a custom name for the app.kubernetes.io/name annotation |
| sourcegraph.nodeSelector | object | `{}` | NodeSelector, learn more from the [Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#nodeselector) |
| sourcegraph.podAnnotations | object | `{}` | Add extra annotations to attach to all pods |
| sourcegraph.podLabels | object | `{}` | Add extra labels to attach to all pods |
| sourcegraph.tolerations | list | `[]` | Tolerations, learn more from the [Kubernetes documentation](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) |

## Troubleshooting

See a list of running executor pods

```sh
kubectl get pods -l app=executor
```

Check logs of the executor container

```sh
kubectl logs -l app=executor -c executor
```

[sourcegraph/sourcegraph]: ../sourcegraph/
[sourcegraph/sourcegraph-executor]: ./
[executor]: https://docs.sourcegraph.com/admin/executors