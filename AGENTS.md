# Agent Instructions

## After Making Changes

After making changes to any `values.yaml` file, regenerate the helm docs and verify there are no uncommitted changes:

```sh
./scripts/helm-docs.sh && [[ -z $(git status -s) ]]
```

If the README was updated, stage and commit the changes alongside your other modifications.
