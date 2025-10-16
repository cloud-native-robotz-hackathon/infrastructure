---
title: Data Center
hero: "Data Center"
icon: material/server
---
## Data Center

### Adjust OpenShift design

* Login in into OpenShift Cluster (data-center)

* Go to `datacenter/cluster-configuration/base/namespace/openshift-config/Secret`
* Adjust errors-template.html, login-template.html and providers-template.html
* Run `./update-secrets.sh`

* Go to `datacenter/cluster-configuration/base/namespace/openshift-config/ConfigMap`
* Adjust openshift-robot.png (Optional the openshift-robot.xcf via Gimp and export as png )
* Run `./update-secrets.sh`


* Commit all changes and push it.
* Open ArgoCD and refresh and sync cluster-configuration 
