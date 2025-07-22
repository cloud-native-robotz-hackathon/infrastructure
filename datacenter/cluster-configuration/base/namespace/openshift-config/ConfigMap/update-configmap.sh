#!/usr/bin/env bash

    oc create configmap console-custom-logo \
        --from-file=openshift-robot-black.png=openshift-robot-black.png \
        --from-file=openshift-robot-white.png=openshift-robot-white.png \
        -n openshift-config \
        --dry-run=client \
        -o yaml > console-custom-logo.yaml

    echo '  annotations:' >> console-custom-logo.yaml
    echo '    argocd.argoproj.io/sync-options: "ServerSideApply=true,Validate=false"' >> console-custom-logo.yaml
    echo '    argocd.argoproj.io/compare-options: IgnoreExtraneous' >> console-custom-logo.yaml


