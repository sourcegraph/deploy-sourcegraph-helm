{{- define "sourcegraph.databaseAuth" -}}
{{- $top := index . 0 -}}
{{- $service := index . 1 -}}
{{- $prefix := index . 2 -}}
{{- $secretName := (index $top.Values $service "name") -}}
{{- $secretName := printf "%s-auth" $secretName -}}
{{- if (index $top.Values $service "auth" "existingSecret") }}{{- $secretName = (index $top.Values $service "auth" "existingSecret") }}{{- end -}}
- name: {{ printf "%sDATABASE" $prefix }}
  valueFrom:
    secretKeyRef:
      key: database
      name: {{ $secretName }}
- name: {{ printf "%sHOST" $prefix }}
  valueFrom:
    secretKeyRef:
      key: host
      name: {{ $secretName }}
- name: {{ printf "%sPASSWORD" $prefix }}
  valueFrom:
    secretKeyRef:
      key: password
      name: {{ $secretName }}
- name: {{ printf "%sPORT" $prefix }}
  valueFrom:
    secretKeyRef:
      key: port
      name: {{ $secretName }}
- name: {{ printf "%sUSER" $prefix }}
  valueFrom:
    secretKeyRef:
      key: user
      name: {{ $secretName }}
- name: {{ printf "%sSSLMODE" $prefix }}
  valueFrom:
    secretKeyRef:
      key: sslmode
      name: {{ $secretName }}
{{- end }}


{{- define "sourcegraph.dataSource" -}}
{{- $top := index . 0 -}}
{{- $service := index . 1 -}}
{{- $secretName := (index $top.Values $service "name") -}}
{{- $secretName := printf "%s-auth" $secretName -}}
{{- if (index $top.Values $service "auth" "existingSecret") }}{{- $secretName = (index $top.Values $service "auth" "existingSecret") }}{{- end -}}
- name: DATA_SOURCE_DB
  valueFrom:
    secretKeyRef:
      key: database
      name: {{ $secretName }}
- name: DATA_SOURCE_PASS
  valueFrom:
    secretKeyRef:
      key: password
      name: {{ $secretName }}
- name: DATA_SOURCE_PORT
  valueFrom:
    secretKeyRef:
      key: port
      name: {{ $secretName }}
- name: DATA_SOURCE_USER
  valueFrom:
    secretKeyRef:
      key: user
      name: {{ $secretName }}
- name: DATA_SOURCE_URI
  value: "localhost:$(DATA_SOURCE_PORT)/$(DATA_SOURCE_DB)?sslmode=disable"
{{- end }}


{{- define "sourcegraph.authChecksum" -}}
{{- $checksum := list .Values.codeInsightsDB.auth -}}
{{- $checksum = append $checksum .Values.codeIntelDB.auth -}}
{{- $checksum = append $checksum .Values.pgsql.auth -}}
checksum/auth: {{ toJson $checksum | sha256sum }}
{{- end -}}
