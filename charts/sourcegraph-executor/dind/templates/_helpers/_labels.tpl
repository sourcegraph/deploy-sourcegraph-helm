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

Maps passed after the component's values are merged last, in order, for the
labels the template sets itself.

{{ include "sourcegraph.podLabels" (list . .Values.executor) }}
*/}}
{{- define "sourcegraph.podLabels" -}}
{{- $top := index . 0 -}}
{{- $component := index . 1 -}}
{{- $labels := omit (include "sourcegraph.labels" $top | fromYaml) "helm.sh/chart" "app.kubernetes.io/version" -}}
{{- $labels = mergeOverwrite $labels ($top.Values.sourcegraph.podLabels | default dict) ($component.podLabels | default dict) (include "sourcegraph.selectorLabels" $top | fromYaml) -}}
{{- range slice . 2 -}}
{{- range $key, $value := . -}}
{{- $_ := set $labels $key $value -}}
{{- end -}}
{{- end -}}
{{- toYaml $labels -}}
{{- end }}

{{- define "executor.labels" -}}
app: {{ include "executor.name" . }}
deploy: sourcegraph
sourcegraph-resource-requires: no-cluster-admin
app.kubernetes.io/component: executor
{{- end}}

{{/*
An object's labels, with each key rendered once: the common labels, then each
map passed after the root context, in order. A later map wins when a key is set
more than once, as the later line did when each map was rendered on its own.
Kustomize and kubeconform reject a key that is rendered twice.

{{ include "sourcegraph.mergedLabels" (list . .Values.blobstore.storageLabels (dict "deploy" "sourcegraph")) }}
*/}}
{{- define "sourcegraph.mergedLabels" -}}
{{- $labels := include "sourcegraph.labels" (first .) | fromYaml -}}
{{- range rest . -}}
{{- range $key, $value := . -}}
{{- $_ := set $labels $key $value -}}
{{- end -}}
{{- end -}}
{{- toYaml $labels -}}
{{- end }}
