# OpenShift 4 UPI Home Lab Installation

I followed these steps to build out my OpenShift 4 UPI home lab using Red Hat Enterprise Virtualization (RHEV) virtual machines.  Refer to the official documentation for a [bare metal installation]

## Architecture
* 1 helper node (RHEL7, 4 vCPU, 4 GB RAM, 30 GB disk)
* 1 bootstrap node (CoreOS, 4 vCPU, 16 GB RAM, 120 GB disk)
* 3 control plane nodes (each CoreOS, 4 vCPU, 16 GB RAM, 120 GB disk)
* 2 compute nodes (each CoreOS, 2 vCPU, 8 GB RAM, 120 GB disk)

## Installation

### 1. Set up helper node

I followed instructions from this [Git repository] to build out a UPI helper node.  This allowed me to satisfy load balancing, DHCP, PXE, DNS, and HTTPD requirements.  I ran `nmcli device show` from the helper node to populate the DHCP section of vars.yaml since the helper node will function as DNS/DHCP for the cluster.  At this time, don't run the helper node configuration playbook yet.

### 2. Bare metal installation

I continued with the bare metal installation, following the steps in the [documentation]
  * Generating an SSH private key and adding it to the agent
  * Obtaining the installation program
    * Place `openshift-install` binary in this Git repository's home directory
  * Installing the OpenShift Command-line Interface
  * Manually creating the installation configuration file
    * To get started, an example has been placed in the save directory and can be used with the following command: `cp save/install-config-example.yaml save/install-config.yaml`
    * Replace the contents of `save/install-config.yaml` with your custom configuration

### 3. Create virtual machines

For this step, "Creating Red Hat Enterprise Linux CoreOS (RHCOS) machines using an ISO image", I proceeded as follows.
  * In RHEV, I created the VMs for the bootstrap, control plane, and compute nodes.
  * For disks, I used Preallocated for the masters and Thin Provisioning for the bootstrap and compute nodes.  The etcd database on masters is I/O intensive and thus Preallocated is recommended.
  * While creating the VMs booted from CD-ROM using a downloaded version of this ISO locally hosted in RHEV:
    * OpenShift 4.4 - https://mirror.openshift.com/pub/openshift-v4/dependencies/rhcos/4.4/4.4.3/rhcos-4.4.3-x86_64-installer.x86_64.iso
    * OpenShift 4.3 - https://mirror.openshift.com/pub/openshift-v4/dependencies/rhcos/4.3/4.3.8/rhcos-4.3.8-x86_64-installer.x86_64.iso
    * OpenShift 4.2 - https://mirror.openshift.com/pub/openshift-v4/dependencies/rhcos/4.2/4.2.18/rhcos-4.2.18-x86_64-installer.iso

### 4. Configure DHCP

  * While still in RHEV, I noted the MAC addresses of the network interfaces by populating the macaddr field of the bootstrap, masters, and workers sections of vars.yaml.
  * At this point, I have the information needed to configure DHCP so I ran the helper node configuration playbook with the following command:
   ```
   ansible-playbook -e @vars.yaml tasks/main.yml
   ```
  * Add the api and api-int URLs to `/etc/hosts` on your helper node:
   ```
   <your-helper-node-ip> api.<your-clusterid>.<your-cluster-domain>
   <your-helper-node-ip> api-int.<your-clusterid>.<your-cluster-domain>
   ```

### 5. Create the manifests and ignition config files

  * Run the helper script to create the manifests file: `create-manifests-config.sh`
  * Run the helper script to create the ignition config file: `./create-ignition-configs.sh`
    * The Ignition config files should be placed in the web directory of the httpd server on the UPI helper node: `chmod 644 *.ign; cp *.ign /var/www/html/ignition/; restorecon -vR /var/www/html/`
    * Run `/usr/local/bin/helpernodecheck install-info` for more info.

### 6. Install RHCOS

I started all of the VMs to install RHCOS.  On the "Install CoreOS" screen, I pressed Tab and added the following to specify the corresponding Ignition and BIOS files:
   ```
   For bootstrap node:
   coreos.inst.install_dev=sda coreos.inst.image_url=http://my-helper-node:8080/install/bios.raw.gz coreos.inst.ignition_url=http://my-helper-node:8080/ignition/bootstrap.ign

   For master node:
   coreos.inst.install_dev=sda coreos.inst.image_url=http://my-helper-node:8080/install/bios.raw.gz coreos.inst.ignition_url=http://my-helper-node:8080/ignition/master.ign

   For worker node:
   coreos.inst.install_dev=sda coreos.inst.image_url=http://my-helper-node:8080/install/bios.raw.gz coreos.inst.ignition_url=http://my-helper-node:8080/ignition/worker.ign
   ```

   The BIOS file was created by the helper node playbook and is a local clone of the upstream mirror:
   * OpenShift 4.4 - https://mirror.openshift.com/pub/openshift-v4/dependencies/rhcos/4.4/4.4.3/rhcos-4.4.3-x86_64-metal.x86_64.raw.gz
   * OpenShift 4.3 - https://mirror.openshift.com/pub/openshift-v4/dependencies/rhcos/4.3/4.3.8/rhcos-4.3.8-x86_64-metal.x86_64.raw.gz
   * OpenShift 4.2 - https://mirror.openshift.com/pub/openshift-v4/dependencies/rhcos/4.2/4.2.18/rhcos-4.2.18-x86_64-metal-bios.raw.gz

   The CoreOS wrote to disk and requested a reboot, and I reconfigured RHEV to now boot from hard drive.  Upon reboot of each node, they consumed their respective Ignition files.

### 7. Install OpenShift

I kicked off the installation with the following command:
   ```
   ./openshift-install --dir=<installation_directory> wait-for bootstrap-complete --log-level info
   ```

### 8. Verify installation

To verify installation, I ran this helper script: `./complete-install.sh`

## Post Installation

Refer to this documentation for [post installation procedures (day 2)].

## [Restricted Network] - Update Cluster with Mirror Repository

Refer to this documentation for [updating a cluster in a restricted network].

## License
GPLv3

## Author
Kevin Chung

[bare metal installation]: https://cloud.redhat.com/openshift/install/metal/user-provisioned
[Git repository]: https://github.com/RedHatOfficial/ocp4-helpernode
[documentation]: https://docs.openshift.com/container-platform/latest/installing/installing_bare_metal/installing-bare-metal.html#ssh-agent-using_installing-bare-metal
[post installation procedures (day 2)]: day-two.md
[updating a cluster in a restricted network]: update-restricted.md
