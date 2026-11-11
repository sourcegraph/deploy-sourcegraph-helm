{{/*
The labels set in <serviceName>.serviceAccount.labels, rendered on the
component's ServiceAccount and on its Role, RoleBinding, ClusterRole, and
ClusterRoleBinding, if it has any. Empty by default.

Takes the same arguments as "sourcegraph.serviceAccountName".
*/}}
{{- define "sourcegraph.serviceAccountLabels" -}}
{{- $top := index . 0 }}
{{- if hasKey $top "Values" -}}
{{- $top = index $top "Values" -}}
{{- end -}}
{{- $service := index . 1 }}
{{- with (index $top $service "serviceAccount" "labels") }}
{{- toYaml . }}
{{- end }}
{{- end }}
