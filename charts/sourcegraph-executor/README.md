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
| dind.image.registry | string | `"index.docker.io"` |  |
| dind.image.repository | string | `"docker"` |  |
| dind.image.tag | string | `"20.10.22-dind"` |  |
| executor.enabled | bool | `true` |  |
| executor.env.EXECUTOR_FRONTEND_PASSWORD | object | `{"value":""}` | The shared secret configured in the Sourcegraph instance site config under executors.accessToken. Required. |
| executor.env.EXECUTOR_FRONTEND_URL | object | `{"value":""}` | The external URL of the Sourcegraph instance. Required. |
| executor.env.EXECUTOR_QUEUE_NAME | object | `{"value":""}` | The name of the queue to pull jobs from to. Possible values: batches and codeintel. Required. |
| executor.image.defaultTag | string | `"5.0.0@sha256:e194294a16c289dde5f36187554f43f9407dfb856f7f18c560ccb3491ba88b4a"` |  |
| executor.image.name | string | `"executor"` |  |
| privateDockerRegistry.image.registry | string | `"index.docker.io"` |  |
| privateDockerRegistry.image.repository | string | `"docker/regisry"` |  |
| privateDockerRegistry.image.tag | int | `2` |  |
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
| storageClass.allowedTopologies | object | `{}` | Persistent volumes topology configuration, learn more from the [Kubernetes documentation](https://kubernetes.io/docs/concepts/storage/storage-classes/#allowed-topologies) |
| storageClass.create | bool | `false` | Enable creation of storageClass. Defaults to Google Cloud Platform. Disable if you have your own existing storage class |
| storageClass.name | string | `"sourcegraph"` | Name of the storageClass. Use to customize to the existing storage class name |
| storageClass.parameters | object | `{}` | Extra parameters of storageClass, consult your cloud provider persistent storage documentation |
| storageClass.provisioner | string | `"kubernetes.io/gce-pd"` | Name of the storageClass provisioner, learn more from the [Kubernetes documentation](https://kubernetes.io/docs/concepts/storage/storage-classes/#provisioner) and consult your cloud provider persistent storage documentation |
| storageClass.type | string | `"pd-ssd"` | Value of `type` key in storageClass `parameters`, consult your cloud provider persistent storage documentation |

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
