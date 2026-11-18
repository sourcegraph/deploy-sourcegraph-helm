{{/*
The `service.telemetry.metrics.readers` setting of `otel-collector`, as a YAML
flow sequence. It serves the collector's own metrics on all interfaces, port
8888, where Prometheus scrapes them. The collector defaults to 127.0.0.1, which
other pods cannot reach. Without the type and unit suffixes the metric names are
the ones the bundled dashboard queries, e.g. `otelcol_receiver_accepted_spans`.

The image's `jaeger.yaml` already has this setting. Its `logging.yaml` does not.
*/}}
{{- define "sourcegraph.otelCollector.metricsReaders" -}}
[{pull: {exporter: {prometheus: {host: "0.0.0.0", port: 8888, without_type_suffix: true, without_units: true}}}}]
{{- end }}
