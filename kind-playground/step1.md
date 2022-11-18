# Get node list
```
k get nodes -o wide
```{{exec interrupt}}

# hogehog
```
k get namespaces
```{{copy}}

Now use the printed token in the terminal to log into:

[ACCESS HTTP]({{TRAFFIC_HOST1_80}}) or [ACCESS PORTS]({{TRAFFIC_SELECTOR}})
[ACCESS HTTPS]({{TRAFFIC_HOST1_443}}) or [ACCESS PORTS]({{TRAFFIC_SELECTOR}})
