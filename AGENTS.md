# Agent Instructions

## After Making Changes

After making changes to any `values.yaml` file, regenerate the helm docs and verify there are no uncommitted changes:

```sh
./scripts/helm-docs.sh && [[ -z $(git status -s) ]]
```

If the README was updated, stage and commit the changes alongside your other modifications.

Releases rewrite every pinned image `defaultTag` and the `sourcegraph.image.repository` registry in `values.yaml`. When adding one of these values, give it a `# -- ` description and a `# @default -- ` annotation, like the existing images, so the README does not change on release.
