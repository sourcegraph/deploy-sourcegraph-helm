{{/*
~45% of searcher.storageSize in megabytes, for SEARCHER_CACHE_SIZE_MB and
SYMBOLS_CACHE_SIZE_MB. Accepts a whole number of M, Mi, G or Gi (e.g. 150G,
100Gi, 500000M). Any other value fails the render: a non-numeric value would
otherwise cast to 0, which searcher treats as "never evict" and the cache
volume fills up. Binary units are treated as decimal, matching the original
"Gi * 450" math, so the result is slightly under 45% of the volume.
*/}}
{{- define "sourcegraph.searcher.cacheSizeMB" -}}
{{- $size := .Values.searcher.storageSize | default "26Gi" | toString }}
{{- if not (regexMatch "^[0-9]+(M|Mi|G|Gi)$" $size) }}
{{- fail (printf "searcher.storageSize must be a whole number of M, Mi, G or Gi (got %q), or set searcher.autoCacheSize=true" $size) }}
{{- end }}
{{- $decimal := trimSuffix "i" $size }}
{{- $megabytes := $decimal | trimSuffix "G" | trimSuffix "M" | int64 }}
{{- if hasSuffix "G" $decimal }}
{{- $megabytes = mul $megabytes 1000 }}
{{- end }}
{{- div (mul $megabytes 45) 100 }}
{{- end }}
