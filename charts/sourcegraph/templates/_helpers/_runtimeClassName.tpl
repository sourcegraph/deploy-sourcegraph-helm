{{/*

Allow customers to assign a runtimeClassName to all resources which create pods (ex. DaemonSets, Deployments, StatefulSets)

Customers can configure an instance-wide default runtime class name at .Values.sourcegraph.runtimeClassName,
and can override it for individual services, if needed, at .Values.<service>.runtimeClassName

Unlike priorityClassName, an empty .Values.<service>.runtimeClassName also overrides the instance-wide default,
so pods which a sandboxed runtime cannot run (ex. hostPID or privileged) can keep the cluster's default runtime

*/}}

{{- define "sourcegraph.runtimeClassName" -}}
{{- $top := index . 0 }}
{{- $service := index . 1 }}
{{- $serviceValues := index $top.Values $service | default dict }}
{{- $runtimeClassName := index $top.Values "sourcegraph" "runtimeClassName" }}
{{- if hasKey $serviceValues "runtimeClassName" }}
{{- $runtimeClassName = index $serviceValues "runtimeClassName" }}
{{- end }}
{{- with $runtimeClassName }}
runtimeClassName: {{ . | toYaml | trim }}
{{- end }}
{{- end }}
