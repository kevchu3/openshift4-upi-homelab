# Configure NFS storage for image-registry operator

Refer to the following for additional documentation to [configure NFS storage].

This section provides steps to configure the image-registry operator to use NFS storage for a lab environment.  NFS storage for the image registry is not recommended in production.

### 1. Configure NFS mountpoint

Set up registry mountpoint on the NFS host.  Update the reference to *.yourcluster.domain.com to your own
```
mkdir -p /exports/registry
chmod -R 777 /exports/registry
chown -R nfsnobody:nfsnobody /exports/registry
echo "/exports/registry *.yourcluster.domain.com(rw,sync,no_wdelay,root_squash,insecure)" >> /etc/exports
exportfs -rv
```

### 2. Configure NFS storage

From the oc cli, create a persistent volume of at least 100Gi.  Use the sample `registry-volume.pv.yml` and update the reference to the NFS server to your own
```
oc apply -f registry-volume.pv.yml
```

Then, follow the remaining steps from the documentation to [configure NFS storage].

### 3. Optional: Configure default route

The following steps to [enable the image registry default route] were taken from the documentation.  In OpenShift Container Platform, the **Registry** Operator controls the registry feature. The Operator is defined by the `configs.imageregistry.operator.openshift.io` Custom Resource Definition (CRD).

Patch the Image Registry Operator CRD:
```
oc patch configs.imageregistry.operator.openshift.io/cluster --type merge -p '{"spec":{"defaultRoute":true}}'
```

[configure NFS storage]: https://docs.openshift.com/container-platform/latest/registry/configuring_registry_storage/configuring-registry-storage-baremetal.html#registry-configuring-storage-baremetal_configuring-registry-storage-baremetal
[enable the image registry default route]: https://docs.openshift.com/container-platform/latest/registry/configuring-registry-operator.html#registry-operator-default-crd_configuring-registry-operator
