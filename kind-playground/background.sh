#!/bin/bash

LOG='/var/log/background.log'
KIND_VERSION='v0.17.0'


# Setup Kind Command
echo "Setup kind-command" >> ${LOG}
curl -Lo ./kind https://kind.sigs.k8s.io/dl/${KIND_VERSION}/kind-linux-amd64
chmod +x ./kind
mv ./kind /usr/local/bin/kind

# Setup Kind Config
echo "Setup kind.yaml" >> ${LOG}
cat <<EOF > kind.yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  extraPortMappings:
  - containerPort: 80
    hostPort: 80
    protocol: TCP
  - containerPort: 443
    hostPort: 443
    protocol: TCP
- role: worker
- role: worker
EOF

# Create kind cluster
echo "Create Kind Cluster" >> ${LOG}
kind create cluster --config kind.yaml

echo 'done' > /tmp/background-finished
echo "Done"
