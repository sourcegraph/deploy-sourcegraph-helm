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
- `executor.extraEnv` - consult `values.yaml`

- `privateDockerRegistry.affinity` - [learn more](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#affinity-and-anti-affinity)
- `privateDockerRegistry.nodeSelector` - [learn more](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector)
- `privateDockerRegistry.tolerations` - [learn more](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/)
- `privateDockerRegistry.podSecurityContext` - [learn more](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod)
- `privateDockerRegistry.env` - consult `values.yaml` file

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| executor.affinity | object | `{}` | Affinity, learn more from the [Kubernetes documentation](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#affinity-and-anti-affinity) |
| executor.configureRbac | bool | `true` | Whether to configure the necessary RBAC resources. Required only once for all executor deployments. |
| executor.debug.keepJobs | string | `"false"` | If true, Kubernetes jobs will not be deleted after they complete. Not recommended for production use as it can hit cluster limits. |
| executor.debug.keepWorkspaces | string | `"false"` |  |
| executor.dockerAddHostGateway | string | `"false"` | For local deployments the host is 'host.docker.internal' and this needs to be true |
| executor.extraEnv | string | `nil` | Sets extra environment variables on the executor deployment. See `values.yaml` for the format. |
| executor.frontendExistingSecret | string | `""` | Name of existing k8s Secret to use for frontend password The name of the secret must match `executor.name`, i.e., the name of the helm release used to deploy the helm chart. The k8s Secret must contain the key `EXECUTOR_FRONTEND_PASSWORD` matching the site config `executors.accessToken` value. `executor.frontendPassword` is ignored if this is enabled. |
| executor.frontendPassword | string | `""` | The shared secret configured in the Sourcegraph instance site config under executors.accessToken. Required if `executor.frontendExistingSecret`` is not configured. |
| executor.frontendUrl | string | `""` | The external URL of the Sourcegraph instance. Required. **Recommended:** set to the internal service endpoint (e.g. `http://sourcegraph-frontend.sourcegraph.svc.cluster.local:30080` if Sourcegraph is deployed in the `sourcegraph` namespace). This will avoid unnecessary network charges as traffic will stay within the local network. |
| executor.image.defaultTag | string | `"6.12.1792@sha256:7dbd2ad48a4b23d1657694c030eb85a53a146a524d28466610db17c517a3a47c"` |  |
| executor.image.name | string | `"executor-kubernetes"` |  |
| executor.kubeconfigPath | string | `""` | The path to the kubeconfig file. If not specified, the in-cluster config is used. |
| executor.kubernetesJob.deadline | string | `"1200"` | The number of seconds after which a Kubernetes job will be terminated. |
| executor.kubernetesJob.fsGroup | string | `"1000"` | The group ID which is set on the job PVC file system. |
| executor.kubernetesJob.node.name | string | `""` | The name of the Kubernetes Node to create job pods on. If not specified, the pods are created on the first available node. |
| executor.kubernetesJob.node.requiredAffinityMatchExpressions | string | `""` | The JSON encoded required affinity match expressions for Kubernetes Jobs. e.g. '[{\"key\":\"foo\",\"operator\":\"In\",\"values\":[\"bar\"]}]' |
| executor.kubernetesJob.node.requiredAffinityMatchFields | string | `""` | The JSON encoded required affinity match fields for Kubernetes Jobs. e.g. '[{\"key\":\"foo\",\"operator\":\"In\",\"values\":[\"bar\"]}]' |
| executor.kubernetesJob.node.selector | string | `""` | A comma separated list of values to use as a node selector for Kubernetes Jobs. e.g. `foo=bar,app=my-app` |
| executor.kubernetesJob.node.tolerations | string | `""` | The JSON encoded tolerations for Kubernetes Jobs. e.g. '[{\"key\":\"foo\",\"operator\":\"Equal\",\"value\":\"bar\",\"effect\":\"NoSchedule\"}]' |
| executor.kubernetesJob.pod.affinity | string | `""` | The JSON encoded pod affinity for Kubernetes Jobs. e.g. '[{\"labelSelector\": {\"matchExpressions\": [{\"key\": \"foo\",\"operator\": \"In\",\"values\": [\"bar\"]}]},\"topologyKey\": \"kubernetes.io/hostname\"}]' |
| executor.kubernetesJob.pod.antiAffinity | string | `""` | The JSON encoded pod anti-affinity for Kubernetes Jobs. e.g. '[{\"labelSelector\": {\"matchExpressions\": [{\"key\": \"foo\",\"operator\": \"In\",\"values\": [\"bar\"]}]},\"topologyKey\": \"kubernetes.io/hostname\"}]' |
| executor.kubernetesJob.resources.limits.cpu | string | `""` | The maximum CPU for a job. |
| executor.kubernetesJob.resources.limits.memory | string | `"12Gi"` | The maximum memory for a job. |
| executor.kubernetesJob.resources.requests.cpu | string | `""` | The requested CPU for a job. |
| executor.kubernetesJob.resources.requests.memory | string | `"1Gi"` | The requested memory for a job. |
| executor.kubernetesJob.runAsGroup | int | `nil`; accepts [0, 2147483647] | The group ID to run Kubernetes jobs as. |
| executor.kubernetesJob.runAsUser | int | `nil`; accepts [0, 2147483647] | The user ID to run Kubernetes jobs as. |
| executor.log.format | string | `"condensed"` |  |
| executor.log.level | string | `"warn"` | Possible values are `dbug`, `info`, `warn`, `eror`, `crit`. |
| executor.log.trace | string | `"false"` |  |
| executor.maximumNumJobs | int | `10` | The maximum amount of jobs that can be executed concurrently. |
| executor.maximumRuntimePerJob | string | `"30m"` |  |
| executor.namespace | string | `"default"` | The namespace in which jobs are generated by the executor. |
| executor.nodeSelector | object | `{}` | NodeSelector, learn more from the [Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#nodeselector) |
| executor.queueName | string | `""` | The name of the queue to pull jobs from to. Possible values: batches and codeintel. **Either this or queueNames is required.** |
| executor.queueNames | list | `[]` | The names of multiple queues to pull jobs from to. Possible values: batches and codeintel. **Either this or queueName is required.** |
| executor.replicas | int | `1` |  |
| executor.resources.limits.cpu | string | `"1"` |  |
| executor.resources.limits.memory | string | `"1Gi"` |  |
| executor.resources.requests.cpu | string | `"500m"` |  |
| executor.resources.requests.memory | string | `"200Mi"` |  |
| executor.securityContext | object | `{"fsGroup":null,"privileged":false,"runAsGroup":null,"runAsUser":null}` | The containerSecurityContext for the executor image |
| executor.storageSize | string | `"10Gi"` | The storage size of the PVC attached to the executor deployment. |
| executor.tolerations | list | `[]` | Tolerations, learn more from the [Kubernetes documentation](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) |
| sourcegraph.affinity | object | `{}` | Affinity, learn more from the [Kubernetes documentation](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#affinity-and-anti-affinity) |
| sourcegraph.image.defaultTag | string | `"{{ .Chart.AppVersion }}"` | Global docker image tag |
| sourcegraph.image.pullPolicy | string | `"IfNotPresent"` | Global docker image pull policy |
| sourcegraph.image.repository | string | `"us-docker.pkg.dev/sourcegraph-images/internal"` | Global docker image registry or prefix |
| sourcegraph.image.useGlobalTagAsDefault | bool | `false` | When set to true, sourcegraph.image.defaultTag is used as the default defaultTag for all services, instead of service-specific default defaultTags |
| sourcegraph.imagePullSecrets | list | `[]` | Mount named secrets containing docker credentials |
| sourcegraph.labels | object | `{}` | Add a global label to all resources |
| sourcegraph.localDevMode | bool | `false` | When true, remove all resource stanzas, allowing the scheduler to best-fit pods. Intended for local development with limited resources. |
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
