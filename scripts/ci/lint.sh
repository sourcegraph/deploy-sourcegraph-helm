#!/bin/bash

set -euf -o pipefail

### Run the helm tests
LINT_OUTPUT=$(helm lint sourcegraph)
ORG_STATUS=$?

printf "\n\n===== Lint Output =====\n$LINT_OUTPUT\n"

LINT_OUTPUT_LOWER=$(echo "$LINT_OUTPUT" | awk '{print tolower($0)}')
if grep -q "warning" <<<"$LINT_OUTPUT_LOWER"; then
	exit 255
else
	exit $ORG_STATUS
fi
