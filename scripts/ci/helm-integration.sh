#!/bin/bash

set -euf -o pipefail


# Install asdf kind plugin
#asdf plugin add kind https://github.com/virtualstaticvoid/asdf-kind.git 

# Install kind via asdf
# TBD

curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.12.0/kind-darwin-amd64
chmod +x ./kind

./kind cluster create
