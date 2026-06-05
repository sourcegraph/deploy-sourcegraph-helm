<!--
  DO NOT EDIT README.md directly.
  README.md is automatically generated from README.md.gotmpl
-->

# Sourcegraph Executor Helm Chart

This chart contains two deployments, Sourcegraph Executors and a private Docker Registry. It is a supplemental chart for the parent [sourcegraph/sourcegraph] Helm Chart if you wish to deploy executors.

> ⚠️ **Beta:** Docker-in-Docker Kubernetes executors are not recommended for production use.
> This method requires privileged access to a container runtime daemon. For production workloads,
> consider deploying via
> [Terraform](https://docs.sourcegraph.com/self-hosted/executors/deploy-executors-terraform) or
> [binary](https://docs.sourcegraph.com/self-hosted/executors/deploy-executors-binary).

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
| dind.daemonConfig | object | `{"insecure-registries":["private-docker-registry:5000"]}` | Docker daemon configuration passed as daemon.json to the dind sidecar. Learn more from: https://docs.docker.com/reference/cli/dockerd/#on-linux |
| dind.image.registry | string | `"index.docker.io"` |  |
| dind.image.repository | string | `"docker"` |  |
| dind.image.tag | string | `"20.10.22-dind"` |  |
| executor.env | object | `{}` | Extra environment variables to set on the executor container. Must NOT contain managed env vars (EXECUTOR_FRONTEND_URL, EXECUTOR_FRONTEND_PASSWORD, EXECUTOR_QUEUE_NAME, EXECUTOR_QUEUE_NAMES, SRC_LOG_LEVEL, SRC_LOG_FORMAT, EXECUTOR_MAXIMUM_NUM_JOBS, EXECUTOR_MAXIMUM_RUNTIME_PER_JOB, EXECUTOR_DOCKER_ADD_HOST_GATEWAY, EXECUTOR_KEEP_WORKSPACES). |
| executor.frontendExistingSecret | string | `""` | Name of existing k8s Secret to use for frontend password. The k8s Secret must contain the key EXECUTOR_FRONTEND_PASSWORD matching the site config executors.accessToken value. frontendPassword is ignored if this is set. |
| executor.frontendPassword | string | `""` | The shared secret configured in the Sourcegraph instance site config under executors.accessToken. Required if frontendExistingSecret is not configured. |
| executor.frontendUrl | string | `""` | The external URL of the Sourcegraph instance. Required. |
| executor.image.defaultTag | string | `"6.0.0@sha256:0be94a7c91f8273db10fdf46718c6596340ab2acc570e7b85353806e67a27508"` |  |
| executor.image.name | string | `"executor"` |  |
| executor.log.format | string | `"json"` |  |
| executor.log.level | string | `"warn"` | Possible values are dbug, info, warn, eror, crit. |
| executor.maximumNumJobs | int | `10` | The maximum amount of jobs that can be executed concurrently. |
| executor.maximumRuntimePerJob | string | `"30m"` | The maximum wall time that can be spent on a single job. |
| executor.queueName | string | `""` | The name of the queue to pull jobs from. Possible values: batches and codeintel. Either this or queueNames is required (when not using queues). |
| executor.queueNames | list | `[]` | The names of multiple queues to pull jobs from. Possible values: batches and codeintel. Either this or queueName is required (when not using queues). |
| executor.replicaCount | int | `1` |  |
| executor.resources | object | `{}` | Resource requests and limits for the executor container. Each queue can override this with its own resources field. |
| privateDockerRegistry.enabled | bool | `true` | Whether to deploy the private registry. Only one registry is needed when deploying multiple executors. More information: https://docs.sourcegraph.com/admin/executors/deploy_executors#using-private-registries |
| privateDockerRegistry.image.registry | string | `"index.docker.io"` |  |
| privateDockerRegistry.image.repository | string | `"registry"` |  |
| privateDockerRegistry.image.tag | int | `3` |  |
| privateDockerRegistry.storageSize | string | `"10Gi"` |  |
| queues | list | `[]` | Optional list of queues to deploy as standalone Deployments. When set, the single executor Deployment is not rendered. Each entry supports:   name        (required) — used as the deployment name suffix (executor-<name>)   queueName   — sets EXECUTOR_QUEUE_NAME; defaults to name if omitted   queueNames  — sets EXECUTOR_QUEUE_NAMES (comma-joined); takes precedence over queueName when set   replicaCount, resources, env (merged with executor.env, queue overrides) |
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
| sourcegraph.priorityClassName | string | `""` | Assign a priorityClass to all pods (daemonSets, deployments, and statefulSets) |
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
