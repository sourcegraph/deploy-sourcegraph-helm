#!/bin/sh
# Downloads the pinned helm-docs release into target/bin (gitignored) on first
# use, then runs it with any arguments passed to this script
#
# Usage:
#   ./scripts/helm-docs.sh                Regenerate charts/**/README.md after changing a values.yaml file
#   ./scripts/helm-docs.sh --check        CI check: regenerate, and fail if any changed
#   ./scripts/helm-docs.sh [args]         Run the helm-docs CLI with args
#   ./scripts/helm-docs.sh --check [args] CI check with helm-docs CLI args
#
# POSIX compliant, so it runs the same anywhere: on developer machines, 
# in Buildkite, and in the release worker's busybox image
#
# Adapted from https://github.com/linkerd/linkerd2/blob/main/bin/helm-docs

# Pinned version of helm-docs
helmdocsversion=1.14.2

set -euf

# Eat the --check positional arg
check=false
if [ "${1:-}" = --check ]; then
    check=true
    shift
fi

# Run from the repository root regardless of the caller's cwd: helm-docs
# scans the cwd for charts, and it reads .helmdocsignore from there too.
cd "$(dirname "$0")/.."

targetbin=$PWD/target/bin
helmdocsbin=$targetbin/helm-docs-$helmdocsversion

# Download helm-docs if it doesn't already exist
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

# Checksum every chart README, so --check can tell which ones helm-docs rewrote
# without git (the release worker has neither git nor a checkout)
readme_checksums() { find charts -name README.md -exec cksum {} +; }

if [ "$check" = true ]; then
    before=$(readme_checksums)
fi

# Run helm-docs, with any remaining args
"$helmdocsbin" "$@"

if [ "$check" = true ]; then
    # Paths whose checksum line isn't in the before snapshot (changed or new)
    stale=$(readme_checksums | while read -r line; do
        printf '%s\n' "$before" | grep -qxF -- "$line" || echo "${line##* }"
    done)
    if [ -n "$stale" ]; then
        echo "Chart READMEs are out of date. Run ./scripts/helm-docs.sh and commit:" >&2
        echo "$stale" >&2
        exit 1
    fi
fi
