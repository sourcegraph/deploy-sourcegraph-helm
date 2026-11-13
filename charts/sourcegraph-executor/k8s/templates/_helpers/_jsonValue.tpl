{{/*
Render a value the executor parses as JSON (tolerations, affinity, ...).
A YAML list or map is JSON-encoded. A string is rendered as-is, so the
pre-escaped JSON strings documented before YAML lists were supported, like
'[{\"key\":\"foo\"}]', keep working.
*/}}
{{- define "executor.jsonValue" -}}
{{- if kindIs "string" . -}}"{{ . }}"{{- else -}}{{ toJson . | quote }}{{- end -}}
{{- end }}
