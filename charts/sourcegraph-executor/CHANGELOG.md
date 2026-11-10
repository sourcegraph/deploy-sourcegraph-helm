# Changelog

<!-- START CHANGELOG -->
## Unreleased

* Added `sourcegraph.runtimeClassName` to the `sourcegraph-executor-k8s` and `sourcegraph-executor-dind` charts, to assign a [RuntimeClass](https://kubernetes.io/docs/concepts/containers/runtime-class/) to their pods, with `executor.runtimeClassName` and `privateDockerRegistry.runtimeClassName` overrides. In the `sourcegraph-executor-dind` chart, either one replaces the `gvisor` default of `dind.gVisor.enabled`.
* Added `executor.kubernetesJob.runtimeClassName` to the `sourcegraph-executor-k8s` chart, to assign a RuntimeClass to job pods (`EXECUTOR_KUBERNETES_RUNTIME_CLASS`), e.g. to run them in a sandbox. Job pods do not inherit `sourcegraph.runtimeClassName`.

## 8.0.0

* Added a `network-policy` example to the `sourcegraph-executor-k8s` and `sourcegraph-executor-dind` charts, with `CiliumNetworkPolicy` resources which limit Executor and job pods to the frontend API.

## 7.0.2852

- **BREAKING:** The `securityContext` field in the `sourcegraph-executor-k8s` chart is now deprecated. Use `containerSecurityContext` or `podSecurityContext` instead. The `privileged` field has been moved to `containerSecurityContext`. To update to newer versions of this chart, ensure the new fields are used and the deprecated `securityContext` field is removed.

## 5.3.9104

* Added new chart `sourcegraph-executor-k8s` to deploy Sourcegraph executors that use Kubernetes jobs.
* **BREAKING:** Renamed `sourcegraph-executor` chart to `sourcegraph-executor-dind` to indicate these are Docker in Docker executors. To update to newer versions of this chart, ensure the new Chart name is used.
