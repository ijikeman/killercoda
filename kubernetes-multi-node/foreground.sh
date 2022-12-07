while [ ! -f /tmp/background-finished ]; do sleep 5; echo 'check file'; done

kind create cluster --config /tmp/kind.yaml
source ~/.bashrc
echo Hello and Welcom to this scenario!
