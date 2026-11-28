{{/*
Render the image reference for a Zoekt indexer or searcher image.
Usage: include "sourcegraph.zoekt.image" (list . .Values.zoektSearcher.image)
The tag defaults to the chart appVersion when the image sets no defaultTag.
*/}}
{{- define "sourcegraph.zoekt.image" -}}
{{- $top := index . 0 -}}
{{- $image := index . 1 -}}
{{- $repository := default $top.Values.sourcegraph.image.repository $image.repository -}}
{{- $defaultTag := tpl (toString (default "{{ .Chart.AppVersion }}" $image.defaultTag)) $top -}}
{{- if $top.Values.sourcegraph.image.useGlobalTagAsDefault }}{{ $defaultTag = (tpl $top.Values.sourcegraph.image.defaultTag $top) }}{{ end -}}
{{- $repository }}/{{ $image.name }}:{{ default $defaultTag $image.tag }}
{{- end }}

{{/*
Render the environment variables that the Zoekt searchers and indexers, frontend, worker, and
searcher must share. Renders nothing when the Zoekt indexer is disabled.
*/}}
{{- define "sourcegraph.zoekt.env" -}}
{{- $zoekt := .Values.zoekt -}}
{{- if $zoekt.enabled -}}
- name: SRC_ZOEKT_INDEXER_ENABLED
  value: "true"
- name: SRC_ZOEKT_WARM_REPLICAS
  value: {{ $zoekt.replicas | quote }}
- name: SRC_ZOEKT_ACTIVATION_TOLERANCE
  value: {{ $zoekt.activationTolerance | quote }}
{{- with $zoekt.replicationFactors }}
- name: SRC_ZOEKT_REPLICATION_FACTORS
  value: {{ . | quote }}
{{- end }}
{{- range $name, $item := $zoekt.env }}
- name: {{ $name }}
  {{- $item | toYaml | nindent 2 }}
{{- end }}
{{- end -}}
{{- end }}

{{/*
Render SRC_ZOEKT_SEARCHER_ROUTING for the services that search indexed search
(frontend, worker, searcher). It is kept out of the shared environment so that switching
routing does not restart the Zoekt searchers or indexers, which do not read it.
Renders nothing when the Zoekt indexer is disabled.
*/}}
{{- define "sourcegraph.zoekt.routingEnv" -}}
{{- if .Values.zoekt.enabled -}}
- name: SRC_ZOEKT_SEARCHER_ROUTING
  value: {{ .Values.zoekt.routing | quote }}
{{- end -}}
{{- end }}

{{/*
Fail rendering when the zoekt values are inconsistent.
*/}}
{{- define "sourcegraph.zoekt.validate" -}}
{{- $zoekt := .Values.zoekt -}}
{{- if $zoekt.enabled -}}
{{- if lt (int .Values.zoektSearcher.terminationGracePeriodSeconds) 30 -}}
{{- fail "zoektSearcher.terminationGracePeriodSeconds must be at least 30" -}}
{{- end -}}
{{- if gt (int $zoekt.replicas) (int .Values.zoektSearcher.replicaCount) -}}
{{- fail "zoekt.replicas must not exceed zoektSearcher.replicaCount" -}}
{{- end -}}
{{- if and (not $zoekt.routing) (not .Values.indexedSearch.enabled) -}}
{{- fail "zoekt.routing must be true when indexedSearch.enabled is false: searches would go to the removed indexed-search StatefulSet" -}}
{{- end -}}
{{- if lt (int $zoekt.activationTolerance) 0 -}}
{{- fail "zoekt.activationTolerance must not be negative" -}}
{{- end -}}
{{- if and (gt (int $zoekt.replicas) 1) (ge (int $zoekt.activationTolerance) (int $zoekt.replicas)) -}}
{{- fail "zoekt.activationTolerance must be less than zoekt.replicas" -}}
{{- end -}}
{{- end -}}
{{- end }}
