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

- **BREAKING**: The use of `.<service>.podSecurityContext` and `.<service>.securityContext` is causing confusion and misleading, we are using `podSecurityContext` as container-level `securityContext` and `securityContext` as pod-level `securityContext`. `podSecurityContext` are renamed to `containerSecurityContext`, and `securityContext` are renamed to `podSecurityContext` to better illustrate their actual usage [#48](https://github.com/sourcegraph/deploy-sourcegraph-helm/pull/48)

### Fixed

-

### Removed

-
