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
cat <<EOF > /tmp/kind.yaml
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

# Setup kubectl
curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
mv kubectl /usr/local/bin/kubectl
cat <<EOF >> ~/.bashrc
source /usr/share/bash-completion/bash_completion
source <(kubectl completion bash)
alias k=kubectl
complete -F __start_kubectl k
EOF

# Setup Git
apt-get install git -y

echo 'done' > /tmp/background-finished
echo "Done"
