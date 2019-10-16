OpenShift 4 UPI Home Lab Installation
=====================================

I followed these steps to build out my OpenShift 4.2 UPI home lab using Red Hat Enterprise Virtualization (RHEV) virtual machines.  Official documentation on a bare-metal installation is provided [here](
https://cloud.redhat.com/openshift/install/metal/user-provisioned).

Architecture
------------
* 1 helper node (RHEL7, 4 vCPU, 4 GB RAM, 30 GB disk)
* 1 bootstrap node (CoreOS, 4 vCPU, 16 GB RAM, 120 GB disk)
* 3 control plane nodes (each CoreOS, 4 vCPU, 16 GB RAM, 120 GB disk)
* 2 compute nodes (each CoreOS, 2 vCPU, 8 GB RAM, 120 GB disk)

Installation
------------

1. I followed instructions from this [Git repository](https://github.com/christianh814/ocp4-upi-helpernode) to build out a UPI helper node.  This allowed me to satisfy load balancing, DHCP, PXE, DNS, and HTTPD requirements.  I ran `nmcli device show` from the helper node to populate the DHCP section of vars.yaml since the helper node will function as DNS/DHCP for the cluster.  At this time, don't run the helper node configuration playbook yet.

2. I continued the bare metal installation [here](https://docs.openshift.com/container-platform/4.2/installing/installing_bare_metal/installing-bare-metal.html#ssh-agent-using_installing-bare-metal).  I followed these steps in the documentation:
  * Generating an SSH private key and adding it to the agent
  * Obtaining the installation program
  * Installing the OpenShift Command-line Interface
  * Manually creating the installation configuration file
  * Creating the Ignition config files
    * Note: The Ignition config files should be placed in the web directory of the httpd server on the UPI helper node.  Run `/usr/local/bin/helpernodecheck install-info` for more info.

3. For this step, Creating Red Hat Enterprise Linux CoreOS (RHCOS) machines using an ISO image, I proceeded as follows.
  a. In RHEV, I created the VMs for the bootstrap, control plane, and compute nodes.
  b. While creating the VMs booted from CD-ROM using a downloaded version of this ISO locally hosted in RHEV:
https://mirror.openshift.com/pub/openshift-v4/dependencies/rhcos/4.2/4.2.0/rhcos-4.2.0-x86_64-installer.iso
  c. I noted the MAC addresses of the network interfaces by populating the macaddr field of the bootstrap, masters, and workers sections of vars.yaml.
  d. At this point, I have the information needed to configure DHCP so I ran the helper node configuration playbook with the following command:
   ```
   ansible-playbook -e @vars.yaml tasks/main.yml
   ```

4. I started all of the VMs to install CoreOS.  When prompted, I installed CoreOS and specified the location of this BIOS:
http://<my-helper-node>:8080/install/bios.raw.gz

   This is a local clone of the upstream mirror:
   https://mirror.openshift.com/pub/openshift-v4/dependencies/rhcos/4.2/4.2.0/rhcos-4.2.0-x86_64-metal-bios.raw.gz

   When prompted, I installed the corresponding Ignition file:
  * http://<my-helper-node>:8080/ignition/bootstrap.ign
  * http://<my-helper-node>:8080/ignition/master.ign
  * http://<my-helper-node>:8080/ignition/worker.ign

   The CoreOS wrote to disk and requested a reboot, and I reconfigured RHEV to now boot from hard drive.  Upon reboot of each node, they consumed their respective Ignition files.

5. I kicked off the installation with the following command:
   ```
   ./openshift-install --dir=<installation_directory> wait-for bootstrap-complete --log-level info
   ```

License
-------
GPLv3

Author
------
Kevin Chung
