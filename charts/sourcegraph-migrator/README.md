<!--
  DO NOT EDIT README.md directly.
  README.md is automatically generated from README.md.gotmpl
-->

# Sourcegraph Migrator Helm Chart

This chart contains a single [Job] to run [migrator] operations. It is a supplemental chart for the parent [sourcegraph/sourcegraph] Helm Chart.

Use cases:

- Perform initial migrations against external PostgreSQL databases prior to the Sourcegraph deployment
- Perform database migrations prior to upgrading the Sourcegraph deployment
- Troubleshoot a [dirty database]

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

By default, the [sourcegraph/sourcegraph-migrator] chart references database credentials from a Kubernetes `Secret` created by the parent [sourcegraph/sourcegraph] chart. If you provide your own `Secret` resources, update the `codeInsightsDB.auth.existingSecret`, `codeIntelDB.auth.existingSecret` and `pgsql.auth.existingSecret` settings in values.yaml to match. Learn more about [using your own PostgreSQL server].

You should consult the list of available [migrator commands]. Below is some example usage. Replace `<chart-version>` with the chart version that matches your Sourcegraph version.

### Run database migration

[`migrator up`](https://docs.sourcegraph.com/admin/how-to/manual_database_migrations#up)

- Perform database migrations prior to upgrading the Sourcegraph deployment
- Perform initial migrations against external PostgreSQL databases prior to the Sourcegraph deployment

```sh
helm upgrade --install -f <your-override-file.yaml> --version <chart-version> sg-migrator sourcegraph/sourcegraph-migrator
```

### Add a migration log entry

[`migrator add-log -db=frontend -version=1528395834`](https://docs.sourcegraph.com/admin/how-to/manual_database_migrations#add-log)

Add an entry to the migration log after a site administrator has explicitly applied the contents of a migration file, learn more about troubleshooting a [dirty database].

```sh
helm upgrade --install -f <your-override-file.yaml> --set "migrator.args={add-log,-db=frontend,-version=1528395834}" --version <chart-version> sg-migrator sourcegraph/sourcegraph-migrator
```

## Rendering manifests for kubectl deployment

Manifests rendered using the `helm template` command can be used for direct deployment using `kubectl`.

## Configuration Options

Reference the table below for available configuration parameters and consult [migrator] documentation.

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| codeInsightsDB.auth.existingSecret | string | `""` | Name of existing secret to use for codeinsights-db credentials This should match the setting in the sourcegraph chart values |
| codeInsightsDB.name | string | `"codeinsights-db"` |  |
| codeIntelDB.auth.existingSecret | string | `""` | Name of existing secret to use for codeintel-db credentials This should match the setting in the sourcegraph chart values |
| codeIntelDB.name | string | `"codeintel-db"` |  |
| migrator.affinity | object | `{}` | Affinity for the migrator pod. Replaces `sourcegraph.affinity` when set, learn more from the [Kubernetes documentation](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#affinity-and-anti-affinity) |
| migrator.args | list | `["up","-db=all"]` | Override default `migrator` container args Available commands can be found at https://docs.sourcegraph.com/admin/how-to/manual_database_migrations |
| migrator.containerSecurityContext | object | `{"allowPrivilegeEscalation":false,"readOnlyRootFilesystem":true,"runAsGroup":101,"runAsUser":100}` | Security context for the `migrator` container, learn more from the [Kubernetes documentation](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-container) |
| migrator.env | object | `{}` | Environment variables for the `migrator` container |
| migrator.extraContainers | list | `[]` | Extra containers in the migrator pod |
| migrator.extraVolumeMounts | list | `[]` | Extra volume mounts for the `migrator` container |
| migrator.extraVolumes | list | `[]` | Extra volumes for the migrator pod |
| migrator.image.defaultTag | string | `<appVersion>@sha256:<digest>`, pinned by each release | Docker image tag for the `migrator` image |
| migrator.image.name | string | `"migrator"` | Docker image name for the `migrator` image |
| migrator.labels | object | `{}` | Labels for the migrator Job |
| migrator.name | string | `""` | Name prefix of the migrator Job. A random suffix is added to every release's Job. |
| migrator.nodeSelector | object | `{}` | Node selector for the migrator pod. Replaces `sourcegraph.nodeSelector` when set, learn more from the [Kubernetes documentation](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector) |
| migrator.podAnnotations | object | `{}` | Annotations for the migrator pod |
| migrator.podLabels | object | `{}` | Labels for the migrator pod |
| migrator.podSecurityContext | object | `{}` | Pod-level security context for the migrator pod, learn more from the [Kubernetes documentation](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod) |
| migrator.resources | object | `{"limits":{"cpu":"500m","memory":"100M"},"requests":{"cpu":"100m","memory":"50M"}}` | Resource requests & limits for the `migrator` container, learn more from the [Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) |
| migrator.tolerations | list | `[]` | Tolerations for the migrator pod. Replaces `sourcegraph.tolerations` when set, learn more from the [Kubernetes documentation](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) |
| nameOverride | string | `""` | Replaces the chart name in the `app.kubernetes.io/name` label of the migrator Job and its pod. The chart has no selector, so it can be changed on an installed release. As a subchart with an `alias`, the alias replaces the chart name; set `<alias>.nameOverride: sourcegraph-migrator` in the parent chart to keep the label of a standalone install. |
| pgsql.auth.existingSecret | string | `""` | Name of existing secret to use for pgsql credentials This should match the setting in the sourcegraph chart values |
| pgsql.name | string | `"pgsql"` |  |
| sourcegraph.affinity | object | `{}` | Default affinity for every pod. `migrator.affinity` replaces it when set, learn more from the [Kubernetes documentation](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#affinity-and-anti-affinity) |
| sourcegraph.image.defaultTag | string | `"{{ .Chart.AppVersion }}"` | Global docker image tag |
| sourcegraph.image.pullPolicy | string | `"IfNotPresent"` | Global docker image pull policy |
| sourcegraph.image.repository | string | Sourcegraph's public Docker Hub registry | Global docker image registry or prefix |
| sourcegraph.image.useGlobalTagAsDefault | bool | `false` | When set to true, sourcegraph.image.defaultTag is used as the default defaultTag for all services, instead of service-specific default defaultTags |
| sourcegraph.imagePullSecrets | list | `[]` | Mount named secrets containing docker credentials |
| sourcegraph.labels | object | `{}` | Add a global label to all resources |
| sourcegraph.nodeSelector | object | `{}` | Default nodeSelector for every pod. `migrator.nodeSelector` replaces it when set, learn more from the [Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#nodeselector) |
| sourcegraph.podAnnotations | object | `{}` | Add extra annotations to attach to all pods |
| sourcegraph.podLabels | object | `{}` | Add extra labels to attach to all pods |
| sourcegraph.priorityClassName | string | `""` | Assign a priorityClass to all pods (daemonSets, deployments, and statefulSets) |
| sourcegraph.tolerations | list | `[]` | Default tolerations for every pod. `migrator.tolerations` replaces it when set, learn more from the [Kubernetes documentation](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) |

## Troubleshooting

See a list of running migrator jobs

```sh
kubectl get jobs -l app.kubernetes.io/component=migrator
```

Check logs of the migrator job

```sb
kubectl logs -l job=migrator -c migrator
```

[sourcegraph/sourcegraph]: ../sourcegraph/
[sourcegraph/sourcegraph-migrator]: ./
[dirty database]: https://docs.sourcegraph.com/admin/how-to/dirty_database
[migrator]: https://docs.sourcegraph.com/admin/how-to/manual_database_migrations
[migrator commands]: https://docs.sourcegraph.com/admin/how-to/manual_database_migrations#commands
[job]: https://kubernetes.io/docs/concepts/workloads/controllers/job/
[add-log]: https://docs.sourcegraph.com/admin/how-to/manual_database_migrations#add-log
[using your own postgresql server]: https://docs.sourcegraph.com/admin/external_services/postgres#instructions
