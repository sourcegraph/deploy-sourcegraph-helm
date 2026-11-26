{{/*
Render the image reference for an indexed search continuity image.
Usage: include "sourcegraph.indexedSearchContinuity.image" (list . .Values.indexedSearcher.image)
The tag defaults to the chart appVersion when the image sets no defaultTag.
*/}}
{{- define "sourcegraph.indexedSearchContinuity.image" -}}
{{- $top := index . 0 -}}
{{- $image := index . 1 -}}
{{- $repository := default $top.Values.sourcegraph.image.repository $image.repository -}}
{{- $defaultTag := tpl (toString (default "{{ .Chart.AppVersion }}" $image.defaultTag)) $top -}}
{{- if $top.Values.sourcegraph.image.useGlobalTagAsDefault }}{{ $defaultTag = (tpl $top.Values.sourcegraph.image.defaultTag $top) }}{{ end -}}
{{- $repository }}/{{ $image.name }}:{{ default $defaultTag $image.tag }}
{{- end }}

{{/*
Render the environment variables that every indexed search continuity participant
(webserver, indexer, frontend, worker, searcher, gitserver) must share. Renders nothing when
continuity is disabled.
*/}}
{{- define "sourcegraph.indexedSearchContinuity.env" -}}
{{- $continuity := .Values.indexedSearch.continuity -}}
{{- if $continuity.enabled -}}
- name: SRC_INDEXED_SEARCH_CONTINUITY_ENABLED
  value: "true"
- name: SRC_INDEXED_SEARCH_CONTINUITY_ROUTING
  value: {{ $continuity.routing | quote }}
- name: SRC_INDEXED_SEARCH_CONTINUITY_WARM_REPLICAS
  value: {{ $continuity.replicas | quote }}
- name: SRC_INDEXED_SEARCH_CONTINUITY_ACTIVATION_TOLERANCE
  value: {{ $continuity.activationTolerance | quote }}
{{- with $continuity.replicationFactors }}
- name: SRC_INDEXED_SEARCH_CONTINUITY_REPLICATION_FACTORS
  value: {{ . | quote }}
{{- end }}
{{- range $name, $item := $continuity.env }}
- name: {{ $name }}
  {{- $item | toYaml | nindent 2 }}
{{- end }}
{{- end -}}
{{- end }}

{{/*
Fail rendering when the continuity values are inconsistent.
*/}}
{{- define "sourcegraph.indexedSearchContinuity.validate" -}}
{{- $continuity := .Values.indexedSearch.continuity -}}
{{- if $continuity.enabled -}}
{{- if lt (int .Values.indexedSearcher.terminationGracePeriodSeconds) 30 -}}
{{- fail "indexedSearcher.terminationGracePeriodSeconds must be at least 30" -}}
{{- end -}}
{{- if gt (int $continuity.replicas) (int .Values.indexedSearcher.replicaCount) -}}
{{- fail "indexedSearch.continuity.replicas must not exceed indexedSearcher.replicaCount" -}}
{{- end -}}
{{- if and (not $continuity.routing) (not .Values.indexedSearch.enabled) -}}
{{- fail "indexedSearch.continuity.routing must be true when indexedSearch.enabled is false: searches would go to the removed indexed-search StatefulSet" -}}
{{- end -}}
{{- if lt (int $continuity.activationTolerance) 0 -}}
{{- fail "indexedSearch.continuity.activationTolerance must not be negative" -}}
{{- end -}}
{{- if and (gt (int $continuity.replicas) 1) (ge (int $continuity.activationTolerance) (int $continuity.replicas)) -}}
{{- fail "indexedSearch.continuity.activationTolerance must be less than indexedSearch.continuity.replicas" -}}
{{- end -}}
{{- end -}}
{{- end }}
