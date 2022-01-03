#!/bin/bash


### Install Helm
curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
sudo apt-get install apt-transport-https --yes
echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm

### Install the helm-unittest plugin
helm plugin install https://github.com/quintush/helm-unittest

### Run the helm tests
helm unittest -3q sourcegraph
