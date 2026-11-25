#!/bin/bash

# Render each chart with every tests/kustomizeRender_*.yaml values file, then
# run the output through kustomize. Kustomize rejects YAML that Helm accepts,
# such as a label key repeated in one map, which breaks anyone who runs
# kustomize over the chart, including Sourcegraph Cloud.

set -eu -o pipefail

work_directory=$(mktemp -d)
trap 'rm -rf "${work_directory}"' EXIT
printf 'resources:\n- rendered.yaml\n' >"${work_directory}/kustomization.yaml"

failed=()
for values_file in charts/*/tests/kustomizeRender_*.yaml charts/*/*/tests/kustomizeRender_*.yaml; do
  chart_directory="${values_file%/tests/*}"
  echo "--- ${values_file}"
  if ! helm template test "${chart_directory}" --values "${values_file}" >"${work_directory}/rendered.yaml" ||
    ! kubectl kustomize "${work_directory}" >/dev/null; then
    failed+=("${values_file}")
  fi
done

if [ "${#failed[@]}" -ne 0 ]; then
  printf "\nkustomize could not build the chart rendered with:\n" >&2
  printf "  %s\n" "${failed[@]}" >&2
  exit 1
fi
