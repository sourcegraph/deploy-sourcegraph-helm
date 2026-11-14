# Changelog

<!-- START CHANGELOG -->
## Unreleased

- Fixed `executor.maximumNumJobs` being ignored by the `sourcegraph-executor-dind` chart, which also refused `EXECUTOR_MAXIMUM_NUM_JOBS` in `executor.env`, so the job limit could not be changed. Executors used their own default, 1 job at a time, while the chart documented 10. The chart now passes `executor.maximumNumJobs` to every executor, with the documented default of 10. **On upgrade, executors that do not set it go from 1 job at a time to 10**, and their pods restart once. Each job runs in the pod's dind container, so before upgrading, set `executor.resources` and `executor.storage` for 10 concurrent jobs, or set `executor.maximumNumJobs: 1` to keep the current behavior. The chart refuses to render when `executor.maximumNumJobs` is null or empty, because the executor cannot start without a number. `helm upgrade --reuse-values` from a chart older than 7.4.0, which had no such value, fails this way; add `--set executor.maximumNumJobs=<number>`. `EXECUTOR_DOCKER_ADD_HOST_GATEWAY` and `EXECUTOR_KEEP_WORKSPACES`, which had no value, can now be set in `executor.env`.
- Added `queues[].maximumNumJobs` to the `sourcegraph-executor-dind` chart, so each queue can set its own job limit. A queue that does not set it uses `executor.maximumNumJobs`. Before, the chart ignored the field, and refused `EXECUTOR_MAXIMUM_NUM_JOBS` in a queue's `env`, so every queue had the same limit.
- Fixed `executor.nodeSelector`, `executor.affinity`, `executor.tolerations`, and `privateDockerRegistry.nodeSelector`, `affinity`, `tolerations`, and `podSecurityContext` being ignored by the `sourcegraph-executor-dind` chart, which listed them in its README. They now replace `sourcegraph.nodeSelector`, `affinity`, and `tolerations` for that pod, and are documented in `values.yaml`.
- Fixed `sourcegraph.nodeSelector`, `sourcegraph.affinity`, and `sourcegraph.tolerations` being ignored by the `sourcegraph-executor-k8s` chart. They are now used when `executor.nodeSelector`, `executor.affinity`, or `executor.tolerations` is empty, so a release that sets them gets its executor pods rescheduled on upgrade. Job pods are not affected: they are still scheduled only by `executor.kubernetesJob.node` and `executor.kubernetesJob.pod`. Removed `executor.securityContext.privileged`, which the chart never read, and the README's list of `privateDockerRegistry` values, which this chart does not have.
- Removed `storageClass.create`, `provisioner`, `type`, `parameters`, and `allowedTopologies` from the `sourcegraph-executor-dind` chart's values. The chart has no StorageClass template, so they never had an effect. `storageClass.name` stays: it is the StorageClass of the `private-docker-registry` volume.
- Fixed the documentation of `nameOverride` in the `sourcegraph-executor-k8s` and `sourcegraph-executor-dind` charts. It was documented as `sourcegraph.nameOverride`, which the charts never read, so setting it had no effect. The charts read the top-level `nameOverride`, which replaces the chart name in the `app.kubernetes.io/name` selector label. Set it only on a new install, because Kubernetes does not allow changing a selector. If you set `sourcegraph.nameOverride`, remove it; moving its value to `nameOverride` changes your selectors.
## 8.0.0

* Added a `network-policy` example to the `sourcegraph-executor-k8s` and `sourcegraph-executor-dind` charts, with `CiliumNetworkPolicy` resources which limit Executor and job pods to the frontend API.

## 7.0.2852

- **BREAKING:** The `securityContext` field in the `sourcegraph-executor-k8s` chart is now deprecated. Use `containerSecurityContext` or `podSecurityContext` instead. The `privileged` field has been moved to `containerSecurityContext`. To update to newer versions of this chart, ensure the new fields are used and the deprecated `securityContext` field is removed.

## 5.3.9104

* Added new chart `sourcegraph-executor-k8s` to deploy Sourcegraph executors that use Kubernetes jobs.
* **BREAKING:** Renamed `sourcegraph-executor` chart to `sourcegraph-executor-dind` to indicate these are Docker in Docker executors. To update to newer versions of this chart, ensure the new Chart name is used.
