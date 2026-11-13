# Changelog

<!-- START CHANGELOG -->
## Unreleased

* Removed the unused container port 2375 from the `dind` sidecar in the Docker-in-Docker executor chart (`sourcegraph-executor/dind`). `dockerd` listens on `127.0.0.1:2375` only (`dind.daemonConfig.hosts`), the executor reaches it over `localhost`, and no Service targets the port. The executor pod is replaced once on upgrade.

## 8.0.0

* Added a `network-policy` example to the `sourcegraph-executor-k8s` and `sourcegraph-executor-dind` charts, with `CiliumNetworkPolicy` resources which limit Executor and job pods to the frontend API.

## 7.0.2852

- **BREAKING:** The `securityContext` field in the `sourcegraph-executor-k8s` chart is now deprecated. Use `containerSecurityContext` or `podSecurityContext` instead. The `privileged` field has been moved to `containerSecurityContext`. To update to newer versions of this chart, ensure the new fields are used and the deprecated `securityContext` field is removed.

## 5.3.9104

* Added new chart `sourcegraph-executor-k8s` to deploy Sourcegraph executors that use Kubernetes jobs.
* **BREAKING:** Renamed `sourcegraph-executor` chart to `sourcegraph-executor-dind` to indicate these are Docker in Docker executors. To update to newer versions of this chart, ensure the new Chart name is used.
