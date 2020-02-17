#!/bin/bash

cp save/install-config.yaml .
openshift-install create manifests --dir=.
