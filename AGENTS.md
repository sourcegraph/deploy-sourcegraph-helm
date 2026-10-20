# Agent Instructions

## After Making Changes

After making changes to any `values.yaml` file, regenerate the helm docs; this fails and lists any README it had to rewrite:

```sh
./scripts/helm-docs.sh --check
```

If the README was updated, stage and commit the changes alongside your other modifications.
