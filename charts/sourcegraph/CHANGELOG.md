<!-- README:
Use `**BREAKING**:` to denote a breaking change
-->

# Changelog

All notable changes to Sourcegraph are documented in this file.

<!-- START CHANGELOG -->

## Unreleased

### Added

-

### Changed

- **CAUTION** Migrated Code Insights from Timescale to Postgres. If you have customized the configmap or connection parameters for codeinsights-db, manual updates may be required. [#74](https://github.com/sourcegraph/deploy-sourcegraph-helm/pull/74)

### Fixed

-

### Removed

-

## 0.7.0

### Added

- Support extending postgres server conf [#77](https://github.com/sourcegraph/deploy-sourcegraph-helm/pull/77)

## 0.6.0

Sourcegraph 3.38.0 is now available!

- [Changelog](https://sourcegraph.com/github.com/sourcegraph/sourcegraph/-/blob/CHANGELOG.md#3-38-0)
- [Update](https://docs.sourcegraph.com/admin/updates)
- [Release post](https://about.sourcegraph.com/blog/release/3.38) (might not be available immediately upon release)

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
