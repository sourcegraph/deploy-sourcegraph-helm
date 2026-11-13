{{/*
Common labels
*/}}
{{- define "sourcegraph.labels" -}}
helm.sh/chart: {{ include "sourcegraph.chart" . }}
app.kubernetes.io/name: {{ include "sourcegraph.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- if .Values.sourcegraph.labels }}
{{ toYaml .Values.sourcegraph.labels }}
{{- end }}
{{- end }}

{{/*
Regex of the Service and pod labels that the bundled Prometheus must not copy to
the metrics it scrapes: the common labels and the keys of `sourcegraph.labels`,
spelled as Prometheus spells them, with `_` for every character outside
`[a-zA-Z0-9_]`. No bundled dashboard or alert queries them, and `helm.sh/chart`
and `app.kubernetes.io/version` change on every upgrade.

A key of `sourcegraph.labels` that the chart also sets itself, such as `app`,
is kept: the chart's value wins on the object, and dashboards and alerts query it.
*/}}
{{- define "sourcegraph.prometheus.droppedLabels" -}}
{{- $names := list "helm_sh_chart" "app_kubernetes_io_(name|instance|version|managed_by)" -}}
{{- $kept := list "app" "deploy" "group" "type" "worker_replica" "app_kubernetes_io_component" "sourcegraph_resource_requires" -}}
{{- range $key := keys (.Values.sourcegraph.labels | default dict) | sortAlpha -}}
{{- $name := regexReplaceAll "[^a-zA-Z0-9_]" $key "_" -}}
{{- if not (has $name $kept) -}}
{{- $names = append $names $name -}}
{{- end -}}
{{- end -}}
{{- $names | uniq | join "|" -}}
{{- end }}

{{/*
Selector labels, shared by a component's workload selector, pod labels, and
Service and PodDisruptionBudget selectors, so they cannot drift apart.

Pass the root context and the component's values:

{{ include "sourcegraph.selectorLabels" (list . .Values.frontend) }}
*/}}
{{- define "sourcegraph.selectorLabels" -}}
{{- $top := index . 0 -}}
{{- if not $top.Values.sourcegraph.selectorLabelsOverride -}}
app.kubernetes.io/name: {{ include "sourcegraph.name" $top }}
app.kubernetes.io/instance: {{ $top.Release.Name }}
{{- end }}
{{- with include "sourcegraph.customSelectorLabels" . }}
{{ . }}
{{- end }}
{{- end }}

{{/*
Labels of a component's pod template: the common labels, then
sourcegraph.podLabels, then the component's podLabels, then its selector labels.
The later one wins when a key is set more than once, so each key is rendered
once and the selector always matches the pods.

`helm.sh/chart` and `app.kubernetes.io/version` are left out: they change with
every chart version, and a changed pod template restarts the pods.

{{ include "sourcegraph.podLabels" (list . .Values.frontend) }}
*/}}
{{- define "sourcegraph.podLabels" -}}
{{- $top := index . 0 -}}
{{- $component := index . 1 -}}
{{- $labels := omit (include "sourcegraph.labels" $top | fromYaml) "helm.sh/chart" "app.kubernetes.io/version" -}}
{{- mergeOverwrite $labels ($top.Values.sourcegraph.podLabels | default dict) ($component.podLabels | default dict) (include "sourcegraph.selectorLabels" . | fromYaml) | toYaml -}}
{{- end }}

{{/*
The selector labels set in values: sourcegraph.selectorLabelsOverride, which
replaces the default selector labels on every component, merged with the
component's extraSelectorLabels. Empty by default.

These exist to adopt workloads created outside this chart, whose selectors
are immutable. The chart sets the labels in $chartLabels itself, so
overriding one would stop a selector from matching its pods.
*/}}
{{- define "sourcegraph.customSelectorLabels" -}}
{{- $top := index . 0 -}}
{{- $component := index . 1 -}}
{{- $chartLabels := list "app" "deploy" "group" "type" "worker-replica" -}}
{{- $labels := mergeOverwrite (dict) ($top.Values.sourcegraph.selectorLabelsOverride | default dict) ($component.extraSelectorLabels | default dict) -}}
{{- range $chartLabel := $chartLabels -}}
{{- if hasKey $labels $chartLabel -}}
{{- fail (printf "sourcegraph.selectorLabelsOverride and <serviceName>.extraSelectorLabels must not set the label %q, which the chart sets itself" $chartLabel) -}}
{{- end -}}
{{- end -}}
{{- with $labels -}}
{{ toYaml . }}
{{- end -}}
{{- end }}

{{/*
The labels set in <serviceName>.serviceAccount.labels, rendered on the
component's ServiceAccount and on its Role, RoleBinding, ClusterRole, and
ClusterRoleBinding, if it has any. Empty by default.

Takes the same arguments as "sourcegraph.serviceAccountName".
*/}}
{{- define "sourcegraph.serviceAccountLabels" -}}
{{- $top := index . 0 }}
{{- if hasKey $top "Values" -}}
{{- $top = index $top "Values" -}}
{{- end -}}
{{- $service := index . 1 }}
{{- with (index $top $service "serviceAccount" "labels") }}
{{- toYaml . }}
{{- end }}
{{- end }}

{{/*
Jaeger common labels
*/}}
{{- define "sourcegraph.jaeger.labels" -}}
helm.sh/chart: {{ include "sourcegraph.chart" . }}
{{ include "sourcegraph.jaeger.selectorLabels" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- if .Values.sourcegraph.labels }}
{{ toYaml .Values.sourcegraph.labels }}
{{- end }}
{{- end }}

{{/*
Jaeger selector labels
*/}}
{{- define "sourcegraph.jaeger.selectorLabels" -}}
app.kubernetes.io/name: jaeger
{{- end }}
