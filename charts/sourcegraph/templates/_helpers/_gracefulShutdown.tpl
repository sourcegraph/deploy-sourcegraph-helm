{{/*
Render the standard graceful-shutdown environment variables for a service.
Service-specific values override global defaults. Explicit entries in the service's env map
take precedence so existing configurations remain valid.
*/}}
{{- define "sourcegraph.gracefulShutdownEnv" -}}
{{- $top := index . 0 -}}
{{- $serviceName := index . 1 -}}
{{- $service := index $top.Values $serviceName -}}
{{- if not (hasKey $service.env "SRC_PRE_SHUTDOWN_PAUSE") }}
- name: SRC_PRE_SHUTDOWN_PAUSE
  value: {{ default $top.Values.sourcegraph.preShutdownPause $service.preShutdownPause | quote }}
{{- end }}
{{- if not (hasKey $service.env "SRC_GRACEFUL_SHUTDOWN_TIMEOUT") }}
- name: SRC_GRACEFUL_SHUTDOWN_TIMEOUT
  value: {{ default $top.Values.sourcegraph.gracefulShutdownTimeout $service.gracefulShutdownTimeout | quote }}
{{- end }}
{{- end }}

{{/* Render the pod termination deadline for a service. */}}
{{- define "sourcegraph.terminationGracePeriodSeconds" -}}
{{- $top := index . 0 -}}
{{- $service := index $top.Values (index . 1) -}}
{{- $terminationGracePeriodSeconds := $top.Values.sourcegraph.terminationGracePeriodSeconds -}}
{{- if and (hasKey $service "terminationGracePeriodSeconds") (ne $service.terminationGracePeriodSeconds nil) -}}
{{- $terminationGracePeriodSeconds = $service.terminationGracePeriodSeconds -}}
{{- end -}}
terminationGracePeriodSeconds: {{ $terminationGracePeriodSeconds }}
{{- end }}
