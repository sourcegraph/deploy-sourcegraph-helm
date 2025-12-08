{{/*
Create the name of the service account to use

When calling these partial functions,

For top-level services, pass in the top-level values:

{{ include "sourcegraph.serviceAccountName" (list . "frontend") }}

frontend:
  serviceAccount:
    create: false

For nested services, pass in the nested values:

{{ include "sourcegraph.serviceAccountName" (list .Values.openTelemetry "gateway") }}

openTelemetry:
  gateway:
    serviceAccount:
      create: false
*/}}
{{- define "sourcegraph.serviceAccountName" -}}
{{- $top := index . 0 }}
{{- if hasKey $top "Values" -}}
{{- $top = index $top "Values" -}}
{{- end -}}
{{- $service := index . 1 }}
{{- $defaultServiceAccountName := (index $top $service "name") }}
{{- default $defaultServiceAccountName (index $top $service "serviceAccount" "name") }}
{{- end -}}

{{- define "sourcegraph.renderServiceAccountName" -}}
{{- $top := index . 0 }}
{{- if hasKey $top "Values" -}}
{{- $top = index $top "Values" -}}
{{- end -}}
{{- $service := index . 1 }}
{{- if or (index $top $service "serviceAccount" "create") (index $top $service "serviceAccount" "name") }}
serviceAccountName: {{ include "sourcegraph.serviceAccountName" (list $top $service) }}
{{- end -}}
{{- end -}}

{{- define "sourcegraph.serviceAccountAnnotations" -}}
{{- $top := index . 0 }}
{{- if hasKey $top "Values" -}}
{{- $top = index $top "Values" -}}
{{- end -}}
{{- $service := index . 1 }}
{{- with (index $top $service "serviceAccount" "annotations") }}
annotations:
{{- . | toYaml | trim | nindent 2 }}
{{- end }}
{{- end }}
