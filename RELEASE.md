# Sourcegraph Helm Chart Release

> The Sourcegraph Helm chart follows the standard [Sourcegraph releases] schedule, with monthly minor releases and patch releases as-needed.

Hotfixes not associated with a Sourcegraph release may be released by following the below process:

## 1. Commit the hotfix against the main branch

Follow the normal PR and testing process.

## 2. Create a new `publish-x.y.z-rev.a` branch off the last `release/x.y` branch

Hotfix releases will use a suffix to indicate they are a special type of release. This is necessary because semver only supports patch-level versioning, and we cannot overwrite a published version.

The version should look similar to `3.38.1-rev.1`.

Cherry-pick the change from step 1 to this branch and follow the normal testing process to confirm an upgrade from the released version is safe.

## 3. Bump the `version` in `Chart.yaml` and update changelog

Update Chart.yaml to use the new version. Update the Changelog to reflect the new version.

## 3. Create a Pull Request

Commit all changes and open a Pull Request. The destination branch for your PR should be `release/x.y`, not main.

[semver]: https://semver.org/
[sourcegraph release]: https://handbook.sourcegraph.com/departments/product-engineering/engineering/process/releases/
[helm-docs]: https://github.com/norwoodj/helm-docs
