#!/bin/bash

rm bootstrap.ign
rm master.ign
rm metadata.json
rm worker.ign
cp save/install-config.yaml .
./openshift-install create ignition-configs --dir=.
