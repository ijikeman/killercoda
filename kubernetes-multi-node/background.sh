#!/bin/bash
# define
LOG='/var/log/background.log'

# main
echo "Background Started" >> ${LOG}

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

# Setup krew plugins
echo "Setup krew plugins" >> ${LOG}
./.krew/bin/kubectl-krew install stern
./.krew/bin/kubectl-krew install ns
./.krew/bin/kubectl-krew install ctx
echo "Setup krew plugins Finished" >> ${LOG}

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
