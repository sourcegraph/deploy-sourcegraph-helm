{{/*

One-stop-shop for labels and selectorLabels,
to keep templates DRY and readable,
and to ensure labels are correctly applied everywhere

In our values.yaml, the customer can add labels at any of the below locations in their override.yaml.
The sourcegraph.labels template function handles these cases, in this order,
to ensure that more specific labels override less specific labels.

.Values.sourcegraph.labels
.Values.sourcegraph.podLabels
.Values.sourcegraph.serviceLabels

.Values.<any>.labels
.Values.<pods>.podLabels
.Values.<services>.serviceLabels


Usage example for Blobstore:

apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    {{- include "sourcegraph.labels" (dict "ctx" . "valuesKey" "blobstore" "kind" "deployment") | nindent 4 }}
spec:
  selector:
    matchLabels:
      {{- include "sourcegraph.selectorLabels" (dict "ctx" . "valuesKey" "blobstore") | nindent 6 }}
  template:
    metadata:
      labels:
        {{- include "sourcegraph.labels" (dict "ctx" . "valuesKey" "blobstore" "kind" "deployment") | nindent 8 }}

Usage with componentLabel override (when app.kubernetes.io/component differs from valuesKey):

  labels:
    {{- include "sourcegraph.labels" (dict "ctx" . "valuesKey" "codeInsightsDB" "kind" "configmap" "componentLabel" "codeinsights-db") | nindent 4 }}

Usage with appLabel override (when app label differs from componentLabel):

  labels:
    {{- include "sourcegraph.labels" (dict "ctx" . "valuesKey" "pgsql" "kind" "statefulset" "componentLabel" "pgsql" "appLabel" "postgres") | nindent 4 }}

*/}}



{{/*

Labels

Includes sourcegraph.selectorLabels to keep function DRY,
and to ensure sourcegraph.selectorLabels is a subset of sourcegraph.labels

*/}}

{{- define "sourcegraph.labels" -}}
{{- $ctx := .ctx -}}
{{- $valuesKey := .valuesKey -}}
{{- $kind := .kind | default "" | lower -}}
{{- $componentLabel := .componentLabel | default $valuesKey -}}
{{- $appLabel := .appLabel | default $componentLabel -}}
{{- $componentValues := index $ctx.Values $valuesKey -}}
{{- include "sourcegraph.selectorLabels" (dict "ctx" $ctx "valuesKey" $valuesKey "componentLabel" $componentLabel) }}
app: {{ $appLabel }}
app.kubernetes.io/part-of: sourcegraph
{{- if $ctx.Chart.AppVersion }}
app.kubernetes.io/version: {{ $ctx.Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ $ctx.Release.Service }}
deploy: sourcegraph
helm.sh/chart: {{ include "sourcegraph.chartNameAndVersion" $ctx }}
{{- $labels := merge ($componentValues.labels | default dict) ($ctx.Values.sourcegraph.labels | default dict) -}}
{{- if $labels }}
{{ toYaml $labels }}
{{- end }}
{{- if has $kind (list "cronjob" "daemonset" "ds" "deployment" "job" "pod" "replicaset" "rs" "statefulset" "sts" ) }}
{{- $podLabels := merge ($componentValues.podLabels | default dict) ($ctx.Values.sourcegraph.podLabels | default dict) -}}
{{- if $podLabels }}
{{ toYaml $podLabels }}
{{- end }}
{{- else if has $kind (list "service" "svc" ) }}
{{- $serviceLabels := merge ($componentValues.serviceLabels | default dict) ($ctx.Values.sourcegraph.serviceLabels | default dict) -}}
{{- if $serviceLabels }}
{{ toYaml $serviceLabels }}
{{- end }}
{{- else if has $kind (list "clusterrole" "clusterrolebinding" "role" "rolebinding" "serviceaccount" "sa") }}
category: rbac
{{- end }}
{{- end -}}



{{/*

Selector labels

- Used by Services, Deployments, and StatefulSets to find their respective pods, via spec.selector.matchLabels
- spec.selector.matchLabels is a subset of the spec.template.metadata.labels applied to pods
- Doesn't use all common labels, because selector labels are immutable

Usage examples:

In a Deployment's spec.selector.matchLabels:

spec:
  selector:
    matchLabels:
      {{- include "sourcegraph.selectorLabels" (dict "ctx" . "valuesKey" "blobstore") | nindent 6 }}

In a Service's spec.selector:

spec:
  selector:
    {{- include "sourcegraph.selectorLabels" (dict "ctx" . "valuesKey" "blobstore") | nindent 4 }}

With componentLabel override:

spec:
  selector:
    matchLabels:
      {{- include "sourcegraph.selectorLabels" (dict "ctx" . "valuesKey" "codeInsightsDB" "componentLabel" "codeinsights-db") | nindent 6 }}

spec:
  selector:
    {{- include "sourcegraph.selectorLabels" (dict "ctx" . "valuesKey" "codeInsightsDB" "componentLabel" "codeinsights-db") | nindent 4 }}

*/}}

{{- define "sourcegraph.selectorLabels" -}}
{{- $ctx := .ctx -}}
{{- $valuesKey := .valuesKey -}}
{{- $componentLabel := .componentLabel | default $valuesKey -}}
app.kubernetes.io/name: {{ include "sourcegraph.name" $ctx }}
app.kubernetes.io/instance: {{ $ctx.Release.Name }}
app.kubernetes.io/component: {{ $componentLabel }}
{{- end }}
