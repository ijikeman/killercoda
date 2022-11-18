echo waiting for init-background-script to finish
while [ ! -f /tmp/background-finished ]; do sleep 1; done

kind create cluster --config /tmp/kind.yaml
source ~/.bashrc
echo Hello and Welcom to this scenario!
