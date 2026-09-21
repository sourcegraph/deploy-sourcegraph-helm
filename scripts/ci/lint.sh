#!/bin/bash

set -euf -o pipefail

# Exit status used to signal "lint succeeded but emitted warnings". The Buildkite
# lint step soft-fails on this status, so it must never be used to report a chart
# that actually failed to lint.
WARNING_EXIT_STATUS=255

# Highest-severity outcome seen so far. A hard lint failure always wins over a
# warning, so a warning in an earlier chart can never downgrade a later failure
# into a soft fail.
hard_status=0
warned=0
results=()

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

  # A chart that failed to lint is reported as a failure even if it also emitted
  # warnings, otherwise the failure would be masked by the soft-failed status.
  if [ "${lint_status}" -ne 0 ]; then
    printf "Helm lint failed for %s\n" "${chart_path}" >&2
    return "${lint_status}"
  fi

  if grep -qi "warning" <<<"${lint_output}"; then
    printf "Helm lint emitted warnings for %s\n" "${chart_path}" >&2
    return "${WARNING_EXIT_STATUS}"
  fi

  return 0
}

function lint_and_record() {
  local chart_path="$1"
  local chart_status

  if lint_chart "$@"; then
    results+=("PASS     ${chart_path}")
    return 0
  else
    chart_status=$?
  fi

  if [ "${chart_status}" -eq "${WARNING_EXIT_STATUS}" ]; then
    warned=1
    results+=("WARNING  ${chart_path}")
  else
    results+=("FAIL     ${chart_path} (helm lint exited ${chart_status})")
    if [ "${hard_status}" -eq 0 ]; then
      hard_status="${chart_status}"
    fi
  fi

  return 0
}

lint_and_record "charts/sourcegraph"
lint_and_record "charts/sourcegraph-migrator"
lint_and_record "charts/sourcegraph-executor/k8s" --set "executor.queueName=batches"
lint_and_record "charts/sourcegraph-executor/dind" --set "executor.queueName=batches"

printf "\n\n===== Lint Summary =====\n"
printf "%s\n" "${results[@]}"

if [ "${hard_status}" -ne 0 ]; then
  printf "\nOne or more charts failed to lint\n" >&2
  exit "${hard_status}"
fi

if [ "${warned}" -ne 0 ]; then
  printf "\nOne or more charts emitted lint warnings\n" >&2
  exit "${WARNING_EXIT_STATUS}"
fi

exit 0
