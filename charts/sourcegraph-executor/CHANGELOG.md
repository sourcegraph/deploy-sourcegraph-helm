# Changelog

<!-- START CHANGELOG -->
## Unreleased

- Removed `storageClass.create`, `provisioner`, `type`, `parameters`, and `allowedTopologies` from the `sourcegraph-executor-dind` chart's values. The chart has no StorageClass template, so they never had an effect. `storageClass.name` stays: it is the StorageClass of the `private-docker-registry` volume.
- Fixed the documentation of `nameOverride` in the `sourcegraph-executor-k8s` and `sourcegraph-executor-dind` charts. It was documented as `sourcegraph.nameOverride`, which the charts never read, so setting it had no effect. The charts read the top-level `nameOverride`, which replaces the chart name in the `app.kubernetes.io/name` selector label. Set it only on a new install, because Kubernetes does not allow changing a selector. If you set `sourcegraph.nameOverride`, remove it; moving its value to `nameOverride` changes your selectors.
## 8.0.0

* Added a `network-policy` example to the `sourcegraph-executor-k8s` and `sourcegraph-executor-dind` charts, with `CiliumNetworkPolicy` resources which limit Executor and job pods to the frontend API.

## 7.0.2852

- **BREAKING:** The `securityContext` field in the `sourcegraph-executor-k8s` chart is now deprecated. Use `containerSecurityContext` or `podSecurityContext` instead. The `privileged` field has been moved to `containerSecurityContext`. To update to newer versions of this chart, ensure the new fields are used and the deprecated `securityContext` field is removed.

## 5.3.9104

* Added new chart `sourcegraph-executor-k8s` to deploy Sourcegraph executors that use Kubernetes jobs.
* **BREAKING:** Renamed `sourcegraph-executor` chart to `sourcegraph-executor-dind` to indicate these are Docker in Docker executors. To update to newer versions of this chart, ensure the new Chart name is used.
