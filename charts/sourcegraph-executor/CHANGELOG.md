# Changelog

<!-- START CHANGELOG -->
## Unreleased

* Fixed `sourcegraph-executor-k8s` rendering of `executor.kubernetesJob.node.tolerations`, `requiredAffinityMatchExpressions`, `requiredAffinityMatchFields`, `pod.affinity` and `pod.antiAffinity`: YAML lists are now JSON-encoded for the executor instead of rendering as Go `map[...]` strings. Pre-escaped JSON strings keep working. [#349](https://github.com/sourcegraph/deploy-sourcegraph-helm/issues/349)
* Added a `network-policy` example to the `sourcegraph-executor-k8s` and `sourcegraph-executor-dind` charts, with `CiliumNetworkPolicy` resources which limit Executor and job pods to the frontend API.
* Added new chart `sourcegraph-executor-k8s` to deploy Sourcegraph executors that use Kubernetes jobs.
* **BREAKING:** Renamed `sourcegraph-executor` chart to `sourcegraph-executor-dind` to indicate these are Docker in Docker executors. To update to newer versions of this chart, ensure the new Chart name is used.
- **BREAKING:** The `securityContext` field in the `sourcegraph-executor-k8s` chart is now deprecated. Use `containerSecurityContext` or `podSecurityContext` instead. The `privileged` field has been moved to `containerSecurityContext`. To update to newer versions of this chart, ensure the new fields are used and the deprecated `securityContext` field is removed.
