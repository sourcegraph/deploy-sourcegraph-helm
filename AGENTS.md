# Agent Instructions

## After Making Changes

After making changes to any `values.yaml` file, regenerate the helm docs; this script exits non-zero and lists the README.md files it changed:

```sh
./scripts/helm-docs.sh --check
```

If the README.d was updated, stage and commit the changes alongside your other modifications.

Releases rewrite every pinned image `defaultTag` and the `sourcegraph.image.repository` registry in `values.yaml`. When adding one of these values, give it a `# -- ` description and a `# @default -- ` annotation, like the existing images, so the README does not change on release. Published charts still list the exact values: the publish workflows run `scripts/ci/render-published-readmes.sh`, which matches these annotations by their exact text, so update it if you reword them.
