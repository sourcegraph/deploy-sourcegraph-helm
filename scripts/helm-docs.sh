#!/usr/bin/env bash
# Copy from https://github.com/linkerd/linkerd2/blob/main/bin/helm-docs

set -euf -o pipefail

helmdocsv=1.7.0
bindir=$( cd "${0%/*}" && pwd ) # Change to script dir and set bin dir to this
targetbin=$( cd "$bindir"/.. && pwd )/target/bin
helmdocsbin=$targetbin/helm-docs-$helmdocsv

if [ ! -f "$helmdocsbin" ]; then
    # Release assets are named helm-docs_<version>_<OS>_<arch>.tar.gz,
    # e.g. Darwin_arm64, Linux_x86_64, Windows_x86_64
    case $(uname -s) in
        Darwin) os=Darwin ;;
        Linux) os=Linux ;;
        MSYS*|MINGW*|CYGWIN*) os=Windows ;;
        *) echo "Unsupported OS: $(uname -s)"; exit 126 ;;
    esac
    case $(uname -m) in
        x86_64|amd64) arch=x86_64 ;;
        aarch64|arm64) arch=arm64 ;;
        armv7l) arch=armv7 ;;
        armv6l) arch=armv6 ;;
        *) echo "Unsupported architecture: $(uname -m)"; exit 126 ;;
    esac
    helmdocscurl="https://github.com/norwoodj/helm-docs/releases/download/v$helmdocsv/helm-docs_${helmdocsv}_${os}_${arch}.tar.gz"
    tmp=$(mktemp -d -t helm-docs.XXX)
    mkdir -p "$targetbin"
    (
        cd "$tmp"
        curl --proto '=https' --tlsv1.2 -sSfL -o "./helm-docs.tar.gz" "$helmdocscurl"
        tar zf "./helm-docs.tar.gz" -x "helm-docs"
        chmod +x "helm-docs"
    )
    mv "$tmp/helm-docs" "$helmdocsbin"
fi

"$helmdocsbin" "$@"