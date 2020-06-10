# Update Cluster with Mirror Repository

Refer to this documentation for [initial lab installation].

The following instructions are intended to provide an addendum to the [official documentation] on updating the minor version of a running cluster in a restricted network.

### Assumptions

The following procedures assume that the running cluster does not have access to [Red Hat's public sites], including **mirror.openshift.com** and **api.openshift.com**.  Thus, the update procedures must be done via command line interface and not the web console.

While the cluster itself does not have access to Red Hat's public sites, it has access to a mirror Docker repository which itself has access to those sites.

### 1. Mirror the updated images

From a bastion host with access to both the cluster and mirror Docker repository, run the following commands, with the following edits:
* Substitute `4.4.3-x86_64` with your target update version and architecture
* Substitute `'<local-registry>:<local-port>'` with your mirror Docker repository hostname and port
* Create a file named `pull-secret` in the working directory which has access to your mirror Docker repository.  Consult this documentation to [create a pull secret].

```
export OCP_RELEASE=4.4.3-x86_64
export LOCAL_REGISTRY='<local-registry>:<local-port>' 
export LOCAL_REPOSITORY='ocp-release' 
export PRODUCT_REPO='openshift-release-dev' 
export LOCAL_SECRET_JSON='pull-secret' 
export RELEASE_NAME='ocp-release'

# mirror contents to external repository
oc adm -a ${LOCAL_SECRET_JSON} release mirror \
     --from=quay.io/${PRODUCT_REPO}/${RELEASE_NAME}:${OCP_RELEASE} \
     --to=${LOCAL_REGISTRY}/${LOCAL_REPOSITORY} \
     --to-release-image=${LOCAL_REGISTRY}/${LOCAL_REPOSITORY}:${OCP_RELEASE} \
     --insecure=true
```

### 2. Update cluster

Navigate to the following link (substitute 4.4.3 with your target version):
http://mirror.openshift.com/pub/openshift-v4/clients/ocp/4.4.3/release.txt

Make note of the digest, i.e.
```
Digest:    sha256:039a4ef7c128a049ccf916a1d68ce93e8f5494b44d5a75df60c85e9e7191dacc
```

Finally, update the cluster based on the digest:
```
oc adm upgrade --to-image=nexus.fsi.tamlab.rdu2.redhat.com:5004/openshift-release-dev/ocp-release@sha256:039a4ef7c128a049ccf916a1d68ce93e8f5494b44d5a75df60c85e9e7191dacc --allow-explicit-upgrade --force
```

## License
GPLv3

## Author
Kevin Chung

[initial lab installation]: README.md
[official documentation]: https://docs.openshift.com/container-platform/latest/updating/updating-cluster-between-minor.html
[Red Hat's public sites]: https://docs.openshift.com/container-platform/latest/installing/install_config/configuring-firewall.html
[create a pull secret]: https://docs.openshift.com/container-platform/latest/installing/install_config/installing-restricted-networks-preparations.html#installation-adding-registry-pull-secret_installing-restricted-networks-preparations
