# Configure local storage operator

This section provides steps to configure the local storage operator available from OperatorHub to use for a lab environment.  Local storage is not recommended in production.

### 1. Add a RHEL compute node

To use local storage, you will need a RHEL compute node in the cluster.  Refer to the following documentation to [add a RHEL compute node].

### 2. Add new device path to node

On the RHEL compute node, create a new device path.  For this example, we will use `/dev/sdb1` for the second partition.  Add the partition by running `fdisk /dev/sdb1`.

### 3. Configure local storage

Refer to the following for documentation to [configure local persistent storage].  This example provisions the following StorageClass objects:

* StorageClass named `local-storageclass` using Filesystem storage on the `/dev/sdb1` device path.  Replace the node name `worker1.yourcluster.domain.com` with your own.  Create the LocalVolume object with the following: `oc apply -f local-volume.yaml`
* StorageClass named `localblock-storageclass` using Block storage on the `/dev/sdb2` device path.  Replace the node name `worker1.yourcluster.domain.com` with your own.  Create the LocalVolume object with the following: `oc apply -f localblock-volume.yaml`

[add a RHEL compute node]: https://docs.openshift.com/container-platform/4.3/machine_management/adding-rhel-compute.html
[configure local persistent storage]: https://docs.openshift.com/container-platform/4.3/storage/persistent_storage/persistent-storage-local.html
