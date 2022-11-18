#!/bin/bash

# Setup kind command
echo "Setup kind-command"
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.17.0/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind

# Setup kind.config
echo "Setup kind-config"
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
cat kind.config.yaml

# create cluster
echo "Create kind cluster(c1, w2, port-forward:80,443)"
kind create cluster --config kind.yaml

# kubectl
echo "Setup kubectl"
curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
mv kubectl /usr/local/bin/kubectl
cat <<EOF >> .bashrc
alias k=kubectl
source <(kubectl completion bash)
complete -F __start_kubectl k
EOF
source ~$HOME/.bashrc

# Confirm kind cluster
kind get clusters
kubectl get nodes -o wide

# Done
echo 'done' > /opt/background-finished
echo "Done"
