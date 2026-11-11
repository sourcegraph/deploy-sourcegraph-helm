# Changelog

<!-- START CHANGELOG -->
## Unreleased

- `sourcegraph.labels` and the charts' standard labels (`helm.sh/chart`, `app.kubernetes.io/name`, `app.kubernetes.io/instance`, `app.kubernetes.io/version`, `app.kubernetes.io/managed-by`) are now rendered on every object the charts create. The `sourcegraph-executor-k8s` chart rendered them on none of its objects (ConfigMap, Deployment, Role, RoleBinding, Secret, Service, ServiceAccount), and the `sourcegraph-executor-dind` chart did not render them on the `docker-config` ConfigMap and the `private-docker-registry` Service. Existing releases gain these labels on upgrade. Labels on these objects can be changed in place, so nothing is recreated or restarted.

## 8.0.0

* Added a `network-policy` example to the `sourcegraph-executor-k8s` and `sourcegraph-executor-dind` charts, with `CiliumNetworkPolicy` resources which limit Executor and job pods to the frontend API.

## 7.0.2852

- **BREAKING:** The `securityContext` field in the `sourcegraph-executor-k8s` chart is now deprecated. Use `containerSecurityContext` or `podSecurityContext` instead. The `privileged` field has been moved to `containerSecurityContext`. To update to newer versions of this chart, ensure the new fields are used and the deprecated `securityContext` field is removed.

## 5.3.9104

* Added new chart `sourcegraph-executor-k8s` to deploy Sourcegraph executors that use Kubernetes jobs.
* **BREAKING:** Renamed `sourcegraph-executor` chart to `sourcegraph-executor-dind` to indicate these are Docker in Docker executors. To update to newer versions of this chart, ensure the new Chart name is used.
