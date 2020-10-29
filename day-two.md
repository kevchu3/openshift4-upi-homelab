# OpenShift 4 UPI Home Lab Post Installation (Day 2)

Refer to this documentation for [initial lab installation].

## Configure your laptop

To view the console and oauth URLs from your laptop outside of the cluster, add the following entries to your laptop's `/etc/hosts`:
```
<your-laptop-ip> console-openshift-console.apps.<your-cluster-domain>
<your-laptop-ip> oauth-openshift.apps.<your-cluster-domain>
```

## Configure Operators

By following the [initial lab installation], your OpenShift cluster is complete.  Thus, the following instructions are entirely optional, but provide some guidance on day 2 configuration.

### 1. Configure image registry

The image registry operator will start in a Removed state with the following note: "Image Registry has been removed. ImageStreamTags, BuildConfigs and DeploymentConfigs which reference ImageStreamTags may not work as expected. Please configure storage and update the config to Managed state by editing configs.imageregistry.operator.openshift.io."

Two quick options to configure the Image Registry operator are provided below to get started.  Please note that these are not recommended for production use.

#### 1a. Configure NFS storage

  Refer to these instructions to [configure NFS storage using your helper node].  Refer to the following for additional documentation to [configure NFS storage].

#### 1b. Configure ephemeral storage

  To configure ephemeral storage instead, you can run the following:
  ```
  oc patch configs.imageregistry.operator.openshift.io cluster --type merge --patch '{"spec":{"storage":{"emptyDir":{}}}}'
  ```

  Refer to the following for additional documentation to [configure ephemeral storage].


### 2. Configure additional operators

Refer to these instructions to configure additional operators
* [Local storage operator]
* [Prometheus operator with persistent storage]
* [Metering operator]
* [3scale operator]

### 3. Configure image pruning

*Prerequisites: OpenShift 4.4+*

Refer to the documentation for more information on [automatically pruning images].
By default, image pruning is not configured and the dashboard shows the following warning:

> Automatic image pruning is not enabled. Regular pruning of images no longer referenced by ImageStreams is strongly recommended to ensure your cluster remains healthy. To remove this warning, install the image pruner by creating an imagepruner.imageregistry.operator.openshift.io resource with the name `cluster`. Ensure that the `suspend` field is set to `false`.

To configure the image pruner, run the following command:
```
oc patch imagepruner.imageregistry.operator.openshift.io/cluster --type merge --patch '{"spec":{"suspend":false}}'
```

### 4. Configure chrony time service

Refer to these instructions to configure chrony time service
* [Chrony time service]

### 5. Configure kubelet logging verbosity

Refer to these instructions to configure kubelet logging verbosity
* [Kubelet logging verbosity]

### 6. Configure project template

Refer to the documentation on how to configure a [project template].

#### a. Multitenant network policy

Using Network Policy, by default, all Pods in a project are accessible from other Pods and network endpoints.  Refer to the documentation for information on [configuring multitenant network policy].  Refer to the documentation for steps to [configure this policy for new projects by default].

An example with [multitenant network policy] is provided and can be installed with:
```
oc create -f template/multitenant-network-policy.yaml -n openshift-config
oc patch project.config.openshift.io/cluster --type merge -p '{"spec":{"projectRequestTemplate":{"name":"multitenant-project-template"}}}'
```

#### b. Resource quotas and limit ranges

Refer to the documentation on how to configure [resource quotas] and [limit ranges].

An example of an [all-in-one project template] with NetworkPolicy, ResourceQuotas, and LimitRanges is provided.

### 7. [Restricted Network] - Configure support tools

Refer to these instructions to configure support tools for a restricted network
* [Support tools]


## License
GPLv3

## Author
Kevin Chung

[initial lab installation]: README.md
[configure NFS storage using your helper node]: ./operator/image-registry/
[configure NFS storage]: https://docs.openshift.com/container-platform/latest/registry/configuring_registry_storage/configuring-registry-storage-baremetal.html#registry-configuring-storage-baremetal_configuring-registry-storage-baremetal
[configure ephemeral storage]: https://docs.openshift.com/container-platform/latest/registry/configuring_registry_storage/configuring-registry-storage-baremetal.html#installation-registry-storage-non-production_configuring-registry-storage-baremetal
[Local storage operator]: ./operator/local-storage/
[Prometheus operator with persistent storage]: ./operator/metrics/
[Metering operator]: ./operator/metering/
[3scale operator]: ./operator/3scale/
[automatically pruning images]: https://docs.openshift.com/container-platform/latest/applications/pruning-objects.html#pruning-images_pruning-objects
[Chrony time service]: ./machineconfig/chrony/
[Kubelet logging verbosity]: ./machineconfig/kubelet/
[project template]: https://docs.openshift.com/container-platform/latest/applications/projects/configuring-project-creation.html
[configuring multitenant network policy]: https://docs.openshift.com/container-platform/latest/networking/network_policy/multitenant-network-policy.html
[configure this policy for new projects by default]: https://docs.openshift.com/container-platform/latest/networking/network_policy/default-network-policy.html
[multitenant network policy]: ./template/multitenant-network-policy.yaml
[resource quotas]: https://docs.openshift.com/container-platform/latest/applications/quotas/quotas-setting-per-project.html
[limit ranges]: https://docs.openshift.com/container-platform/latest/nodes/clusters/nodes-cluster-limit-ranges.html
[all-in-one project template]: ./template/multitenant-project-template.yaml
[Support tools]: ./imagecontentsourcepolicy/support-tools/
