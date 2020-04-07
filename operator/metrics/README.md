# Configure Persistent Storage for Prometheus

Refer to this documentation for [additional configuration options] for Prometheus.  In this example, I have followed this documentation to [implement persistence] using the local storage operator]

### Configure persistence

I followed these steps to configure the [local storage operator].  Then, I created two LocalVolumes for the two prometheus-k8s StatefulSets via the local storage operator with: `oc create -f metrics-volume1.yaml` and `oc create -f metrics-volume2.yaml`, replacing the hostname `worker1.yourcluster.domain.com` with your own.

Finally, I updated the cluster-monitoring-config ConfigMap with: `oc apply -f cluster-monitoring-config.cm.yaml` and allowed the prometheus-k8s pods to be recreated.

### Verify configurations

I verified the PersistentVolumeClaims were created and bound with: `oc get pvc -n openshift-monitoring`
I also verified the prometheus-k8s pods spun up properly in the project with: `oc get pods -o wide -n openshift-monitoring`

[additional configuration options]: https://docs.openshift.com/container-platform/4.3/monitoring/cluster_monitoring/configuring-the-monitoring-stack.html
[implement persistence]: https://docs.openshift.com/container-platform/4.3/monitoring/cluster_monitoring/configuring-the-monitoring-stack.html#configuring-persistent-storage
[local storage operator]: ../local-storage
