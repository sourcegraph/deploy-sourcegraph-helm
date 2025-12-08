{{/*

Expand the name of the chart

*/}}

{{- define "sourcegraph.name" }}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{ end }}



{{/*

Chart name and version, to be used in the helm.sh/chart label

*/}}

{{- define "sourcegraph.chartNameAndVersion" }}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{ end }}
