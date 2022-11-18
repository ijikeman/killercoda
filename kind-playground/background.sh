#!/bin/bash

echo "Setup kind-command" >> /var/log/background.log

curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.17.0/kind-linux-amd64
chmod +x ./kind
mv ./kind /usr/local/bin/kind

echo 'done' > /tmp/background-finished
echo "Done"
