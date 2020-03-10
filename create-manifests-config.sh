#!/bin/bash

rm .openshift_install.log
rm .openshift_install_state.json
cp save/install-config.yaml .
openshift-install create manifests --dir=.
