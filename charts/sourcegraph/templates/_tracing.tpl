{{/*
Define the tracing sidecar
*/}}
{{- define "sourcegraph.tracing" -}}
{{- if .Values.tracingAgent.enabled -}}
- name: jaeger-agent
  image: {{ include "sourcegraph.image" (list . "tracingAgent") }}
  env:
  {{- range $name, $item := .Values.tracingAgent.env}}
    - name: {{ $name }}
    {{- $item | toYaml | nindent 4 }}
  {{- end }}
    - name: POD_NAME
      valueFrom:
        fieldRef:
          apiVersion: v1
          fieldPath: metadata.name
  ports:
  - containerPort: 5775
    protocol: UDP
  - containerPort: 5778
    protocol: TCP
  - containerPort: 6831
    protocol: UDP
  - containerPort: 6832
    protocol: UDP
  resources:
{{- toYaml .Values.tracingAgent.resources | nindent 4 }}
  args:
    - --reporter.grpc.host-port={{ default "jaeger-collector" .Values.tracing.collector.name }}:14250
    - --reporter.type=grpc
{{- end }}
  securityContext:
    {{- toYaml .Values.tracingAgent.podSecurityContext | nindent 4 }}
{{- end }}
