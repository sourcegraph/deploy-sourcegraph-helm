{{/*
Jaeger common labels
*/}}
{{- define "sourcegraph.jaeger.labels" -}}
helm.sh/chart: {{ include "sourcegraph.chart" . }}
{{ include "sourcegraph.jaeger.selectorLabels" . }}
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
