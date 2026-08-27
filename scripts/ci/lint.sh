#!/bin/bash

set -euf -o pipefail

### Run the helm tests
function lint_chart() {
  local chart_path="$1"
  local lint_output
  local lint_status

  shift

  echo "Linting chart ${chart_path}"
  if lint_output=$(helm lint "${chart_path}" "$@" 2>&1); then
    lint_status=0
  else
    lint_status=$?
  fi

  printf "\n\n===== Lint Output: %s =====\n%s\n" "${chart_path}" "${lint_output}"

  if grep -qi "warning" <<<"${lint_output}"; then
    printf "Helm lint emitted warnings for %s\n" "${chart_path}" >&2
    return 255
  fi

  return "${lint_status}"
}

function lint_and_record() {
  local chart_status

  if lint_chart "$@"; then
    return 0
  else
    chart_status=$?
  fi

  if [ "${exit_status}" -eq 0 ]; then
    exit_status="${chart_status}"
  fi

  return 0
}

exit_status=0
lint_and_record "charts/sourcegraph"
lint_and_record "charts/sourcegraph-migrator"
lint_and_record "charts/sourcegraph-executor/k8s" --set "executor.queueName=batches"
lint_and_record "charts/sourcegraph-executor/dind" --set "executor.queueName=batches"

exit "${exit_status}"
