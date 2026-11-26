# Agent Instructions

## After Making Changes

After making changes to any `values.yaml` file, regenerate the helm docs and verify there are no uncommitted changes:

```sh
./scripts/helm-docs.sh && [[ -z $(git status -s) ]]
```

If the README was updated, stage and commit the changes alongside your other modifications.

Releases rewrite every pinned image `defaultTag` and the `sourcegraph.image.repository` registry in `values.yaml`. When adding one of these values, give it a `# -- ` description and a `# @default -- ` annotation, like the existing images, so the README does not change on release. Published charts still list the exact values: the publish workflows run `scripts/ci/render-published-readmes.sh`, which matches these annotations by their exact text, so update it if you reword them.

## Labels in `charts/sourcegraph`

`tests/labelConvention_test.yaml` and `tests/labelConventionKeptOff_test.yaml` enforce these rules on every object the chart renders. When you add a template, follow them; when a test fails, fix the template, not the test.

- The chart's own labels (`app`, `deploy`, `app.kubernetes.io/component`, `group`, `type`, `category`, `worker-replica`) are literal lines in each template, after the user labels.
- User labels come only from these helpers, which merge the values so each key renders once and fail on a chart-owned key:
  - `sourcegraph.objectLabels` (`sourcegraph.labels`, then `<service>.labels`) on every object except Services and pods.
  - `sourcegraph.serviceLabels` (`sourcegraph.serviceLabels`, then `<service>.serviceLabels`) on every Service. Never put `sourcegraph.labels` on a Service: Prometheus copies Service labels onto metrics.
  - `sourcegraph.podLabels` (`sourcegraph.podLabels`, then `<service>.podLabels`) on every pod template, after `sourcegraph.selectorLabels`.
- Selectors and StatefulSet `volumeClaimTemplates` get only `sourcegraph.selectorLabels` and `storageLabels`. Never put user labels there: these fields are immutable, so changing them makes Kubernetes reject the upgrade.
- The standard Helm labels (`sourcegraph.helmLabels`) go on Deployments, StatefulSets, and DaemonSets, and on no other new object. `helm.sh/chart` and `app.kubernetes.io/version` change every release, so every object carrying them is patched on every upgrade, and on a Service they would become metric labels. The templates that already had them are listed in `excludeTemplates` in `tests/labelConventionKeptOff_test.yaml`; do not add to that list.
