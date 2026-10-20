{{/*
Render the standard probes for a Sourcegraph PostgreSQL container (pgsql, codeintel-db,
codeinsights-db). The images ship /liveness.sh, which passes while Postgres is re-indexing
after a major-version upgrade, and /ready.sh, which runs a query over TCP.
The startup deadline is long because crash recovery and upgrades can take a while.
*/}}
{{- define "sourcegraph.postgresProbes" -}}
{{- $top := index . 0 -}}
{{- $service := index $top.Values (index . 1) -}}
startupProbe:
  exec:
    command:
      - /liveness.sh
  periodSeconds: 1
  timeoutSeconds: 5
  failureThreshold: {{ include "sourcegraph.startupDeadlineSeconds" (list $top $service) }}
livenessProbe:
  exec:
    command:
      - /liveness.sh
  periodSeconds: 10
  timeoutSeconds: 5
  failureThreshold: 3
readinessProbe:
  exec:
    command:
      - /ready.sh
  periodSeconds: 5
  timeoutSeconds: 5
{{- end }}
