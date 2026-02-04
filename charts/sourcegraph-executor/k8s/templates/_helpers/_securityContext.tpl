{{/*

Security context helpers for container and pod security contexts.

These helpers implement a 3-tier merge precedence:
1. Component default (e.g., .Values.executor.defaultContainerSecurityContext)
2. Global override (e.g., .Values.sourcegraph.containerSecurityContext)
3. Component override (e.g., .Values.executor.securityContext for container, .Values.executor.podSecurityContext for pod)

Later values override earlier ones, allowing customers to:
- Set global security context settings that apply to all components
- Override specific components as needed
- Retain Sourcegraph's secure defaults when no overrides are specified

*/}}

{{/*
Container security context with 3-tier merge.
Outputs "securityContext:" key with merged values, or nothing if empty.
The output includes a leading newline for proper YAML formatting.

Usage:
  {{- include "sourcegraph.containerSecurityContext" (list . "executor" 8) }}

Parameters:
  - $ (root context)
  - component path segments (one or more strings)
  - indent level (integer) as the last parameter
*/}}
{{- define "sourcegraph.containerSecurityContext" -}}
{{- $root := index . 0 -}}
{{- $indent := int (index . (sub (len .) 1)) -}}
{{- $path := slice . 1 (sub (len .) 1) -}}
{{- $component := $root.Values -}}
{{- range $path -}}
{{- $component = index $component . | default dict -}}
{{- end -}}
{{- $default := $component.defaultContainerSecurityContext | default dict -}}
{{- $global := $root.Values.sourcegraph.containerSecurityContext | default dict -}}
{{- $override := $component.securityContext | default dict -}}
{{- $merged := mustMergeOverwrite (deepCopy $default) $global $override -}}
{{- if $merged | keys | len | ne 0 }}
{{ "securityContext:" | indent $indent }}
{{ toYaml $merged | indent (int (add $indent 2)) -}}
{{- end -}}
{{- end -}}

{{/*
Pod security context with 3-tier merge.
Outputs "securityContext:" key with merged values, or nothing if empty.
The output includes a leading newline for proper YAML formatting.

Usage:
  {{- include "sourcegraph.podSecurityContext" (list . "executor" 6) }}

Parameters:
  - $ (root context)
  - component path segments (one or more strings)
  - indent level (integer) as the last parameter
*/}}
{{- define "sourcegraph.podSecurityContext" -}}
{{- $root := index . 0 -}}
{{- $indent := int (index . (sub (len .) 1)) -}}
{{- $path := slice . 1 (sub (len .) 1) -}}
{{- $component := $root.Values -}}
{{- range $path -}}
{{- $component = index $component . | default dict -}}
{{- end -}}
{{- $default := $component.defaultPodSecurityContext | default dict -}}
{{- $global := $root.Values.sourcegraph.podSecurityContext | default dict -}}
{{- $override := $component.podSecurityContext | default dict -}}
{{- $merged := mustMergeOverwrite (deepCopy $default) $global $override -}}
{{- if $merged | keys | len | ne 0 }}
{{ "securityContext:" | indent $indent }}
{{ toYaml $merged | indent (int (add $indent 2)) -}}
{{- end -}}
{{- end -}}
