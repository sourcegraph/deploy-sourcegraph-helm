# Changelog

<!-- START CHANGELOG -->
## Unreleased

- Fixed `executor.kubernetesJob.node.tolerations`, `node.requiredAffinityMatchExpressions`, `node.requiredAffinityMatchFields`, `pod.affinity`, and `pod.antiAffinity` in the `sourcegraph-executor-k8s` chart. A JSON encoded string, the documented form, failed the render with a YAML parse error, and a YAML list rendered as `[map[effect:NoSchedule key:foo ...]]`, so the executor failed to start with `invalid character 'm' looking for beginning of value`. Both forms now render as JSON. The examples in `values.yaml` are now valid JSON when copied as written. [#349](https://github.com/sourcegraph/deploy-sourcegraph-helm/issues/349)

## 8.0.0

* Added a `network-policy` example to the `sourcegraph-executor-k8s` and `sourcegraph-executor-dind` charts, with `CiliumNetworkPolicy` resources which limit Executor and job pods to the frontend API.

## 7.0.2852

- **BREAKING:** The `securityContext` field in the `sourcegraph-executor-k8s` chart is now deprecated. Use `containerSecurityContext` or `podSecurityContext` instead. The `privileged` field has been moved to `containerSecurityContext`. To update to newer versions of this chart, ensure the new fields are used and the deprecated `securityContext` field is removed.

## 5.3.9104

* Added new chart `sourcegraph-executor-k8s` to deploy Sourcegraph executors that use Kubernetes jobs.
* **BREAKING:** Renamed `sourcegraph-executor` chart to `sourcegraph-executor-dind` to indicate these are Docker in Docker executors. To update to newer versions of this chart, ensure the new Chart name is used.
