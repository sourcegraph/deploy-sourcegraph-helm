#!/bin/sh
# Downloads the pinned helm-docs release into target/bin (gitignored) on first
# use, then runs it with any arguments passed to this script.
#
#   ./scripts/helm-docs.sh          regenerate charts/**/README.md
#   ./scripts/helm-docs.sh --check  regenerate, then fail if any README changed
#
# POSIX sh only (no bash): this runs on developer machines, in Buildkite, and
# in the release worker's busybox-based image. Adapted from
# https://github.com/linkerd/linkerd2/blob/main/bin/helm-docs

set -euf

check=false
if [ "${1:-}" = --check ]; then
    check=true
    shift
fi

helmdocsv=1.14.2
# Run from the repository root regardless of the caller's cwd: helm-docs
# scans the cwd for charts, and it reads .helmdocsignore from there too.
cd "$(dirname "$0")/.."
targetbin=$PWD/target/bin
helmdocsbin=$targetbin/helm-docs-$helmdocsv

if [ ! -f "$helmdocsbin" ]; then
    # Release assets are named helm-docs_<version>_<OS>_<arch>.tar.gz,
    # e.g. Darwin_arm64, Linux_x86_64, Windows_x86_64
    case $(uname -s) in
        Darwin) os=Darwin ;;
        Linux) os=Linux ;;
        MSYS*|MINGW*|CYGWIN*) os=Windows ;;
        *) echo "Unsupported OS: $(uname -s)" >&2; exit 126 ;;
    esac
    case $(uname -m) in
        x86_64|amd64) arch=x86_64 ;;
        aarch64|arm64) arch=arm64 ;;
        armv7l) arch=arm7 ;;
        armv6l) arch=arm6 ;;
        *) echo "Unsupported architecture: $(uname -m)" >&2; exit 126 ;;
    esac
    helmdocscurl="https://github.com/norwoodj/helm-docs/releases/download/v$helmdocsv/helm-docs_${helmdocsv}_${os}_${arch}.tar.gz"

    # An explicit template works the same in GNU, BSD/macOS, and busybox mktemp.
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

"$helmdocsbin" "$@"

if [ "$check" = true ]; then
    # Only READMEs helm-docs writes, so unrelated local edits don't fail the check.
    stale=$(git status --porcelain -- 'charts/*/README.md')
    if [ -n "$stale" ]; then
        echo "Chart READMEs are out of date. Run ./scripts/helm-docs.sh and commit:" >&2
        echo "$stale" >&2
        exit 1
    fi
fi
