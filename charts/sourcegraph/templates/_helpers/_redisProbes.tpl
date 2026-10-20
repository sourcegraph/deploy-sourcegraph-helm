{{/*
Render the standard probes for a Redis container (redis-cache, redis-store).
Redis accepts TCP connections while loading its dataset but answers commands with
LOADING, so liveness checks the socket and readiness checks for PONG.
*/}}
{{- define "sourcegraph.redisProbes" -}}
{{- $top := index . 0 -}}
{{- $service := index $top.Values (index . 1) -}}
startupProbe:
  tcpSocket:
    port: redis
  periodSeconds: 1
  timeoutSeconds: 5
  failureThreshold: {{ include "sourcegraph.startupDeadlineSeconds" (list $top $service) }}
livenessProbe:
  tcpSocket:
    port: redis
  periodSeconds: 10
  timeoutSeconds: 5
  failureThreshold: 3
readinessProbe:
  exec:
    command:
    - /bin/sh
    - -c
    - |
      PASS_CHECK=$(grep -h "requirepass" /etc/redis/redis.conf | cut -d ' ' -f 2)
      if [ ! -z "$PASS_CHECK" ]; then
        export REDISCLI_AUTH="$PASS_CHECK"
      fi
      response=$(
        redis-cli ping
      )
      if [ "$response" != "PONG" ]; then
        echo "$response"
        exit 1
      fi
  periodSeconds: 5
  timeoutSeconds: 5
{{- end }}
