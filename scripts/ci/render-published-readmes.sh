#!/bin/bash

# Regenerates the chart READMEs with the exact image digests and registry from
# values.yaml, for the publish workflows to package.
#
# Committed READMEs show placeholders for these release-managed values (the
# `# @default --` annotations below), so a release doesn't change them. This
# script deletes those annotations and reruns helm-docs, so the README inside a
# published chart lists the same defaults as the values.yaml packaged with it.
# It modifies the working tree, so run it only in publish jobs.

set -euf -o pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/../.."

# shellcheck disable=SC2016 # the backticks are literal text in the annotation
find charts -name values.yaml -exec sed -i -E \
    '/^[[:space:]]*# @default -- (`<appVersion>@sha256:<digest>`, pinned by each release|Sourcegraph.s public Docker Hub registry)$/d' {} +

./scripts/helm-docs.sh
