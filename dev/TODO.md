# TODO

- Move the chart publish workflows
  (`.github/workflows/gcs_chart_publish_*.yml`) from Helm v3.22.1 to
  Helm 4. helm-gcs 0.7.0 supports Helm 4 but installs a different
  plugin layout and needs `--verify=false` on `helm plugin install`.
  Buildkite CI and `helm_lint_test.yml` already run Helm 4.
