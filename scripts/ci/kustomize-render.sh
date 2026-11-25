#!/bin/bash

# Render each chart with every tests/kustomizeRender_*.yaml values file, then
# check the output three ways:
# - kubeconform validates it against the Kubernetes schemas, which catches
#   templates that render a value in the wrong place or with the wrong type
# - grep finds Go template output that never belongs in a manifest, such as a
#   map or list printed where a string was expected
# - kustomize builds it, which rejects YAML that Helm accepts, such as a label
#   key repeated in one map, and breaks anyone who runs kustomize over the
#   chart, including Sourcegraph Cloud

set -eu -o pipefail

work_directory=$(mktemp -d)
trap 'rm -rf "${work_directory}"' EXIT
rendered="${work_directory}/rendered.yaml"
printf 'resources:\n- rendered.yaml\n' >"${work_directory}/kustomization.yaml"

failed=()
for values_file in charts/*/tests/kustomizeRender_*.yaml charts/*/*/tests/kustomizeRender_*.yaml; do
  chart_directory="${values_file%/tests/*}"
  echo "--- ${values_file}"
  if ! helm template test "${chart_directory}" --values "${values_file}" >"${rendered}"; then
    failed+=("${values_file}: helm template")
    continue
  fi
  if ! kubeconform -strict -summary -ignore-missing-schemas "${rendered}"; then
    failed+=("${values_file}: kubeconform")
  fi
  if grep -nE 'map\[|%!|<no value>' "${rendered}"; then
    failed+=("${values_file}: Go template output in the manifests")
  fi
  if ! kubectl kustomize "${work_directory}" >/dev/null; then
    failed+=("${values_file}: kustomize")
  fi
done

if [ "${#failed[@]}" -ne 0 ]; then
  printf "\nThese checks failed:\n" >&2
  printf "  %s\n" "${failed[@]}" >&2
  exit 1
fi
