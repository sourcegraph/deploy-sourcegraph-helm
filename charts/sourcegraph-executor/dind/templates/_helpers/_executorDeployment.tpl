{{/*
Render a single executor Deployment.
Usage: include "executor.deployment" (dict "root" $ "name" "executor-foo" "queueName" "foo" "queueNames" (list) "replicaCount" 1 "resources" $res "env" $env)
*/}}
{{- define "executor.deployment" -}}
{{- $r := .root -}}
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .name }}
  annotations:
    description: Runs sourcegraph executors
    kubectl.kubernetes.io/default-container: executor
  labels:
    {{- include "sourcegraph.mergedLabels" (list $r $r.Values.executor.labels (dict "app" .name "deploy" "sourcegraph" "sourcegraph-resource-requires" "no-cluster-admin" "app.kubernetes.io/component" "executor")) | nindent 4 }}
spec:
  selector:
    matchLabels:
      {{- include "sourcegraph.selectorLabels" $r | nindent 6 }}
      app: {{ .name }}
  minReadySeconds: 10
  replicas: {{ .replicaCount }}
  revisionHistoryLimit: 10
  strategy:
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 1
    type: RollingUpdate
  template:
    metadata:
      annotations:
        kubectl.kubernetes.io/default-container: executor
        checksum/docker-config: {{ include "dind.daemonConfig" $r | sha256sum }}
      {{- if $r.Values.sourcegraph.podAnnotations }}
      {{- toYaml $r.Values.sourcegraph.podAnnotations | nindent 8 }}
      {{- end }}
      {{- if $r.Values.executor.podAnnotations }}
      {{- toYaml $r.Values.executor.podAnnotations | nindent 8 }}
      {{- end }}
      labels:
        {{- include "sourcegraph.podLabels" (list $r $r.Values.executor (dict "app" .name "deploy" "sourcegraph" "sourcegraph-resource-requires" "no-cluster-admin" "app.kubernetes.io/component" "executor")) | nindent 8 }}
    spec:
      {{- with $r.Values.executor.podSecurityContext }}
      securityContext:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      containers:
        - name: executor
          image: {{ include "sourcegraph.image" (list $r "executor") }}
          imagePullPolicy: {{ $r.Values.sourcegraph.image.pullPolicy }}
          livenessProbe:
            httpGet:
              path: /healthz
              port: http-debug
              scheme: HTTP
            initialDelaySeconds: 60
            timeoutSeconds: 5
          readinessProbe:
            httpGet:
              path: /healthz
              port: http-debug
              scheme: HTTP
            periodSeconds: 5
            timeoutSeconds: 5
          ports:
            - name: http-debug
              containerPort: 8080
          terminationMessagePolicy: FallbackToLogsOnError
          env:
            - name: EXECUTOR_FRONTEND_URL
              value: {{ $r.Values.executor.frontendUrl | quote }}
            - name: EXECUTOR_FRONTEND_PASSWORD
              {{- if $r.Values.executor.frontendExistingSecret }}
              valueFrom:
                secretKeyRef:
                  name: {{ $r.Values.executor.frontendExistingSecret }}
                  key: EXECUTOR_FRONTEND_PASSWORD
              {{- else }}
              value: {{ $r.Values.executor.frontendPassword | quote }}
              {{- end }}
            {{- if .queueNames }}
            - name: EXECUTOR_QUEUE_NAMES
              value: {{ join "," .queueNames | quote }}
            {{- else }}
            - name: EXECUTOR_QUEUE_NAME
              value: {{ .queueName | quote }}
            {{- end }}
            - name: SRC_LOG_LEVEL
              value: {{ $r.Values.executor.log.level | quote }}
            - name: SRC_LOG_FORMAT
              value: {{ $r.Values.executor.log.format | quote }}
            - name: EXECUTOR_MAXIMUM_RUNTIME_PER_JOB
              value: {{ $r.Values.executor.maximumRuntimePerJob | quote }}
            - name: EXECUTOR_USE_FIRECRACKER
              value: "false"
            - name: EXECUTOR_USE_KUBERNETES
              value: "false"
            - name: EXECUTOR_HEALTH_SERVER_ADDR
              value: ":8080"
            - name: EXECUTOR_JOB_NUM_CPUS
              value: "0"
            - name: EXECUTOR_JOB_MEMORY
              value: "0"
            - name: DOCKER_HOST
              value: tcp://localhost:2375
            - name: TMPDIR
              value: /scratch
            {{- range $name, $item := .env }}
            - name: {{ $name }}
              {{- $item | toYaml | nindent 14 }}
            {{- end }}
          volumeMounts:
            - mountPath: /scratch
              name: executor-scratch
          {{- with .resources }}
          resources:
            {{- toYaml . | nindent 12 }}
          {{- end }}
        - name: dind
          image: "{{ $r.Values.dind.image.registry }}/{{ $r.Values.dind.image.repository }}:{{ $r.Values.dind.image.tag }}"
          imagePullPolicy: {{ $r.Values.sourcegraph.image.pullPolicy }}
          securityContext:
            {{- if $r.Values.dind.gVisor.enabled }}
            {{- toYaml $r.Values.dind.gVisor.securityContext | nindent 12 }}
            {{- else }}
            privileged: true
            {{- end }}
          command:
            {{- if $r.Values.dind.gVisor.enabled }}
            {{- toYaml $r.Values.dind.gVisor.command | nindent 12 }}
            {{- else }}
            {{- toYaml $r.Values.dind.command | nindent 12 }}
            {{- end }}
          livenessProbe:
            exec:
              command:
                - wget
                - -qO-
                - http://127.0.0.1:2375/_ping
            initialDelaySeconds: 15
            periodSeconds: 5
            failureThreshold: 5
          readinessProbe:
            exec:
              command:
                - wget
                - -qO-
                - http://127.0.0.1:2375/_ping
            initialDelaySeconds: 20
            periodSeconds: 5
            failureThreshold: 5
          env:
            - name: POD_NAME
              valueFrom:
                fieldRef:
                  apiVersion: v1
                  fieldPath: metadata.name
          ports:
            - containerPort: 2375
              protocol: TCP
          volumeMounts:
            - mountPath: /scratch
              name: executor-scratch
            - mountPath: /etc/docker/daemon.json
              subPath: daemon.json
              name: docker-config
            {{- if $r.Values.dind.gVisor.enabled }}
            - mountPath: /var/lib/docker
              name: docker
            {{- end }}
      enableServiceLinks: false
      {{- if $r.Values.dind.gVisor.enabled }}
      runtimeClassName: gvisor
      {{- end }}
      {{- with $r.Values.sourcegraph.nodeSelector }}
      nodeSelector:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with $r.Values.sourcegraph.affinity }}
      affinity:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with include "sourcegraph.priorityClassName" (list $r "executor") | trim }}{{ . | nindent 6 }}{{- end }}
      {{- with $r.Values.sourcegraph.tolerations }}
      tolerations:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with $r.Values.sourcegraph.imagePullSecrets }}
      imagePullSecrets:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      volumes:
        - name: executor-scratch
          {{- if eq $r.Values.executor.storage.type "ephemeral" }}
          ephemeral:
            volumeClaimTemplate:
              metadata:
                labels:
                  {{- include "sourcegraph.mergedLabels" (list $r $r.Values.executor.storage.labels (dict "deploy" "sourcegraph" "app.kubernetes.io/component" "executor")) | nindent 18 }}
              spec:
                accessModes: ["ReadWriteOnce"]
                {{- if $r.Values.executor.storage.class }}
                storageClassName: {{ $r.Values.executor.storage.class }}
                {{- end }}
                resources:
                  requests:
                    storage: {{ required "executor.storage.size is required when storage.type is ephemeral" $r.Values.executor.storage.size }}
          {{- else }}
          emptyDir:
            {{- if $r.Values.executor.storage.size }}
            sizeLimit: {{ $r.Values.executor.storage.size }}
            {{- end }}
          {{- end }}
        - name: docker-config
          configMap:
            defaultMode: 420
            name: docker-config
        {{- if $r.Values.dind.gVisor.enabled }}
        - name: docker
          emptyDir: {}
        {{- end }}
{{- end }}
