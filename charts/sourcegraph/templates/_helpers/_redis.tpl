{{/*
Set redisCache and redisStore endpoints
So that customers can configure them any of these ways:
1. Create a new Kubernetes secret, with default values (default, no override config required)
2. Use an existing Kubernetes secret, by configuring .Values.redisCache.connection.existingSecret
3. Do not create or use Kubernetes secrets, just pass the default values directly as environment variables into the needed pods, by configuring .Values.sourcegraph.disableKubernetesSecrets = true
4. Do not create or use Kubernetes secrets, but pass custom values (ex. external Redis) directly as environment variables into the needed pods, by configuring .Values.sourcegraph.disableKubernetesSecrets = true, .Values.redisCache.connection.endpoint = "", .Values.redisStore.connection.endpoint = "", and defining the REDIS_CACHE_ENDPOINT and REDIS_STORE_ENDPOINT env vars on frontend, gitserver, searcher, and worker pods
*/}}
{{- define "sourcegraph.redisConnection" -}}
{{- if .Values.sourcegraph.disableKubernetesSecrets -}}
{{- if .Values.redisCache.connection.endpoint -}}
- name: REDIS_CACHE_ENDPOINT
  value: {{ .Values.redisCache.connection.endpoint }}
{{- end -}}
{{- if .Values.redisStore.connection.endpoint -}}
- name: REDIS_STORE_ENDPOINT
  value: {{ .Values.redisStore.connection.endpoint }}
{{- end -}}
{{- else -}}
- name: REDIS_CACHE_ENDPOINT
  valueFrom:
    secretKeyRef:
      key: endpoint
      name: {{ default .Values.redisCache.name .Values.redisCache.connection.existingSecret }}
- name: REDIS_STORE_ENDPOINT
  valueFrom:
    secretKeyRef:
      key: endpoint
      name: {{ default .Values.redisStore.name .Values.redisStore.connection.existingSecret }}
{{- end -}}
{{- end -}}

{{- define "sourcegraph.redisChecksum" -}}
{{- $checksum := list .Values.redisStore.connection -}}
{{- $checksum := append $checksum .Values.redisCache.connection -}}
checksum/redis: {{ toJson $checksum | sha256sum }}
{{- end -}}
