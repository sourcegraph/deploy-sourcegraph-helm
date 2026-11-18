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
Create the name of the service account to use
*/}}
{{- define "sourcegraph.serviceAccountName" -}}
{{- $top := index . 0 }}
{{- $service := index . 1 }}
{{- default $service (index $top.Values $service "serviceAccount" "name") }}
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


{{- define "executor.name" -}}
{{- if .Values.executor.queueName -}}
executor-{{.Values.executor.queueName}}
{{- else if .Values.executor.queueNames -}}
executor-{{join "-" .Values.executor.queueNames }}
{{- end }}
{{- end }}

{{- define "dind.daemonConfig" -}}
{{- $config := .Values.dind.daemonConfig | deepCopy }}
{{- if .Values.dind.gVisor.enabled }}
{{- $config = mergeOverwrite $config .Values.dind.gVisor.daemonConfig }}
{{- end }}
{{- $config | toPrettyJson }}
{{- end }}

{{/*
Validate that an env dict does not contain managed environment variable names.
Usage: include "executor.validateEnv" (list $envDict "label")
*/}}
{{- define "executor.validateEnv" -}}
{{- $envDict := index . 0 }}
{{- $label := index . 1 }}
{{- $managed := list
    "EXECUTOR_FRONTEND_URL"
    "EXECUTOR_FRONTEND_PASSWORD"
    "EXECUTOR_QUEUE_NAME"
    "EXECUTOR_QUEUE_NAMES"
    "SRC_LOG_LEVEL"
    "SRC_LOG_FORMAT"
    "EXECUTOR_MAXIMUM_NUM_JOBS"
    "EXECUTOR_MAXIMUM_RUNTIME_PER_JOB"
    "EXECUTOR_DOCKER_ADD_HOST_GATEWAY"
    "EXECUTOR_KEEP_WORKSPACES" -}}
{{- range $managed -}}
{{- if hasKey $envDict . -}}
{{- fail (printf "%s: env must not contain managed variable %s; use the structured executor fields instead" $label .) -}}
{{- end -}}
{{- end -}}
{{- end -}}
