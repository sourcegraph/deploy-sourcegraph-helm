<!-- README:
Use `**BREAKING**:` to denote a breaking change
-->

# Changelog

<!-- START CHANGELOG -->

## Unreleased

## 5.2.2

- Sourcegraph 5.2.2 is now available

## 5.2.1

- Sourcegraph 5.2.1 is now available
- The GitHub Proxy service has been removed and is no longer required. Remove all `githubProxy` fields from config, if set.


## 5.2.0

- Sourcegraph 5.2.0 is now available


## 5.1.9

- Sourcegraph 5.1.9 is now available!

## 5.1.8

- Sourcegraph 5.1.8 is now available!

## 5.1.7

- Sourcegraph 5.1.7 is now available!
- Added a service for the Qdrant vector database

## 5.1.6

- Sourcegraph 5.1.6 is now available!

## 5.1.5

- Sourcegraph 5.1.5 is now available!

## 5.1.4

- Sourcegraph 5.1.4 is now available!

## 5.1.3

- Sourcegraph 5.1.3 is now available!

## 5.1.2

- Sourcegraph 5.1.2 is now available!

## 5.1.1

- Sourcegraph 5.1.1 is now available!

## 5.1.0

- Sourcegraph 5.1.0 is now available!

## 5.0.6

- Add `defaultTagPrefix` per service
- Fix erroneous indentation of `deploy`, `app.kubernetes.io/component` labels and `volumes` in Embeddings deployment

## 5.0.5

- Add support for PodDisruptionBudget in frontend

## 5.0.4

- Add support for PriorityClass in StatefulSets
- Add optional support for the embeddings service

## 5.0.3

- Add Embeddings service (disabled by default) for Cody embeddings

## 5.0.1

