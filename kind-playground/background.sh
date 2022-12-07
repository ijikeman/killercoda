#!/bin/bash

LOG='/var/log/background.log'
KIND_VERSION='v0.17.0'


# Setup Kind Command
echo "Setup kind-command" >> ${LOG}
curl -Lo ./kind https://kind.sigs.k8s.io/dl/${KIND_VERSION}/kind-linux-amd64
chmod +x ./kind
mv ./kind /usr/local/bin/kind
echo "Setup kind-command Finished" >> ${LOG}

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
echo "Setup kind.yaml Finished" >> ${LOG}

# Setup kubectl
echo "Setup kubectl" >> ${LOG}
curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
mv kubectl /usr/local/bin/kubectl
cat <<EOF >> ~/.bashrc
source /usr/share/bash-completion/bash_completion
source <(kubectl completion bash)
alias k=kubectl
complete -F __start_kubectl k
EOF
echo "Setup kubectl Finished" >> ${LOG}


# Setup krew
echo "Setup krew" >> ${LOG}
(
  set -x; cd "$(mktemp -d)" &&
  OS="$(uname | tr '[:upper:]' '[:lower:]')" &&
  ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" &&
  KREW="krew-${OS}_${ARCH}" &&
  curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" &&
  tar zxvf "${KREW}.tar.gz" &&
  ./"${KREW}" install krew
)
echo 'export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"' >> ~/.bashrc
echo "Setup krew Finished" >> ${LOG}

# Setup Stern
echo "Setup stern" >> ${LOG}
./.krew/bin/kubectl-krew install stern
echo "Setup stern Finished" >> ${LOG}

# Setup kube-ps1
echo "Setup kube-ps1" >> ${LOG}
PS1_VERSION=v0.8.0
curl https://raw.githubusercontent.com/jonmosco/kube-ps1/${PS1_VERSION}/kube-ps1.sh -o /usr/local/bin/kube-ps1.sh
echo 'source /usr/local/bin/kube-ps1.sh' >> ~/.bashrc
echo "PS1='[\u@\h \W \$(kube_ps1)]\\$ '" >>  ~/.bashrc
echo "Setup kube-ps1 finished" >> ${LOG}

# Finished
echo 'done' > /tmp/background-finished
echo "Done"
