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

{{/*
Create the docker image reference and allow it to be overridden on a per-service basis
Default tags are toggled between a global and service-specific setting by the
useGlobalTagAsDefault configuration
The image repository defaults to the global sourcegraph.image.repository, but can be
overridden on a per-service basis via the service's image.repository setting
*/}}
{{- define "sourcegraph.image" -}}
{{- $top := index . 0 }}
{{- $service := index . 1 }}
{{- $imageName := (index $top.Values $service "image" "name")}}
{{- $defaultTag := (index $top.Values $service "image" "defaultTag")}}
{{- $defaultTagPrefix := (index $top.Values $service "image" "defaultTagPrefix")}}
{{- $repository := default $top.Values.sourcegraph.image.repository (index $top.Values $service "image" "repository") }}
{{- if $top.Values.sourcegraph.image.useGlobalTagAsDefault }}{{ $defaultTag = (tpl $top.Values.sourcegraph.image.defaultTag $top) }}{{ end }}

{{- $repository }}/{{ $imageName }}:{{ $defaultTagPrefix }}{{ default $defaultTag (index $top.Values $service "image" "tag") }}
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

{{- define "sourcegraph.openTelemetryEnv" -}}
{{- if .Values.openTelemetry.enabled -}}
{{- if eq (.Values.openTelemetry.agent.kind | default "DaemonSet") "Deployment" -}}
- name: OTEL_EXPORTER_OTLP_ENDPOINT
  value: http://otel-collector:4317
{{- else -}}
# OTEL_AGENT_HOST must be defined before OTEL_EXPORTER_OTLP_ENDPOINT to substitute the node IP on which the DaemonSet pod instance runs in the latter variable
- name: OTEL_AGENT_HOST
  valueFrom:
    fieldRef:
      fieldPath: status.hostIP
- name: OTEL_EXPORTER_OTLP_ENDPOINT
  value: http://$(OTEL_AGENT_HOST):{{ toYaml .Values.openTelemetry.agent.hostPorts.grpcOtlp }}
{{- end }}
{{- end }}
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
- name: {{ printf "%sSSLMODE" $prefix }}
  valueFrom:
    secretKeyRef:
      key: sslmode
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

{{/*
Set redisCache and redisStore endpoints,
so that customers can configure them any of these ways:

1. Create new Kubernetes secrets, with default values (default, no override config required)

2. Use existing Kubernetes secrets, managed externally, by configuring:
.Values.redisCache.connection.existingSecret: <secret name>
.Values.redisStore.connection.existingSecret: <secret name>

3. Do not create or use Kubernetes secrets, just pass the default values directly as environment variables into the needed pods, by configuring:
.Values.sourcegraph.disableKubernetesSecrets: true

4. Do not create or use Kubernetes secrets, but provide custom values (ex. external Redis) to have this function pass them into the REDIS_CACHE_ENDPOINT and REDIS_STORE_ENDPOINT env vars on frontend, gitserver, searcher, and worker pods, by configuring:
.Values.sourcegraph.disableKubernetesSecrets: true
.Values.redisCache.connection.endpoint: <custom value for REDIS_CACHE_ENDPOINT>
.Values.redisStore.connection.endpoint: <custom value for REDIS_STORE_ENDPOINT>

*/}}
{{- define "sourcegraph.redisConnection" -}}
{{- if .Values.sourcegraph.disableKubernetesSecrets -}}
{{- $cacheEndpoint := dig "connection" "endpoint" "" .Values.redisCache -}}
{{- $storeEndpoint := dig "connection" "endpoint" "" .Values.redisStore -}}
{{- if not (and $cacheEndpoint $storeEndpoint) -}}
{{- fail ".Values.redisCache.connection.endpoint and .Values.redisStore.connection.endpoint must be set when disableKubernetesSecrets is true!" -}}
{{- end -}}
- name: REDIS_CACHE_ENDPOINT
  value: {{ $cacheEndpoint }}
- name: REDIS_STORE_ENDPOINT
  value: {{ $storeEndpoint }}
{{- else -}}
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
{{- end -}}
{{- end -}}

