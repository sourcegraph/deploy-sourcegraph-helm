# Changelog

<!-- START CHANGELOG -->
## Unreleased

* Removed the unused `http-debug` container port (6060) and the `executor-<queueName>` Service from the Kubernetes-native executor chart (`sourcegraph-executor/k8s`). Nothing listens on that port: executors stopped serving it in Sourcegraph 4.1, before this chart existed. Helm deletes the Service on upgrade. The undocumented `executor.serviceAnnotations`, `executor.serviceLabels`, and `executor.serviceType` values no longer have any effect. Executor metrics are unaffected; `worker` serves them through the `worker-executors` Service.
* Removed the unused container port 2375 from the `dind` sidecar in the Docker-in-Docker executor chart (`sourcegraph-executor/dind`). `dockerd` listens on `127.0.0.1:2375` only (`dind.daemonConfig.hosts`), the executor reaches it over `localhost`, and no Service targets the port. The executor pod is replaced once on upgrade.
* Narrowed the Kubernetes-native executor's Role (`sg-executor-role`) to the calls the executor makes: `watch` on `pods`, `get` on `pods/log`, and `create` and `delete` on `jobs`, `secrets`, and `persistentvolumeclaims`. It no longer grants `get` and `list` on `pods`, `secrets`, or `persistentvolumeclaims`; executors have not used them since Sourcegraph 5.1, before this chart existed.
* Removed `SRC_TRACE_LOG` from the Kubernetes-native executor's ConfigMap, and the `executor.log.trace` value that set it. Nothing has read `SRC_TRACE_LOG` since Sourcegraph 5.2.

## 8.0.0

* Added a `network-policy` example to the `sourcegraph-executor-k8s` and `sourcegraph-executor-dind` charts, with `CiliumNetworkPolicy` resources which limit Executor and job pods to the frontend API.

## 7.0.2852

- **BREAKING:** The `securityContext` field in the `sourcegraph-executor-k8s` chart is now deprecated. Use `containerSecurityContext` or `podSecurityContext` instead. The `privileged` field has been moved to `containerSecurityContext`. To update to newer versions of this chart, ensure the new fields are used and the deprecated `securityContext` field is removed.

## 5.3.9104

* Added new chart `sourcegraph-executor-k8s` to deploy Sourcegraph executors that use Kubernetes jobs.
* **BREAKING:** Renamed `sourcegraph-executor` chart to `sourcegraph-executor-dind` to indicate these are Docker in Docker executors. To update to newer versions of this chart, ensure the new Chart name is used.
