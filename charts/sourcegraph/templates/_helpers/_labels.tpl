{{/*
An object's labels, with each key rendered once: the common labels, then each
map passed after the root context, in order. A later map wins when a key is set
more than once, so pass the component's own labels after sourcegraph.labels, and
the labels the chart sets itself last. Kustomize and kubeconform reject a key
that is rendered twice.

{{ include "sourcegraph.mergedLabels" (list . .Values.blobstore.storageLabels (dict "deploy" "sourcegraph")) }}
*/}}
{{- define "sourcegraph.mergedLabels" -}}
{{- $labels := include "sourcegraph.labels" (first .) | fromYaml -}}
{{- range rest . -}}
{{- range $key, $value := . -}}
{{- $_ := set $labels $key $value -}}
{{- end -}}
{{- end -}}
{{- toYaml $labels -}}
{{- end }}

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
