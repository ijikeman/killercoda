echo waiting for init-background-script to finish
while [ ! -f /tmp/background-finishd ]; do sleep 1; done
echo Hello and Welcom to this scenario!
