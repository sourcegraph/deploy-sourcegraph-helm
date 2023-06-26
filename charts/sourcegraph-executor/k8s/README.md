<!--
  DO NOT EDIT README.md directly.
  README.md is automatically generated from README.md.gotmpl
-->

# Sourcegraph Executor Helm Chart

This chart contains two deployments, Sourcegraph Kubernetes native Executors and a private Docker Registry. It is a supplemental chart for the parent [sourcegraph/sourcegraph] Helm Chart if you wish to deploy Kubernetes native executors.

Use cases:

- Deploy Sourcegraph Kubernetes native Executors on Kubernetes

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
| executor.affinity | object | `{}` | Affinity, learn more from the [Kubernetes documentation](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#affinity-and-anti-affinity) |
| executor.debug.keepJobs | string | `"false"` |  |
| executor.debug.keepWorkspaces | string | `"false"` |  |
| executor.dockerAddHostGateway | string | `"false"` | For local deployments the host is 'host.docker.internal' and this needs to be true |
| executor.enabled | bool | `true` |  |
| executor.extraEnv | string | `nil` |  |
| executor.frontendPassword | string | `""` | The shared secret configured in the Sourcegraph instance site config under executors.accessToken. Required. |
| executor.frontendUrl | string | `""` | The external URL of the Sourcegraph instance. Required. |
| executor.image.defaultTag | string | `"main-dry-run-rc-k8s-directory-creation_215977_2023-04-28_5.0-9b4f55fbff85@sha256:e11a50201f4e619f25b35edc26b037dc4f931073dc1bb10f34bbc17d670bd88d"` |  |
| executor.image.name | string | `"executor-kubernetes"` |  |
| executor.kubeconfigPath | string | `""` |  |
| executor.kubernetesJob.deadline | string | `"1200"` |  |
| executor.kubernetesJob.fsGroup | string | `"1000"` |  |
| executor.kubernetesJob.node.name | string | `""` |  |
| executor.kubernetesJob.node.requiredAffinityMatchExpressions | string | `""` |  |
| executor.kubernetesJob.node.requiredAffinityMatchFields | string | `""` |  |
| executor.kubernetesJob.node.selector | string | `""` |  |
| executor.kubernetesJob.node.tolerations | string | `""` |  |
| executor.kubernetesJob.pod.affinity | string | `""` |  |
| executor.kubernetesJob.pod.antiAffinity | string | `""` |  |
| executor.kubernetesJob.resources.limits.cpu | string | `""` |  |
| executor.kubernetesJob.resources.limits.memory | string | `"12Gi"` |  |
| executor.kubernetesJob.resources.requests.cpu | string | `""` |  |
| executor.kubernetesJob.resources.requests.memory | string | `"1Gi"` |  |
| executor.kubernetesJob.runAsGroup | string | `""` |  |
| executor.kubernetesJob.runAsUser | string | `""` |  |
| executor.log.format | string | `"condensed"` |  |
| executor.log.level | string | `"info"` |  |
| executor.log.trace | string | `"false"` |  |
| executor.maximumNumJobs | int | `10` |  |
| executor.maximumRuntimePerJob | string | `"30m"` |  |
| executor.namespace | string | `"default"` |  |
| executor.nodeSelector | object | `{}` | NodeSelector, learn more from the [Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#nodeselector) |
| executor.queueName | string | `""` | The name of the queue to pull jobs from to. Possible values: batches and codeintel. Either this or queueNames is required. |
| executor.queueNames | list | `[]` | The names of multiple queues to pull jobs from to. Possible values: batches and codeintel. Either this or queueName is required. |
| executor.replicas | int | `1` |  |
| executor.storageSize | string | `"10Gi"` |  |
| executor.tolerations | list | `[]` | Tolerations, learn more from the [Kubernetes documentation](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) |
| privateDockerRegistry | object | `{"enabled":true,"image":{"registry":"index.docker.io","repository":"registry","tag":2},"storageSize":"1Gi"}` | Whether to deploy the private registry. Only one registry is needed when deploying multiple executors. More information: https://docs.sourcegraph.com/admin/executors/deploy_executors#using-private-registries |
| rbac | object | `{"enabled":true}` | Whether to configure the necessary RBAC resources. Required only once for all executor deployments. |
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
