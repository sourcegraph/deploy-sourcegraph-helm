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
{{- $defaultTagPrefix := (index $top.Values $service "image" "defaultTagPrefix")}}
{{- if $top.Values.sourcegraph.image.useGlobalTagAsDefault }}{{ $defaultTag = (tpl $top.Values.sourcegraph.image.defaultTag $top) }}{{ end }}

{{- $top.Values.sourcegraph.image.repository }}/{{ $imageName }}:{{ $defaultTagPrefix }}{{ default $defaultTag (index $top.Values $service "image" "tag") }}
{{- end }}
