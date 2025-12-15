{{/*

Allow customers to assign a priorityClassName to all resources which create pods (ex. DaemonSets, Deployments, StatefulSets)

Customers can configure an instance-wide default priorty class name at .Values.sourcegraph.priorityClassName,
and can override it for individual services, if needed, at .Values.<service>.priorityClassName

*/}}

{{- define "sourcegraph.priorityClassName" -}}
{{- $top := index . 0 }}
{{- $service := index . 1 }}
{{- $globalPriorityClassName := (index $top.Values "sourcegraph" "priorityClassName") }}
{{- $servicePriorityClassName := (index $top.Values $service "priorityClassName") }}
{{- if $servicePriorityClassName }}
priorityClassName: {{- $servicePriorityClassName | toYaml | trim }}
{{- else if $globalPriorityClassName }}
priorityClassName: {{- $globalPriorityClassName | toYaml | trim }}
{{- end }}
{{- end }}
