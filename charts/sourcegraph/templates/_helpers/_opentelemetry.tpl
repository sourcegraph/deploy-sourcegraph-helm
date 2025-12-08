{{- define "sourcegraph.openTelemetryEnv" -}}
{{- if .Values.openTelemetry.enabled -}}
# OTEL_AGENT_HOST must be defined before OTEL_EXPORTER_OTLP_ENDPOINT to substitute the node IP on which the DaemonSet pod instance runs in the latter variable
- name: OTEL_AGENT_HOST
  valueFrom:
    fieldRef:
      fieldPath: status.hostIP
- name: OTEL_EXPORTER_OTLP_ENDPOINT
  value: http://$(OTEL_AGENT_HOST):{{ toYaml .Values.openTelemetry.agent.hostPorts.grpcOtlp }}
{{- end }}
{{- end }}
