{{/*

Render label or annotation maps as one map, with each key once.

Strict YAML parsers, such as Kustomize, reject a map that repeats a key. Helm
and Kubernetes accept it and keep the last value. This keeps the last value
too, so the objects of an installed release do not change.

Pass a list of maps, lowest precedence first. Each item is a map from the
values, or the text of one or more `key: value` lines. The lines are passed
through as written, so when no key repeats, the output is the same text as
rendering the items one after the other.

labels:
  {{- include "sourcegraph.uniqueKeys" (list
    (include "sourcegraph.labels" .)
    .Values.sourcegraph.podLabels
    "deploy: sourcegraph"
  ) | nindent 2 }}

*/}}

{{- define "sourcegraph.uniqueKeys" -}}
{{- /* Split every item into entries: one `key: value`, with any lines of a multi-line value. */ -}}
{{- $entries := list -}}
{{- range $source := . -}}
  {{- $text := "" -}}
  {{- if and $source (kindIs "map" $source) -}}
    {{- $text = toYaml $source -}}
  {{- else if kindIs "string" $source -}}
    {{- $text = trim $source -}}
  {{- end -}}
  {{- if $text -}}
    {{- range $line := splitList "\n" $text -}}
      {{- if and $entries (or (not $line) (hasPrefix " " $line)) -}}
        {{- $entries = append (initial $entries) (printf "%s\n%s" (last $entries) $line) -}}
      {{- else -}}
        {{- $entries = append $entries $line -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}
{{- end -}}
{{- /* Keep the last entry of each key. */ -}}
{{- $seen := dict -}}
{{- $unique := list -}}
{{- range $entry := reverse $entries -}}
  {{- $key := splitList ":" $entry | first | trimAll "\"'" -}}
  {{- if not (hasKey $seen $key) -}}
    {{- $_ := set $seen $key true -}}
    {{- $unique = prepend $unique $entry -}}
  {{- end -}}
{{- end -}}
{{- join "\n" $unique -}}
{{- end -}}
