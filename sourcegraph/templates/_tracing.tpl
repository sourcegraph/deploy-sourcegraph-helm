{{/*
Define the tracing sidecar
*/}}
{{- define "sourcegraph.tracing" -}}
- name: jaeger-agent
  image: {{ include "sourcegraph.image" (list . "tracing") }}
  env:
  {{- range $name, $item := .Values.tracing.env}}
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
{{- toYaml .Values.tracing.resources | nindent 4 }}
  args:
    - --reporter.grpc.host-port=jaeger-collector:14250
    - --reporter.type=grpc
{{- end }}
