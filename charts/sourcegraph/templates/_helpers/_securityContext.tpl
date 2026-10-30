{{/*

Security context helpers for container and pod security contexts.

These helpers implement a 3-tier merge precedence:
1. Component default (e.g., .Values.frontend.defaultContainerSecurityContext)
2. Global override (e.g., .Values.sourcegraph.containerSecurityContext)
3. Component override (e.g., .Values.frontend.containerSecurityContext)

Later values override earlier ones, allowing customers to:
- Set global security context settings that apply to all components
- Override specific components as needed
- Retain Sourcegraph's secure defaults when no overrides are specified

Supports nested paths like "openTelemetry" "gateway" or "codeInsightsDB" "init".

*/}}

{{/*
Internal: walk the component path and merge default, global, and component
override security contexts. Returns the merged map as YAML.

Parameters:
  - $ (root context)
  - default key, e.g. "defaultContainerSecurityContext"
  - override key, e.g. "containerSecurityContext"; also the global key under .Values.sourcegraph
  - component path segments (one or more strings)
*/}}
{{- define "sourcegraph.mergeSecurityContext" -}}
{{- $root := index . 0 -}}
{{- $defaultKey := index . 1 -}}
{{- $overrideKey := index . 2 -}}
{{- $component := $root.Values -}}
{{- range slice . 3 -}}
{{- $component = index $component . | default dict -}}
{{- end -}}
{{- $default := index $component $defaultKey | default dict -}}
{{- $global := index $root.Values.sourcegraph $overrideKey | default dict -}}
{{- $override := index $component $overrideKey | default dict -}}
{{- mustMergeOverwrite (deepCopy $default) $global $override | toYaml -}}
{{- end -}}

{{/*
Merged container security context as YAML. Pipe through fromYaml to read fields.

Usage:
  {{- $merged := include "sourcegraph.mergedContainerSecurityContext" (list . "frontend") | fromYaml }}

Parameters:
  - $ (root context)
  - component path segments (one or more strings)
*/}}
{{- define "sourcegraph.mergedContainerSecurityContext" -}}
{{- include "sourcegraph.mergeSecurityContext" (concat (list (index . 0) "defaultContainerSecurityContext" "containerSecurityContext") (slice . 1)) -}}
{{- end -}}

{{/*
Merged pod security context as YAML. Pipe through fromYaml to read fields.

Usage:
  {{- $merged := include "sourcegraph.mergedPodSecurityContext" (list . "frontend") | fromYaml }}

Parameters:
  - $ (root context)
  - component path segments (one or more strings)
*/}}
{{- define "sourcegraph.mergedPodSecurityContext" -}}
{{- include "sourcegraph.mergeSecurityContext" (concat (list (index . 0) "defaultPodSecurityContext" "podSecurityContext") (slice . 1)) -}}
{{- end -}}

{{/*
Internal: render a map as a "securityContext:" block, or nothing if empty.
The output includes a leading newline for proper YAML formatting.

Parameters:
  - merged security context map
  - indent level (integer)
*/}}
{{- define "sourcegraph.renderSecurityContext" -}}
{{- $merged := index . 0 -}}
{{- $indent := int (index . 1) -}}
{{- if $merged }}
{{ "securityContext:" | indent $indent }}
{{ toYaml $merged | indent (int (add $indent 2)) -}}
{{- end -}}
{{- end -}}

{{/*
Container security context with 3-tier merge, rendered as a "securityContext:" block.

Usage:
  {{- include "sourcegraph.containerSecurityContext" (list . "frontend" 8) }}

Parameters:
  - $ (root context)
  - component path segments (one or more strings)
  - indent level (integer) as the last parameter
*/}}
{{- define "sourcegraph.containerSecurityContext" -}}
{{- $last := sub (len .) 1 -}}
{{- $merged := include "sourcegraph.mergedContainerSecurityContext" (slice . 0 $last) | fromYaml -}}
{{- include "sourcegraph.renderSecurityContext" (list $merged (index . $last)) -}}
{{- end -}}

{{/*
Pod security context with 3-tier merge, rendered as a "securityContext:" block.

Usage:
  {{- include "sourcegraph.podSecurityContext" (list . "frontend" 6) }}

Parameters:
  - $ (root context)
  - component path segments (one or more strings)
  - indent level (integer) as the last parameter
*/}}
{{- define "sourcegraph.podSecurityContext" -}}
{{- $last := sub (len .) 1 -}}
{{- $merged := include "sourcegraph.mergedPodSecurityContext" (slice . 0 $last) | fromYaml -}}
{{- include "sourcegraph.renderSecurityContext" (list $merged (index . $last)) -}}
{{- end -}}
