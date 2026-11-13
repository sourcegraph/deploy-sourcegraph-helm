{{/*
Common labels
*/}}
{{- define "sourcegraph.labels" -}}
helm.sh/chart: {{ include "sourcegraph.chart" . }}
{{ include "sourcegraph.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- if .Values.sourcegraph.labels }}
{{ toYaml .Values.sourcegraph.labels }}
{{- end }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "sourcegraph.selectorLabels" -}}
app.kubernetes.io/name: {{ include "sourcegraph.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Labels of a pod template: the common labels, then sourcegraph.podLabels, then
the component's podLabels, then the selector labels. The later one wins when a
key is set more than once, so each key is rendered once and the selector always
matches the pods.

`helm.sh/chart` and `app.kubernetes.io/version` are left out: they change with
every chart version, and a changed pod template restarts the pods.

{{ include "sourcegraph.podLabels" (list . .Values.executor) }}
*/}}
{{- define "sourcegraph.podLabels" -}}
{{- $top := index . 0 -}}
{{- $component := index . 1 -}}
{{- $labels := omit (include "sourcegraph.labels" $top | fromYaml) "helm.sh/chart" "app.kubernetes.io/version" -}}
{{- mergeOverwrite $labels ($top.Values.sourcegraph.podLabels | default dict) ($component.podLabels | default dict) (include "sourcegraph.selectorLabels" $top | fromYaml) | toYaml -}}
{{- end }}

{{- define "executor.labels" -}}
app: {{ include "executor.name" . }}
deploy: sourcegraph
sourcegraph-resource-requires: no-cluster-admin
app.kubernetes.io/component: executor
{{- end}}
