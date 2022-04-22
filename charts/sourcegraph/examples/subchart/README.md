# Using a subchart to deploy custom resources

This example demonstrates the use of [Helm subcharts] to make permanent customizations to the Sourcegraph deployment. This approach is an alternative to combining helm + kustomize, as demonstrated in the [kustomize-chart](../kustomize-chart) example.

The subchart adds a NetworkPolicy resource and references a custom variable from values.yaml to demonstrate how you can extend the Sourcegraph chart.

Reference:
[Sourcegraph documentation](https://docs.sourcegraph.com/admin/install/kubernetes/helm#subchart)

[Helm subcharts]: https://helm.sh/docs/chart_template_guide/subcharts_and_globals/
