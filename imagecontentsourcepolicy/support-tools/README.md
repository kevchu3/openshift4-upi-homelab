# [Restricted Network] - Configure Support Tools

The following must-gather and support-tools images from upstream quay.io and registry.redhat.io are not accessible from a restricted network.
* registry.redhat.io/rhel7/support-tools
* quay.io/openshift/origin-must-gather

Configure the cluster to pull the images above from your mirror Docker repository:
```
# Replace '<local-registry>:<local-port>' with your own mirror Docker repository host and port
vi support-tools-policy.yaml

# Apply the ImageContentSourcePolicy, which will also reboot the nodes
oc apply -f support-tools-policy.yaml
```
