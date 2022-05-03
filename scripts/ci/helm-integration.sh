#!/bin/bash

set -euf -o pipefail


# Install asdf terraform plugin
#asdf plugin add kind https://github.com/virtualstaticvoid/asdf-kind.git 
asdf plugin-add terraform https://github.com/asdf-community/asdf-hashicorp.git

# Install terraform via asdf
asdf install
