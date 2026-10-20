{{/*
Startup deadline for a service: <service>.startupDeadlineSeconds, falling back to
sourcegraph.startupDeadlineSeconds. Startup probes run once a second, so this is also
their failureThreshold.
*/}}
{{- define "sourcegraph.startupDeadlineSeconds" -}}
{{- $top := index . 0 -}}
{{- $service := index . 1 -}}
{{- default $top.Values.sourcegraph.startupDeadlineSeconds $service.startupDeadlineSeconds -}}
{{- end }}

{{/*
Render startup, liveness, and readiness probes for a container that serves HTTP health endpoints.

Liveness and readiness stay disabled until the startup probe passes, so a slow or
resource-starved start is never killed and no probe fires before the container is up.

Parameters (dict):
  top           chart root context
  service       the service's values map, e.g. .Values.grafana
  port          container port name or number
  livenessPath  path that returns 200 whenever the process is serving
  readinessPath path that returns 200 only when the container can take traffic (optional);
                the startup probe also uses it when set
*/}}
{{- define "sourcegraph.httpProbes" -}}
startupProbe:
  httpGet:
    path: {{ default .livenessPath .readinessPath }}
    port: {{ .port }}
    scheme: HTTP
  periodSeconds: 1
  timeoutSeconds: 5
  failureThreshold: {{ include "sourcegraph.startupDeadlineSeconds" (list .top .service) }}
livenessProbe:
  httpGet:
    path: {{ .livenessPath }}
    port: {{ .port }}
    scheme: HTTP
  periodSeconds: 10
  timeoutSeconds: 5
  failureThreshold: 3
{{- if .readinessPath }}
readinessProbe:
  httpGet:
    path: {{ .readinessPath }}
    port: {{ .port }}
    scheme: HTTP
  periodSeconds: 5
  timeoutSeconds: 5
{{- end }}
{{- end }}

{{/*
Render the standard probes for a Sourcegraph service. Every service built from
sourcegraph/sourcegraph serves /healthz (200 once listening) and /ready (200 once
startup has finished) on its http-debug port.
*/}}
{{- define "sourcegraph.probes" -}}
{{- $top := index . 0 -}}
{{- $service := index $top.Values (index . 1) -}}
{{- include "sourcegraph.httpProbes" (dict "top" $top "service" $service "port" "http-debug" "livenessPath" "/healthz" "readinessPath" "/ready") -}}
{{- end }}
