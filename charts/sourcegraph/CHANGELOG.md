<!-- README:
Use `**BREAKING**:` to denote a breaking change
-->

# Changelog

All notable changes to Sourcegraph are documented in this file.

### Changed

- **IMPORTANT** `cadvisor` now defaults to run in `privileged` mode. This allows `cadvisor` to collect out of memory events happening to containers which can be used to discover underprovisoned resources. If you have your own monitoring infrastructure, you may choose to disable `cadvisor` or set `cadvisor.containerSecurityContext.privileged=false` in your override file. [#121](https://github.com/sourcegraph/deploy-sourcegraph-helm/pull/121)

<!-- START CHANGELOG -->

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