{{- define "sourcegraph.authChecksum" -}}
{{- $checksum := list .Values.codeInsightsDB.auth -}}
{{- $checksum = append $checksum .Values.codeIntelDB.auth -}}
{{- $checksum = append $checksum .Values.pgsql.auth -}}
checksum/auth: {{ toJson $checksum | sha256sum }}
{{- end -}}

{{- define "sourcegraph.redisChecksum" -}}
{{- $checksum := list .Values.redisStore.connection -}}
{{- $checksum := append $checksum .Values.redisCache.connection -}}
checksum/redis: {{ toJson $checksum | sha256sum }}
{{- end -}}

{{/*
Resolve the redis `maxmemory` directive for a service.
Usage: include "sourcegraph.redis.maxmemory" (list . "redisCache")

Resolution order:
  1. <service>.config.maxmemory, used verbatim.
  2. floor(<service>.config.maxmemoryRatio * <service>.resources.limits.memory),
     rendered as a plain byte count.
  3. Empty string, when there is no memory limit or the quantity is not
     recognised. The caller then emits no `maxmemory` and the vendored default
     stands.
*/}}
{{- define "sourcegraph.redis.maxmemory" -}}
{{- $top := index . 0 -}}
{{- $service := index . 1 -}}
{{- $values := index $top.Values $service -}}
{{- $config := $values.config | default dict -}}
{{- if $config.maxmemory -}}
{{- $config.maxmemory -}}
{{- else -}}
{{- $limit := dig "resources" "limits" "memory" "" $values | toString -}}
{{- $number := regexReplaceAll "^([0-9]+(\\.[0-9]+)?).*$" $limit "${1}" -}}
{{- $suffix := regexReplaceAll "^[0-9]+(\\.[0-9]+)?" $limit "" -}}
{{- /* Kubernetes quantity suffixes: binary (1024^n) and decimal (1000^n). */ -}}
{{- $units := dict "" 1.0 "k" 1e3 "M" 1e6 "G" 1e9 "T" 1e12 "P" 1e15 "E" 1e18 "Ki" 1024.0 "Mi" 1048576.0 "Gi" 1073741824.0 "Ti" 1099511627776.0 "Pi" 1125899906842624.0 "Ei" 1152921504606846976.0 -}}
{{- if and (regexMatch "^[0-9]+(\\.[0-9]+)?$" $number) (hasKey $units $suffix) -}}
{{- $ratio := $config.maxmemoryRatio | default 0.75 | float64 -}}
{{- $bytes := floor (mulf (float64 $number) (index $units $suffix) $ratio) -}}
{{- if gt $bytes 0.0 -}}
{{- printf "%d" (int64 $bytes) -}}
{{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Fail the render when a service's extra volumes or volume mounts collide with the
chart-managed redis config mount. Without this the collision only surfaces as an
opaque "must be unique" rejection from the API server.
Usage: include "sourcegraph.redis.assertNoConfClash" (list . "redisCache")
*/}}
{{- define "sourcegraph.redis.assertNoConfClash" -}}
{{- $top := index . 0 -}}
{{- $service := index . 1 -}}
{{- $values := index $top.Values $service -}}
{{- range ($values.extraVolumeMounts | default list) -}}
{{- if has .mountPath (list "/etc/redis/redis.conf" "/etc/redis" "/etc/redis/") -}}
{{- fail (printf "%s.extraVolumeMounts must not mount over /etc/redis/redis.conf; the chart now manages that file. Move your custom redis config to %s.config.existingConfig or %s.config.additionalConfig." $service $service $service) -}}
{{- end -}}
{{- end -}}
{{- range (concat ($values.extraVolumes | default list) ($values.extraVolumeMounts | default list)) -}}
{{- if eq (.name | toString) "redis-conf" -}}
{{- fail (printf "%s must not define a volume named 'redis-conf'; the chart reserves that name for the redis config mount." $service) -}}
{{- end -}}
{{- end -}}
{{- end -}}