- Sourcegraph 5.0.1 is now available!
- [Changelog](https://sourcegraph.com/github.com/sourcegraph/sourcegraph/-/blob/CHANGELOG.md#5-0-1)

## 5.0.0

- Sourcegraph 5.0.0 is now available

- Change CACHE_DIR env var to SYMBOLS_CACHE_DIR in symbols template [#258](https://github.com/sourcegraph/deploy-sourcegraph-helm/pull/258)

## 4.5.0

- Sourcegraph 4.5.0 is now available


- Deploy Sourcegraph Executors now deployable via helm [#236](https://github.com/sourcegraph/deploy-sourcegraph-helm/pull/236).
- Searcher and Symbols now use StatefulSets and PVCs to avoid large `ephermeralStorage` requests [#242](https://github.com/sourcegraph/deploy-sourcegraph-helm/pull/242)
- The default `hostPort`s for OpenTelemetry agent pods deployed by the DaemonSet can now be overridden by setting `openTelemetry.agent.hostPorts` for one or more of `otlpGrpc`, `otlpHttp`, and `zpages`. This allows multiple instances of Sourcegraph to be deployed on a single cluster [#245](https://github.com/sourcegraph/deploy-sourcegraph-helm/pull/245).
- Update default `searcher` replicas from 2 --> 1 [#247](https://github.com/sourcegraph/deploy-sourcegraph-helm/pull/247)
- Update `searcher` and `symbols` services to be headless.
  - Before upgrading, delete your `searcher` and `symbols` services (ex: `kubectl delete svc/searcher svc/symbols`) [#250](https://github.com/sourcegraph/deploy-sourcegraph-helm/pull/250)

## 4.4.2

Sourcegraph 4.4.2 is now available!
- [Changelog](https://sourcegraph.com/github.com/sourcegraph/sourcegraph/-/blob/CHANGELOG.md#4-4-2)

## 4.4.1

Sourcegraph 4.4.1 is now available!
- [Changelog](https://sourcegraph.com/github.com/sourcegraph/sourcegraph/-/blob/CHANGELOG.md#4-4-1)

## 4.4.0

- Sourcegraph 4.4.0 is now available

## 4.3.1

Sourcegraph 4.3.1 is now available!
- [Changelog](https://sourcegraph.com/github.com/sourcegraph/sourcegraph/-/blob/CHANGELOG.md#4-3-1)

## 4.3.0

Sourcegraph 4.3.0 is now available!
- [Changelog](https://sourcegraph.com/github.com/sourcegraph/sourcegraph/-/blob/CHANGELOG.md#4-3-0)

## 4.2.1

* `minio` has been replaced with `blobstore`. If you use Sourcegraph's built-in object storage (instead of an external S3/GCP bucket), then please see the update notes here: https://docs.sourcegraph.com/admin/how-to/blobstore_update_notes

## 4.2.0

- Sourcegraph 4.2.0 is now available

- Added a node-exporter daemonset, which collects crucial machine-level metrics that help Sourcegraph scale your deployment. See [#194](https://github.com/sourcegraph/deploy-sourcegraph-helm/pull/194) for more information

  - 🚨 **WARNING**: Similarly to cadvisor,  `node-exporter`:
    - runs as a daemonset
    - needs to mount various read-only directories from the host machine (`/`, `/proc`, and `/sys`)
    - ideally shares the machine's PID namespaces

  - If necessary, node-exporter can be disabled by setting `nodeExporter.enabled: false` in your `override.yaml` configuration file.

## 4.1.3

Sourcegraph 4.1.3 is now available!
- [Changelog](https://sourcegraph.com/github.com/sourcegraph/sourcegraph/-/blob/CHANGELOG.md#4-1-3)

## 4.1.2

Sourcegraph 4.1.2 is now available!
- [Changelog](https://sourcegraph.com/github.com/sourcegraph/sourcegraph/-/blob/CHANGELOG.md#4-1-2)

## 4.1.1

Sourcegraph 4.1.1 is now available!
- [Changelog](https://sourcegraph.com/github.com/sourcegraph/sourcegraph/-/blob/CHANGELOG.md#4-1-1)

## 4.1.0

Sourcegraph 4.1.0 is now available!
- [Changelog](https://sourcegraph.com/github.com/sourcegraph/sourcegraph/-/blob/CHANGELOG.md#4-1-0)
- Added `allowedTopologies` support to storageclass [#188](https://github.com/sourcegraph/deploy-sourcegraph-helm/pull/188). This is useful to restrict provisioning of PV in specific zones or regions. In some cloud providers (e.g. GCP), this can be used to provision regional disks with only one worker node present.

## 4.0.1

Sourcegraph 4.0.1 is now available!
- [Changelog](https://sourcegraph.com/github.com/sourcegraph/sourcegraph/-/blob/CHANGELOG.md#4-0-1)

## 4.0.0

Sourcegraph 4.0.0 is now available!
- [Changelog](https://sourcegraph.com/github.com/sourcegraph/sourcegraph/-/blob/CHANGELOG.md#4-0-0)
- (lint) Don't emit `annotations` key on k8s objects if the value is empty [#163](https://github.com/sourcegraph/deploy-sourcegraph-helm/pull/163)
- **BREAKING**: Switched to OpenTelemetry for trace data collection [#167](https://github.com/sourcegraph/deploy-sourcegraph-helm/pull/167)
  Relevant changes:
  - `tracing` and `tracingAgent` value blocks have been removed
  - `openTelemetry` value block has been added
  - The `otel-collector` service can be configured to export trace data to arbitrary external observability backends (see `openTelemetry.gateway.config.traces` value)
  - The bundled Jaeger instance is now disabled by default. You can re-enable it by setting `jaeger.enabled` to true. This will automatically configure `otel-collector` to export trace data to this instance.

## 3.43.2

Sourcegraph 3.43.2 is now available!
- [Changelog](https://sourcegraph.com/github.com/sourcegraph/sourcegraph/-/blob/CHANGELOG.md#3-43-2)

## 3.43.1

Sourcegraph 3.43.1 is now available!
- [Changelog](https://sourcegraph.com/github.com/sourcegraph/sourcegraph/-/blob/CHANGELOG.md#3-43-1)

## 3.43.0

Sourcegraph 3.43.0 is now available!
- [Changelog](https://sourcegraph.com/github.com/sourcegraph/sourcegraph/-/blob/CHANGELOG.md#3-43-0)

## 3.42.2

Sourcegraph 3.42.2 is now available!
- [Changelog](https://sourcegraph.com/github.com/sourcegraph/sourcegraph/-/blob/CHANGELOG.md#3-42-2)

## 3.42.1

Sourcegraph 3.42.1 is now available!
- [Changelog](https://sourcegraph.com/github.com/sourcegraph/sourcegraph/-/blob/CHANGELOG.md#3-42-1)

## 3.42.0

Sourcegraph 3.42.0 is now available!
- [Changelog](https://sourcegraph.com/github.com/sourcegraph/sourcegraph/-/blob/CHANGELOG.md#3-42-0)
- [Update](https://docs.sourcegraph.com/admin/updates)
- [Release post](https://about.sourcegraph.com/blog/release/3.42)


## 3.42.1

Sourcegraph 3.42.1 is now available!
- [Changelog](https://sourcegraph.com/github.com/sourcegraph/sourcegraph/-/blob/CHANGELOG.md#3-42-1)


## 3.42.0

Sourcegraph 3.42.0 is now available!
- [Changelog](https://sourcegraph.com/github.com/sourcegraph/sourcegraph/-/blob/CHANGELOG.md#3-42-0)
- [Update](https://docs.sourcegraph.com/admin/updates)
- [Release post](https://about.sourcegraph.com/blog/release/3.42)


- Add new example `envoy` to enable HTTP trailers using Envoy Filter [#148](https://github.com/sourcegraph/deploy-sourcegraph-helm/pull/148)
- Add support to configure service account annotations [#151](https://github.com/sourcegraph/deploy-sourcegraph-helm/pull/151)




## 3.41.0

Sourcegraph 3.41.0 is now available!

- [Changelog](https://sourcegraph.com/github.com/sourcegraph/sourcegraph/-/blob/CHANGELOG.md#3-41-0)
- [Update](https://docs.sourcegraph.com/admin/updates)
- [Release post](https://about.sourcegraph.com/blog/release/3.41)

- Fixed mountPath and permissions used by codeinsights-db initContainer [#138](https://github.com/sourcegraph/deploy-sourcegraph-helm/pull/138)
- Add mount path for a tmp dir to symbols deployment [#132](https://github.com/sourcegraph/deploy-sourcegraph-helm/pull/132)
- Add startup probes to codeintel-db and pgsql deployments [#133](https://github.com/sourcegraph/deploy-sourcegraph-helm/pull/133)

## 3.40.2-rev.1

### Fixed

- Fix broken template in storageClass parameters when `type=null` [#134](https://github.com/sourcegraph/deploy-sourcegraph-helm/pull/134)

## 3.40.1

Sourcegraph 3.40.1 is now available!

- [Changelog](https://sourcegraph.com/github.com/sourcegraph/sourcegraph/-/blob/CHANGELOG.md#3-40-1)

## 3.40.0

Sourcegraph 3.40.0 is now available!

All notable changes to Sourcegraph are documented in this file.

### Changed

- **IMPORTANT** `cadvisor` now defaults to run in `privileged` mode. This allows `cadvisor` to collect out of memory events happening to containers which can be used to discover underprovisoned resources. If you have your own monitoring infrastructure, you may choose to disable `cadvisor` or set `cadvisor.containerSecurityContext.privileged=false` in your override file. [#121](https://github.com/sourcegraph/deploy-sourcegraph-helm/pull/121)
- Uses of alpine-3.12 docker image have been updated to use alpine-3.14 [#124](https://github.com/sourcegraph/deploy-sourcegraph-helm/pull/124/)

## 3.39.1

Sourcegraph 3.39.1 is now available!

- [Changelog](https://sourcegraph.com/github.com/sourcegraph/sourcegraph/-/blob/CHANGELOG.md#3-39-1)
- [Update](https://docs.sourcegraph.com/admin/updates)

## 3.39.0

The Sourcegraph Helm chart is now GA and can be used for production deployments.

**Note**: The location of the helm chart repository has been moved to https://helm.sourcegraph.com/release and any existing `helm repo` references should be updated. Future chart versions will only be published to the new URL.

Sourcegraph 3.39.0 is now available!

- [Changelog](https://sourcegraph.com/github.com/sourcegraph/sourcegraph/-/blob/CHANGELOG.md#3-39-0)
- [Update](https://docs.sourcegraph.com/admin/updates)
- [Release post](https://about.sourcegraph.com/blog/release/3.39)

### Added

- Added initContainer and pgsql-exporter to Code Insights statefulset in support of Postgres migration [#106](https://github.com/sourcegraph/deploy-sourcegraph-helm/pull/106), [#107](https://github.com/sourcegraph/deploy-sourcegraph-helm/pull/107)

### Changed

- **BREAKING** Database credentials are now rendered as secrets by default and support referencing an existing secret. Credentials can be customized with `pgsql.auth`, `codeIntelDB.auth`, and `codeInsightsDB.auth`. If you previously customized the credential env vars (for instance, to use an external database), you must update your override to use the new configuration. [#86](https://github.com/sourcegraph/deploy-sourcegraph-helm/pull/86), [#98](https://github.com/sourcegraph/deploy-sourcegraph-helm/pull/98)
- **BREAKING** Redis endpoints are now rendered as secrets by default and support referencing an existing secret. Endpoint configuration can be customized with `redisStore.connection` and `redisCache.connection`. If you previously customized the endpoint env vars, you must update your override to use the new configuration. [#100](https://github.com/sourcegraph/deploy-sourcegraph-helm/pull/100)
- **BREAKING** Minio credentials are now rendered as secrets by default and support referencing an existing secret. Credentials can be customized with `minio.auth`. If you previously customized the credential env vars, manual updates may be required. [#85](https://github.com/sourcegraph/deploy-sourcegraph-helm/pull/85)
- **CAUTION** Migrated Code Insights from Timescale to Postgres. If you have customized the configmap or connection parameters for codeinsights-db, manual updates may be required. [#74](https://github.com/sourcegraph/deploy-sourcegraph-helm/pull/74)
- **CAUTION** Updated resource name generation to be more standard. If you were previously customizing names, some resources may update to reflect your customization. [#97](https://github.com/sourcegraph/deploy-sourcegraph-helm/pull/97)
- As a result of the above credential changes, relevant deployments / statefulsets will now automatically restart when credential values have updated.

### Fixed

- Fix tls rendering on the frontend ingress resource when secret is not provided [#90](https://github.com/sourcegraph/deploy-sourcegraph-helm/pull/90)

### Removed

-

## 0.7.1

Sourcegraph 3.38.1 is now available!

- [Changelog](https://sourcegraph.com/github.com/sourcegraph/sourcegraph/-/blob/CHANGELOG.md#3-38-1)
- [Update](https://docs.sourcegraph.com/admin/updates)

## 0.7.0

### Added

- Support extending postgres server conf [#77](https://github.com/sourcegraph/deploy-sourcegraph-helm/pull/77)

## 0.6.0

Sourcegraph 3.38.0 is now available!

- [Changelog](https://sourcegraph.com/github.com/sourcegraph/sourcegraph/-/blob/CHANGELOG.md#3-38-0)
- [Update](https://docs.sourcegraph.com/admin/updates)
- [Release post](https://about.sourcegraph.com/blog/release/3.38)

### Changed

- Set `DEPLOY_TYPE` environment variable to track helm chart usage [#66](https://github.com/sourcegraph/deploy-sourcegraph-helm/pull/66)

### Fixed

- Fix broken indentation in storageClass parameters [#73](https://github.com/sourcegraph/deploy-sourcegraph-helm/pull/73)
- Fix tracing partial template when tracing is disabled [#75](https://github.com/sourcegraph/deploy-sourcegraph-helm/pull/75)

## 0.5.0

### Changed

- **BREAKING**: `pgsql`, `codeintel-db`, and `codeinsights-db` have been converted from [Deployments](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) to [StatefulSets](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/) [#70](https://github.com/sourcegraph/deploy-sourcegraph-helm/pull/70)
- **BREAKING**: Service name override only affects deploy and sts [#65](https://github.com/sourcegraph/deploy-sourcegraph-helm/pull/65)
- Remove replicaCount values for unscalable services [#64](https://github.com/sourcegraph/deploy-sourcegraph-helm/pull/64)

### Fixed

- Set default resource requests/limits on the migrator container [#60](https://github.com/sourcegraph/deploy-sourcegraph-helm/pull/60)
- Fix `jaeger` deployment labels selector [#62](https://github.com/sourcegraph/deploy-sourcegraph-helm/pull/62)

## 0.4.0

:bulb: We revamped the documentation of helm chart configuration options, [learn more](https://github.com/sourcegraph/deploy-sourcegraph-helm/tree/main/charts/sourcegraph#configuration-options)

### Added

- Support custom service account name (#52)
- Support container args override (#44)
- Add per-service scheduling config support (#46)

### Changed

- **BREAKING**: Uses of `podSecurityContext` have been renamed to `containerSecurityContext`, and `securityContext` renamed to `podSecurityContext` to better illustrate their actual usage [#48](https://github.com/sourcegraph/deploy-sourcegraph-helm/pull/48)

### Fixed

- Fix default global tolerations value (#45)
- Fix `default-container` annotations (#47)
- Add missing imagePullPolicy (#49)
