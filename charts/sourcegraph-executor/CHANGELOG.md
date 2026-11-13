# Changelog

<!-- START CHANGELOG -->
## Unreleased

* Removed the unused `http-debug` container port (6060) and the `executor-<queueName>` Service from the Kubernetes-native executor chart (`sourcegraph-executor/k8s`). Nothing listens on that port: executors stopped serving it in Sourcegraph 4.1, before this chart existed. Helm deletes the Service on upgrade. The undocumented `executor.serviceAnnotations`, `executor.serviceLabels`, and `executor.serviceType` values no longer have any effect. Executor metrics are unaffected; `worker` serves them through the `worker-executors` Service.

## 8.0.0

* Added a `network-policy` example to the `sourcegraph-executor-k8s` and `sourcegraph-executor-dind` charts, with `CiliumNetworkPolicy` resources which limit Executor and job pods to the frontend API.

## 7.0.2852

- **BREAKING:** The `securityContext` field in the `sourcegraph-executor-k8s` chart is now deprecated. Use `containerSecurityContext` or `podSecurityContext` instead. The `privileged` field has been moved to `containerSecurityContext`. To update to newer versions of this chart, ensure the new fields are used and the deprecated `securityContext` field is removed.

## 5.3.9104

* Added new chart `sourcegraph-executor-k8s` to deploy Sourcegraph executors that use Kubernetes jobs.
* **BREAKING:** Renamed `sourcegraph-executor` chart to `sourcegraph-executor-dind` to indicate these are Docker in Docker executors. To update to newer versions of this chart, ensure the new Chart name is used.
