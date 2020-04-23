# Configure NFS storage for 3scale operator

Refer to the following for additional documentation to [install the 3scale operator].

This section provides steps to configure the 3scale operator to use NFS storage for a lab environment.

### 1. Configure NFS mountpoint

Review the [system requirements] for installing 3scale on OpenShift.  You will need the following persistent volumes:
* 3 RWO (ReadWriteOnce) persistent volumes for Redis and MySQL persistence
* 1 RWX (ReadWriteMany) persistent volume for CMS and System-app Assets

```
mkdir -p /exports/3scale/backend-redis
mkdir -p /exports/3scale/mysql
mkdir -p /exports/3scale/system
mkdir -p /exports/3scale/system-redis

chmod -R 777 /exports/3scale/*
chown -R nfsnobody:nfsnobody /exports/3scale/*
echo "/exports/3scale *.yourcluster.domain.com(rw,sync,no_wdelay,root_squash,insecure)" >> /etc/exports
exportfs -rv
```

### 2. Configure NFS storage

From the oc cli, create four persistent volumes of 5Gi each.  Use the sample files included and update the reference to the NFS server to your own
```
oc apply -f 3scale-backend-redis.pv.yaml
oc apply -f 3scale-mysql.pv.yaml
oc apply -f 3scale-system.pv.yaml
oc apply -f 3scale-system-redis.pv.yaml
```

### 3. Deploy the APIManager custom resource

Follow the steps from the documentation to [deploy the APIManager custom resource] which utilizes the NFS storage that you previously set up.  Use the sample `example.apimanager.yaml` and update the wildcardDomain to your own.
```
oc apply -f example.apimanager.yaml
```

[install the 3scale operator]: https://access.redhat.com/documentation/en-us/red_hat_3scale_api_management/2.8/html-single/installing_3scale/index#installing-threescale-operator-on-openshift
[system requirements]: https://access.redhat.com/documentation/en-us/red_hat_3scale_api_management/2.8/html-single/installing_3scale/index#system-requirements-for-installing-threescale-on-openshift
[deploy the APIManager custom resource]: https://access.redhat.com/documentation/en-us/red_hat_3scale_api_management/2.8/html-single/installing_3scale/index#deploying-apimanager-custom-resource
