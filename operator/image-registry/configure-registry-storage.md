NFS storage for image-registry operator
=======================================

Documentation: https://access.redhat.com/documentation/en-us/openshift_container_platform/4.2/html/registry/configuring-registry-storage#configuring-registry-storage-baremetal

This section provides steps to configure the image-registry operator to use NFS storage for a lab environment.  NFS storage for the image registry is not recommended in production.

1. Set up registry mountpoint on the NFS host.  Update the reference to *.yourcluster.domain.com to your own
```
mkdir -p /exports/registry
chmod -R 777 /exports/registry
chown -R nfsnobody:nfsnobody /exports/registry
echo "/exports/registry *.yourcluster.domain.com(rw,sync,no_wdelay,root_squash,insecure,fsid=0)" >> /etc/exports
exportfs -rv
```

2. From the oc cli, create a persistent volume of at least 100Gi.  Use the sample `registry-volume.pv.yml` and update the reference to the NFS server to your own
```
oc apply -f registry-volume.pv.yml
```

3. Then, follow the remaining steps from the documentation.
