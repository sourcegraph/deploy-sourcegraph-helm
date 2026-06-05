{{/*
Expand the name of the chart.
*/}}
{{- define "sourcegraph.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "sourcegraph.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "sourcegraph.labels" -}}
helm.sh/chart: {{ include "sourcegraph.chart" . }}
{{ include "sourcegraph.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- if .Values.sourcegraph.labels }}
{{ toYaml .Values.sourcegraph.labels }}
{{- end }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "sourcegraph.selectorLabels" -}}
app.kubernetes.io/name: {{ include "sourcegraph.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "sourcegraph.serviceAccountName" -}}
{{- $top := index . 0 }}
{{- $service := index . 1 }}
{{- default $service (index $top.Values $service "serviceAccount" "name") }}
{{- end }}

{{/*
Create the docker image reference and allow it to be overridden on a per-service basis
Default tags are toggled between a global and service-specific setting by the
useGlobalTagAsDefault configuration
*/}}
{{- define "sourcegraph.image" -}}
{{- $top := index . 0 }}
{{- $service := index . 1 }}
{{- $imageName := (index $top.Values $service "image" "name")}}
{{- $defaultTag := (index $top.Values $service "image" "defaultTag")}}
{{- if $top.Values.sourcegraph.image.useGlobalTagAsDefault }}{{ $defaultTag = (tpl $top.Values.sourcegraph.image.defaultTag $top) }}{{ end }}

{{- $top.Values.sourcegraph.image.repository }}/{{ $imageName }}:{{ default $defaultTag (index $top.Values $service "image" "tag") }}
{{- end }}

{{- define "sourcegraph.nodeSelector" -}}
{{- $top := index . 0 }}
{{- $service := index . 1 }}
{{- $globalNodeSelector := (index $top.Values "sourcegraph" "nodeSelector") }}
{{- $serviceNodeSelector := (index $top.Values $service "nodeSelector") }}
nodeSelector:
{{- if $serviceNodeSelector }}
{{- $serviceNodeSelector | toYaml | trim | nindent 2 }}
{{- else if $globalNodeSelector }}
{{- $globalNodeSelector | toYaml | trim | nindent 2 }}
{{- end }}
{{- end }}

{{- define "sourcegraph.affinity" -}}
{{- $top := index . 0 }}
{{- $service := index . 1 }}
{{- $globalAffinity := (index $top.Values "sourcegraph" "affinity") }}
{{- $serviceAffinity := (index $top.Values $service "affinity") }}
affinity:
{{- if $serviceAffinity }}
{{- tpl ($serviceAffinity | toYaml) $top | trim | nindent 2 }}
{{- else if $globalAffinity }}
{{- tpl ($globalAffinity | toYaml) $top | trim | nindent 2 }}
{{- end }}
{{- end }}

{{- define "sourcegraph.tolerations" -}}
{{- $top := index . 0 }}
{{- $service := index . 1 }}
{{- $globalTolerations := (index $top.Values "sourcegraph" "tolerations") }}
{{- $serviceTolerations := (index $top.Values $service "tolerations") }}
tolerations:
{{- if $serviceTolerations }}
{{- $serviceTolerations | toYaml | trim | nindent 2 }}
{{- else if $globalTolerations }}
{{- $globalTolerations | toYaml | trim | nindent 2 }}
{{- end }}
{{- end }}


{{- define "executor.name" -}}
{{- if .Values.executor.queueName -}}
executor-{{.Values.executor.queueName}}
{{- else if .Values.executor.queueNames -}}
executor-{{join "-" .Values.executor.queueNames }}
{{- end }}
{{- end }}

{{- define "executor.labels" -}}
app: {{ include "executor.name" . }}
deploy: sourcegraph
sourcegraph-resource-requires: no-cluster-admin
app.kubernetes.io/component: executor
{{- end}}

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
    {{- include "sourcegraph.labels" $r | nindent 4 }}
    {{- if $r.Values.executor.labels }}
      {{- toYaml $r.Values.executor.labels | nindent 4 }}
    {{- end }}
    app: {{ .name }}
    deploy: sourcegraph
    sourcegraph-resource-requires: no-cluster-admin
    app.kubernetes.io/component: executor
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
      {{- if $r.Values.sourcegraph.podAnnotations }}
      {{- toYaml $r.Values.sourcegraph.podAnnotations | nindent 8 }}
      {{- end }}
      {{- if $r.Values.executor.podAnnotations }}
      {{- toYaml $r.Values.executor.podAnnotations | nindent 8 }}
      {{- end }}
      labels:
      {{- include "sourcegraph.selectorLabels" $r | nindent 8 }}
      {{- if $r.Values.sourcegraph.podLabels }}
      {{- toYaml $r.Values.sourcegraph.podLabels | nindent 8 }}
      {{- end }}
      {{- if $r.Values.executor.podLabels }}
      {{- toYaml $r.Values.executor.podLabels | nindent 8 }}
      {{- end }}
        app: {{ .name }}
        deploy: sourcegraph
        sourcegraph-resource-requires: no-cluster-admin
        app.kubernetes.io/component: executor
    spec:
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
            capabilities:
              add:
                - NET_ADMIN
                - SYS_ADMIN
                - AUDIT_WRITE
                - CHOWN
                - DAC_OVERRIDE
                - FOWNER
                - FSETID
                - KILL
                - MKNOD
                - NET_BIND_SERVICE
                - NET_RAW
                - SETFCAP
                - SETGID
                - SETPCAP
                - SETUID
                - SYS_CHROOT
                - SYS_PTRACE
            {{- else }}
            privileged: true
            {{- end }}
          {{- if $r.Values.dind.gVisor.enabled }}
          command:
            - /bin/sh
            - -c
            - |
              ip link del docker0 2>/dev/null || true
              echo 1 > /proc/sys/net/ipv4/ip_forward
              dev=$(ip route show default | sed 's/.*\sdev\s\(\S*\)\s.*$/\1/')
              addr=$(ip addr show dev "$dev" | grep -w inet | sed 's/^\s*inet\s\(\S*\)\/.*$/\1/')
              iptables-legacy -t nat -A POSTROUTING -o "$dev" -j SNAT --to-source "$addr" -p tcp || true
              iptables-legacy -t nat -A POSTROUTING -o "$dev" -j SNAT --to-source "$addr" -p udp || true
              exec dockerd --tls=false --mtu=1200 --registry-mirror=http://private-docker-registry:5000 --host=tcp://127.0.0.1:2375 --storage-driver=vfs --feature containerd-snapshotter=false --iptables=false --ip6tables=false
          {{- else }}
          command:
            - dockerd
            - --tls=false
            - --mtu=1200
            - --registry-mirror=http://private-docker-registry:5000
            - --host=tcp://127.0.0.1:2375
          {{- end }}
          livenessProbe:
            tcpSocket:
              port: 2375
            initialDelaySeconds: 15
            periodSeconds: 5
            failureThreshold: 5
          readinessProbe:
            tcpSocket:
              port: 2375
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
          emptyDir: {}
        - name: docker-config
          configMap:
            defaultMode: 420
            name: docker-config
        {{- if $r.Values.dind.gVisor.enabled }}
        - name: docker
          emptyDir: {}
        {{- end }}
{{- end }}

{{/*
Validate that an env dict does not contain managed environment variable names.
Usage: include "executor.validateEnv" (list $envDict "label")
*/}}
{{- define "executor.validateEnv" -}}
{{- $envDict := index . 0 }}
{{- $label := index . 1 }}
{{- $managed := list
    "EXECUTOR_FRONTEND_URL"
    "EXECUTOR_FRONTEND_PASSWORD"
    "EXECUTOR_QUEUE_NAME"
    "EXECUTOR_QUEUE_NAMES"
    "SRC_LOG_LEVEL"
    "SRC_LOG_FORMAT"
    "EXECUTOR_MAXIMUM_NUM_JOBS"
    "EXECUTOR_MAXIMUM_RUNTIME_PER_JOB"
    "EXECUTOR_DOCKER_ADD_HOST_GATEWAY"
    "EXECUTOR_KEEP_WORKSPACES" -}}
{{- range $managed -}}
{{- if hasKey $envDict . -}}
{{- fail (printf "%s: env must not contain managed variable %s; use the structured executor fields instead" $label .) -}}
{{- end -}}
{{- end -}}
{{- end -}}
