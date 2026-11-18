# Changelog

<!-- START CHANGELOG -->
## Unreleased

- Added `executor.storage.labels` to the `sourcegraph-executor-dind` chart to label the per-pod PersistentVolumeClaim that is created when `executor.storage.type` is `ephemeral`. That claim now also gets `sourcegraph.labels`, the chart's standard labels, `deploy`, and `app.kubernetes.io/component`, so with `executor.storage.type: ephemeral` the executor pods restart whenever the chart version changes. Changing `executor.storage.labels` restarts them too.
- Added `privateDockerRegistry.storageLabels` to the `sourcegraph-executor-dind` chart to label the `cache` volume claim template of the `private-docker-registry` StatefulSet. It defaults to empty, so existing releases render the same template. Set it on the first install and never change it on an installed release: Kubernetes does not allow changing a StatefulSet's volume claim templates. See [PersistentVolumeClaim labels](dind/README.md#persistentvolumeclaim-labels).
- Every object the charts create now has the `deploy` and `app.kubernetes.io/component` labels: the `sourcegraph-executor-k8s` Secret did not have them. `executor.labels` is now also rendered on the `sourcegraph-executor-k8s` ConfigMap, Secret, ServiceAccount, Role, and RoleBinding, and on the `sourcegraph-executor-dind` `docker-config` ConfigMap, not only on the Deployment. Added `privateDockerRegistry.serviceLabels` to the `sourcegraph-executor-dind` chart to label the `private-docker-registry` Service.
- `sourcegraph.labels` and the charts' standard labels (`helm.sh/chart`, `app.kubernetes.io/name`, `app.kubernetes.io/instance`, `app.kubernetes.io/version`, `app.kubernetes.io/managed-by`) are now rendered on every object the charts create. The `sourcegraph-executor-k8s` chart rendered them on none of its objects (ConfigMap, Deployment, Role, RoleBinding, Secret, Service, ServiceAccount), and the `sourcegraph-executor-dind` chart did not render them on the `docker-config` ConfigMap and the `private-docker-registry` Service. Pods get them too, except `helm.sh/chart` and `app.kubernetes.io/version`, which change with every chart version and would restart every pod on every upgrade. The `private-docker-registry` pod gains `app.kubernetes.io/component`. Existing releases gain these labels on upgrade. No object is recreated. Every pod restarts once, on this upgrade.

## 8.0.0

* Added a `network-policy` example to the `sourcegraph-executor-k8s` and `sourcegraph-executor-dind` charts, with `CiliumNetworkPolicy` resources which limit Executor and job pods to the frontend API.

## 7.0.2852

- **BREAKING:** The `securityContext` field in the `sourcegraph-executor-k8s` chart is now deprecated. Use `containerSecurityContext` or `podSecurityContext` instead. The `privileged` field has been moved to `containerSecurityContext`. To update to newer versions of this chart, ensure the new fields are used and the deprecated `securityContext` field is removed.

## 5.3.9104

* Added new chart `sourcegraph-executor-k8s` to deploy Sourcegraph executors that use Kubernetes jobs.
* **BREAKING:** Renamed `sourcegraph-executor` chart to `sourcegraph-executor-dind` to indicate these are Docker in Docker executors. To update to newer versions of this chart, ensure the new Chart name is used.
