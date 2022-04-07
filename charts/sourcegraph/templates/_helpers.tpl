{{/*
Expand the name of the chart.
*/}}
{{- define "sourcegraph.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "sourcegraph.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

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
Create the name of the service account to use
*/}}
{{- define "sourcegraph.serviceAccountName" -}}
{{- $top := index . 0 }}
{{- $service := index . 1 }}
{{- $defaultServiceAccountName := (index $top.Values $service "name") }}
{{- default $defaultServiceAccountName (index $top.Values $service "serviceAccount" "name") }}
{{- end }}

{{- define "sourcegraph.renderServiceAccountName" -}}
{{- $top := index . 0 }}
{{- $service := index . 1 }}
{{- if or (index $top.Values $service "serviceAccount" "create") (index $top.Values $service "serviceAccount" "name") }}
serviceAccountName: {{ include "sourcegraph.serviceAccountName" (list $top $service) }}
{{- end }}
{{- end }}

{{/*
Create the docker image reference and allow it to be overridden on a per-service basis
Default tags are toggled between a global and service-specific setting by the
useGlobalTagAsDefault configuration
*/}}
{{- define "sourcegraph.image" -}}
{{- $top := index . 0 }}
{{- $service := index . 1 }}
{{- $imageName := (index $top.Values $service "image" "name")}}
{{- $defaultTag := (index $top.Values $service "image" "defaultTag")}}
{{- if $top.Values.sourcegraph.image.useGlobalTagAsDefault }}{{ $defaultTag = (tpl $top.Values.sourcegraph.image.defaultTag $top) }}{{ end }}

{{- $top.Values.sourcegraph.image.repository }}/{{ $imageName }}:{{ default $defaultTag (index $top.Values $service "image" "tag") }}
{{- end }}

{{- define "sourcegraph.nodeSelector" -}}
{{- $top := index . 0 }}
{{- $service := index . 1 }}
{{- $globalNodeSelector := (index $top.Values "sourcegraph" "nodeSelector") }}
{{- $serviceNodeSelector := (index $top.Values $service "nodeSelector") }}
nodeSelector:
{{- if $serviceNodeSelector }}
{{- $serviceNodeSelector | toYaml | trim | nindent 2 }}
{{- else if $globalNodeSelector }}
{{- $globalNodeSelector | toYaml | trim | nindent 2 }}
{{- end }}
{{- end }}

{{- define "sourcegraph.affinity" -}}
{{- $top := index . 0 }}
{{- $service := index . 1 }}
{{- $globalAffinity := (index $top.Values "sourcegraph" "affinity") }}
{{- $serviceAffinity := (index $top.Values $service "affinity") }}
affinity:
{{- if $serviceAffinity }}
{{- tpl ($serviceAffinity | toYaml) $top | trim | nindent 2 }}
{{- else if $globalAffinity }}
{{- tpl ($globalAffinity | toYaml) $top | trim | nindent 2 }}
{{- end }}
{{- end }}

{{- define "sourcegraph.tolerations" -}}
{{- $top := index . 0 }}
{{- $service := index . 1 }}
{{- $globalTolerations := (index $top.Values "sourcegraph" "tolerations") }}
{{- $serviceTolerations := (index $top.Values $service "tolerations") }}
tolerations:
{{- if $serviceTolerations }}
{{- $serviceTolerations | toYaml | trim | nindent 2 }}
{{- else if $globalTolerations }}
{{- $globalTolerations | toYaml | trim | nindent 2 }}
{{- end }}
{{- end }}

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

{{- define "sourcegraph.databaseAuth" -}}
{{- $top := index . 0 -}}
{{- $service := index . 1 -}}
{{- $prefix := index . 2 -}}
{{- $secretName := (index $top.Values $service "name") -}}
{{- $secretName := printf "%s-auth" $secretName -}}
{{- if (index $top.Values $service "auth" "existingSecret") }}{{- $secretName = (index $top.Values $service "auth" "existingSecret") }}{{- end -}}
- name: {{ printf "%sDATABASE" $prefix }}
  valueFrom:
    secretKeyRef:
      key: database
      name: {{ $secretName }}
- name: {{ printf "%sHOST" $prefix }}
  valueFrom:
    secretKeyRef:
      key: host
      name: {{ $secretName }}
- name: {{ printf "%sPASSWORD" $prefix }}
  valueFrom:
    secretKeyRef:
      key: password
      name: {{ $secretName }}
- name: {{ printf "%sPORT" $prefix }}
  valueFrom:
    secretKeyRef:
      key: port
      name: {{ $secretName }}
- name: {{ printf "%sUSER" $prefix }}
  valueFrom:
    secretKeyRef:
      key: user
      name: {{ $secretName }}
{{- end }}

{{- define "sourcegraph.dataSource" -}}
{{- $top := index . 0 -}}
{{- $service := index . 1 -}}
{{- $secretName := (index $top.Values $service "name") -}}
{{- $secretName := printf "%s-auth" $secretName -}}
{{- if (index $top.Values $service "auth" "existingSecret") }}{{- $secretName = (index $top.Values $service "auth" "existingSecret") }}{{- end -}}
- name: DATA_SOURCE_DB
  valueFrom:
    secretKeyRef:
      key: database
      name: {{ $secretName }}
- name: DATA_SOURCE_PASS
  valueFrom:
    secretKeyRef:
      key: password
      name: {{ $secretName }}
- name: DATA_SOURCE_PORT
  valueFrom:
    secretKeyRef:
      key: port
      name: {{ $secretName }}
- name: DATA_SOURCE_USER
  valueFrom:
    secretKeyRef:
      key: user
      name: {{ $secretName }}
- name: DATA_SOURCE_URI
  value: "localhost:$(DATA_SOURCE_PORT)/$(DATA_SOURCE_DB)?sslmode=disable"
{{- end }}

{{- define "sourcegraph.redisConnection" -}}
- name: REDIS_CACHE_ENDPOINT
  valueFrom:
    secretKeyRef:
      key: endpoint
      name: {{ default .Values.redisCache.name .Values.redisCache.connection.existingSecret }}
- name: REDIS_STORE_ENDPOINT
  valueFrom:
    secretKeyRef:
      key: endpoint
      name: {{ default .Values.redisStore.name .Values.redisStore.connection.existingSecret }}
{{- end }}

{{- define "sourcegraph.authChecksum" -}}
{{- $checksum := list (include (print $.Template.BasePath "/codeintel-db/codeintel-db.Secret.yaml") .)}}
{{- $checksum := append $checksum (include (print $.Template.BasePath "/minio/minio.Secret.yaml") .) }}
{{- $checksum := append $checksum (include (print $.Template.BasePath "/pgsql/pgsql.Secret.yaml") .) }}
{{- $checksum := append $checksum (include (print $.Template.BasePath "/codeinsights-db/codeinsights-db.Secret.yaml") .) -}}
checksum/auth: {{ $checksum | join "" | sha256sum }}
{{- end -}}

{{- define "sourcegraph.redisChecksum" -}}
{{- $checksum := list (include (print $.Template.BasePath "/redis/redis-store.Secret.yaml") .)}}
{{- $checksum := append $checksum (include (print $.Template.BasePath "/redis/redis-cache.Secret.yaml") .) -}}
checksum/redis-auth: {{ $checksum | join "" | sha256sum }}
{{- end -}}
