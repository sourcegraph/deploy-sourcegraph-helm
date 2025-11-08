{{- define "sourcegraph.worker" -}}
{{- $top := index . 0 }}
{{- $suffix := index . 1 -}}
{{- $allowlist := index . 2 -}}
{{- $blocklist := index . 3 -}}
{{- $resources := index . 4 -}}

{{- $name := $top.Values.worker.name -}}
{{- if $suffix -}}
{{- $name = printf "%s-%s" $name $suffix -}}
{{- end -}}
apiVersion: apps/v1
kind: Deployment
metadata:
  annotations:
    description: Manages background processes.
  labels:
    {{- include "sourcegraph.labels" $top | nindent 4 }}
    {{- if $top.Values.worker.labels }}
      {{- toYaml $top.Values.worker.labels | nindent 4 }}
    {{- end }}
    deploy: sourcegraph
    app.kubernetes.io/component: worker
  name: {{ $name }}
spec:
  minReadySeconds: 10
  replicas: {{ $top.Values.worker.replicaCount }}
  revisionHistoryLimit: {{ $top.Values.sourcegraph.revisionHistoryLimit }}
  selector:
    matchLabels:
      {{- include "sourcegraph.selectorLabels" $top | nindent 6 }}
      app: worker
      {{- if $suffix }}
      worker-replica: {{ $name | quote }}
      {{- end }}
  strategy:
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 1
    type: RollingUpdate
  template:
    metadata:
      annotations:
        kubectl.kubernetes.io/default-container: worker
      {{- include "sourcegraph.redisChecksum" $top | nindent 8 }}
      {{- if $top.Values.sourcegraph.podAnnotations }}
      {{- toYaml $top.Values.sourcegraph.podAnnotations | nindent 8 }}
      {{- end }}
      {{- if $top.Values.worker.podAnnotations }}
      {{- toYaml $top.Values.worker.podAnnotations | nindent 8 }}
      {{- end }}
      labels:
      {{- include "sourcegraph.selectorLabels" $top | nindent 8 }}
      {{- if $top.Values.sourcegraph.podLabels }}
      {{- toYaml $top.Values.sourcegraph.podLabels | nindent 8 }}
      {{- end }}
      {{- if $top.Values.worker.podLabels }}
      {{- toYaml $top.Values.worker.podLabels | nindent 8 }}
      {{- end }}
        deploy: sourcegraph
        app: worker
        {{- if $suffix }}
        worker-replica: {{ $name | quote }}
        {{- end }}
    spec:
      containers:
      - name: worker
        env:
        {{- include "sourcegraph.redisConnection" $top | nindent 8 }}
        {{- if $allowlist }}
        - name: WORKER_JOB_ALLOWLIST
          value: {{ $allowlist }}
        {{- end }}
        {{- if $blocklist }}
        - name: WORKER_JOB_BLOCKLIST
          value: {{ $blocklist }}
        {{- end }}
        {{- range $name, $item := $top.Values.worker.env}}
        - name: {{ $name }}
          {{- $item | toYaml | nindent 10 }}
        {{- end }}
        {{- if $top.Values.blobstore.enabled }}
        - name: PRECISE_CODE_INTEL_UPLOAD_BACKEND
          value: blobstore
        - name: PRECISE_CODE_INTEL_UPLOAD_AWS_ENDPOINT
          value: http://blobstore:9000
        {{- end }}
        - name: POD_NAME
          valueFrom:
            fieldRef:
              fieldPath: metadata.name
        {{- include "sourcegraph.openTelemetryEnv" $top | nindent 8 }}
        image: {{ include "sourcegraph.image" (list $top "worker" ) }}
        imagePullPolicy: {{ $top.Values.sourcegraph.image.pullPolicy }}
        {{- with $top.Values.worker.args }}
        args:
          {{- toYaml . | nindent 8 }}
        {{- end }}
        terminationMessagePolicy: FallbackToLogsOnError
        livenessProbe:
          httpGet:
            path: /healthz
            port: http-debug
            scheme: HTTP
          initialDelaySeconds: 60
          timeoutSeconds: 5
        readinessProbe:
          httpGet:
            path: /ready
            port: http-debug
            scheme: HTTP
          periodSeconds: 5
          timeoutSeconds: 5
        ports:
        - name: http
          containerPort: 3189
        - name: http-debug
          containerPort: 6060
        - name: http-debug-exec
          containerPort: 6996
        {{- if not $top.Values.sourcegraph.localDevMode }}
        resources:
          {{- toYaml $resources | nindent 10 }}
        {{- end }}
        securityContext:
          {{- toYaml $top.Values.worker.containerSecurityContext | nindent 10 }}
        volumeMounts:
        {{- if $top.Values.worker.extraVolumeMounts }}
        {{- toYaml $top.Values.worker.extraVolumeMounts | nindent 8 }}
        {{- end }}
      {{- if $top.Values.worker.extraContainers }}
        {{- toYaml $top.Values.worker.extraContainers | nindent 6 }}
      {{- end }}
      securityContext:
        {{- toYaml $top.Values.worker.podSecurityContext | nindent 8 }}
      {{- include "sourcegraph.nodeSelector" (list $top "worker" ) | trim | nindent 6 }}
      {{- include "sourcegraph.affinity" (list $top "worker" ) | trim | nindent 6 }}
      {{- include "sourcegraph.tolerations" (list $top "worker" ) | trim | nindent 6 }}
      {{- with $top.Values.sourcegraph.imagePullSecrets }}
      imagePullSecrets:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- include "sourcegraph.renderServiceAccountName" (list $top "worker") | trim | nindent 6 }}
      volumes:
      {{- if $top.Values.worker.extraVolumes }}
      {{- toYaml $top.Values.worker.extraVolumes | nindent 6 }}
      {{- end }}
{{- end -}}
