#!/bin/bash

set -euf -o pipefail


# Install asdf terraform plugin
#asdf plugin add kind https://github.com/virtualstaticvoid/asdf-kind.git 
TERRAFORM_CHECK=$(asdf which terraform)
if [[ $? -ne 0 ]]; then
  asdf plugin-add terraform https://github.com/asdf-community/asdf-hashicorp.git
fi

# Install terraform via asdf
asdf install
