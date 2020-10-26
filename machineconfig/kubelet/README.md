# Configure Kubelet Logging Verbosity

Refer to this Knowledgebase article for [configuring kubelet logging verbosity].

### Step by step example

In this example, I have followed the article to create MachineConfigs to apply the logging level to `/etc/kubernetes/kubelet-env` which will persist across reboots.

Then, I applied the MachineConfigs to the cluster with:
```
oc apply -f 02-kubelet-env-config-master.yaml
oc apply -f 02-kubelet-env-config-worker.yaml
oc apply -f 02-kubelet-env-config-infra.yaml   # for clusters with infra tier
```

[configuring kubelet logging verbosity]: https://access.redhat.com/solutions/4619431
