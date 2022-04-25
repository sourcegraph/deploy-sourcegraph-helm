#!/bin/bash

set -euf -o pipefail


# Install asdf kind plugin
#asdf plugin add kind https://github.com/virtualstaticvoid/asdf-kind.git 

# Install kind via asdf
# TBD

KIND_VERSION=0.12.0

if [[ `uname -a | grep -i "Linux"` && `uname -a | grep -i "x86"` ]]
then
	DOWNLOADABLE=kind-linux-amd64
elif [[ `uname -a | grep -i "Darwin"` && `uname -a | grep -i "x86"` ]]
then
	DOWNLOADABLE=kind-darwin-amd64
elif [[ `uname -a | grep -i "Darwin"` && `uname -a | grep -i "arm64"` ]]
then
	DOWNLOADABLE=kind-darwin-amd64
fi

curl -Lo ./kind "https://github.com/kubernetes-sigs/kind/releases/download/v${KIND_VERSION}/${DOWNLOADABLE}"
chmod +x ./kind

# Rootless Docker
#export DOCKER_HOST=unix://${XDG_RUNTIME_DIR}/docker.sock

# Create integration cluster
./kind create cluster
