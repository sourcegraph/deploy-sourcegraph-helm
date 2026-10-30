#!/bin/sh
# Downloads the pinned helm-docs release into target/bin (gitignored) on first
# use, then runs it from the repository root with any arguments passed to this
# script.
#
# Usage:
#   ./scripts/helm-docs.sh                Regenerate charts/**/README.md after changing a values.yaml file
#   ./scripts/helm-docs.sh --check        Regenerate, then exit 1 listing any README that changed
#   ./scripts/helm-docs.sh [args]         Run the helm-docs CLI with args
#   ./scripts/helm-docs.sh --check [args] Check with helm-docs CLI args
#
# POSIX sh, so it runs the same on developer machines and in Buildkite.
#
# Adapted from https://github.com/linkerd/linkerd2/blob/main/bin/helm-docs

helmdocsversion=1.14.2

set -euf

check=false
if [ "${1:-}" = --check ]; then
    check=true
    shift
fi

# helm-docs scans the cwd for charts and reads .helmdocsignore from there, so
# run from the repository root regardless of the caller's cwd.
cd "$(dirname "$0")/.."

targetbin=$PWD/target/bin
helmdocsbin=$targetbin/helm-docs-$helmdocsversion

if [ ! -f "$helmdocsbin" ]; then
    # Release assets are named helm-docs_<version>_<OS>_<arch>.tar.gz,
    # e.g. Darwin_arm64, Linux_x86_64, Windows_x86_64
    case $(uname -s) in
        Darwin) os=Darwin ;;
        Linux) os=Linux ;;
        MSYS*|MINGW*|CYGWIN*) os=Windows ;;
        *) echo "Unsupported host OS: $(uname -s)" >&2; exit 126 ;;
    esac
    case $(uname -m) in
        x86_64|amd64) arch=x86_64 ;;
        aarch64|arm64) arch=arm64 ;;
        armv7l) arch=arm7 ;;
        armv6l) arch=arm6 ;;
        *) echo "Unsupported host architecture: $(uname -m)" >&2; exit 126 ;;
    esac
    helmdocscurl="https://github.com/norwoodj/helm-docs/releases/download/v$helmdocsversion/helm-docs_${helmdocsversion}_${os}_${arch}.tar.gz"
    tmp=$(mktemp -d "${TMPDIR:-/tmp}/helm-docs.XXXXXX")
    mkdir -p "$targetbin"
    (
        cd "$tmp"
        curl --proto '=https' --tlsv1.2 -sSfL -o helm-docs.tar.gz "$helmdocscurl"
        tar -xzf helm-docs.tar.gz helm-docs
        chmod +x helm-docs
    )
    mv "$tmp/helm-docs" "$helmdocsbin"
    rm -rf "$tmp"
fi

if [ "$check" = false ]; then
    exec "$helmdocsbin" "$@"
fi

# --check: checksum every chart README before and after, and fail if any
# changed. Only the READMEs count, so unrelated uncommitted edits elsewhere in
# the tree do not fail the check.
readme_checksums() { find charts -name README.md -exec cksum {} +; }
before=$(readme_checksums)

"$helmdocsbin" "$@"

rewritten=$(readme_checksums | while read -r line; do
    printf '%s\n' "$before" | grep -qxF -- "$line" || echo "${line##* }"
done)

if [ -n "$rewritten" ]; then
    echo "$rewritten"
    echo "The chart READMEs listed above are out of date. Run ./scripts/helm-docs.sh and commit them" >&2
    exit 1
fi
