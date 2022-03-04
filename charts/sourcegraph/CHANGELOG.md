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

- 

### Fixed

-

### Removed

-

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
