# Configure NFS storage for metering operator

Refer to the following for additional documentation to [install the metering operator].

This section provides steps to configure the metering operator to use NFS storage for a lab environment.  NFS storage for the metering operator is not recommended in production.

### 1. Configure NFS mountpoint

Set up a metering and a hive mountpoint on the NFS host.  Update the reference to *.yourcluster.domain.com to your own
```
mkdir -p /exports/metering
chmod -R 777 /exports/metering
chown -R nfsnobody:nfsnobody /exports/metering
echo "/exports/metering *.yourcluster.domain.com(rw,sync,no_wdelay,root_squash,insecure)" >> /etc/exports

mkdir -p /exports/metering-hive
chmod -R 777 /exports/metering-hive
chown -R nfsnobody:nfsnobody /exports/metering-hive
echo "/exports/metering-hive *.yourcluster.domain.com(rw,sync,no_wdelay,root_squash,insecure)" >> /etc/exports
exportfs -rv
```

### 2. Configure NFS storage

From the oc cli, create two persistent volumes of 5Gi each.  Use the sample `metering-volume.pv.yml` and `hive-metastore-db-data.pv.yml` and update the reference to the NFS server to your own
```
oc apply -f metering-volume.pv.yml
oc apply -f hive-metastore-db-data.pv.yml
```

### 3. Configure metering 

Follow the steps from the documentation to [configure metering with storage].  Use the sample `operator-metering.meteringconfig.yml` and update the configuration as needed
```
oc apply -f operator-metering.meteringconfig.yml
```


[install the metering operator]: https://docs.openshift.com/container-platform/4.3/metering/metering-installing-metering.html
[configure metering with storage]: https://docs.openshift.com/container-platform/4.3/metering/configuring_metering/metering-configure-persistent-storage.html#metering-store-data-in-shared-volumes_metering-configure-persistent-storage
