# Configure Chrony Time Service with MachineConfig

Refer to this documentation for [configuring chrony time service].

### Step by step example

In this example, I have followed the documentation to customize the `/etc/chrony.conf` using the contents of [example-chrony.conf] to use the `clock.redhat.com` NTP server.  I stepped through the documentation to generate the MachineConfigs for masters and workers.

Then, I applied the chrony configuration MachineConfigs to the cluster with:
```
oc apply -f 99-master-chrony-configuration.yaml
oc apply -f 99-worker-chrony-configuration.yaml
```

[configuring chrony time service]: https://docs.openshift.com/container-platform/4.3/installing/install_config/installing-customizing.html#installation-special-config-crony_installing-customizing
[example-chrony.conf]: ./example-chrony.conf
