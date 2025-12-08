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
