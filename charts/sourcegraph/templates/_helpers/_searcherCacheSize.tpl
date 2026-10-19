{{/*
45% of searcher.storageSize in whole (decimal) megabytes, for
SEARCHER_CACHE_SIZE_MB and SYMBOLS_CACHE_SIZE_MB. Mirrors the arithmetic
searcher uses when it auto-sizes from the volume: floor(bytes / 1e6) * 45 / 100.
Accepts any Kubernetes quantity (e.g. 150G, 100Gi, 1.5Ti, 500000M).

Anything unparseable, or anything so small the result would be 0, fails the
render: searcher treats an explicit 0 as "never evict" (unlike an unset
variable, which auto-sizes), so the cache volume would fill up.
*/}}
{{- define "sourcegraph.searcher.cacheSizeMB" -}}
{{- $size := .Values.searcher.storageSize | default "26Gi" | toString -}}
{{- $bytes := include "sourcegraph.quantityBytes" $size -}}
{{- if not $bytes -}}
{{- fail (printf "searcher.storageSize must be a Kubernetes quantity such as 150G, 100Gi or 1Ti (got %q), or set searcher.autoCacheSize=true" $size) -}}
{{- end -}}
{{- $megabytes := div (mul (div (int64 $bytes) 1000000) 45) 100 -}}
{{- if le $megabytes 0 -}}
{{- fail (printf "searcher.storageSize %s is too small to derive a non-zero cache size; use at least 3M, or set searcher.autoCacheSize=true" $size) -}}
{{- end -}}
{{- $megabytes -}}
{{- end -}}
