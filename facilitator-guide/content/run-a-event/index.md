---
title: Run a Event
hero: "Run a Event"
description: "..."
icon: material/run
---
# Run a Hackathon

|Check|When|What|
|---|---|---|
| |Before 1-2 Days| [Order OpenShift Data Center env](#order-openshift-data-center-env) |
| |Before 1-2 Days| [Adjust OpenShift design](#adjust-openshift-design) |
| |Location|[Setting up the environment](#setting-up-the-environment)|

## Order OpenShift Data Center env

This includes deploying the hackathon environment in [demo.redhat.com](https://catalog.demo.redhat.com/catalog?search=Cloud+Native+Robot+Hackathon&item=babylon-catalog-prod%2Fsandboxes-gpte.cloud-native-robot.prod) and making sure an Edge Gateway is available.

|Field|Value
|---|---|
|OpenShift User Count|`9`|
|Region|Close as possible: `eu-central-1`|
|GPU Worker Nodes (one GPU per Worker!)|For testing puropose only, workshop is not prepred to use GPU's!
|Enable workshop user interface|True|

## Adjust OpenShift design

* Login in into OpenShift Cluster (data-center)

* Go to `datacenter/cluster-configuration/base/namespace/openshift-config/Secret`
* Adjust errors-template.html, login-template.html and providers-template.html
* Run `./update-secrets.sh`

* Go to `datacenter/cluster-configuration/base/namespace/openshift-config/ConfigMap`
* Adjust openshift-robot.png (Optional the openshift-robot.xcf via Gimp and export as png )
* Run `./update-secrets.sh`


* Commit all changes and push it.
* Open ArgoCD and refresh and sync cluster-configuration 

## Setting up the environment

### Wifi Router

* Start the Wifi router and attach to the local Wifi or wire
  * SSID: `robot-hackathon-78b09`
  * Wifi-Password: Stored in RH Bitwarden collection
  * The router is a preconfigured GL.iNet AXT1800, the configuration to restore is here (always use latest!): [gDrive router backup](https://drive.google.com/drive/folders/19ZIPrv9bnL4JvYXGgUOYihp5AsKfzZPa?usp=drive_link) (RH internal only)
  * Check connectivity to Internet

### 🤖 Robot's

* Unpack all Robots
* Attach robots to power and start up
* Boot all Robots.
* Wait a couple of minutes...
* Connect your Laptop to Wifi `robot-hackathon-78b09`
* Check connection via ansile

  <details>
  <summary>Details</summary>

  At the infrastructure repo:

  ```bash
  % ansible-navigator run ./ping-all.yaml
  ...
  ```

  And let it dance via:

  ```bash
  % ansible-navigator run ./move-robots.yaml
  ...
  ```
  </details>

### OpenShift Edge Gateway

The Edge Gateway is a OCP SNO instance running on-premise in the same Wifi network as the robots. All connections from the hackathon OCP cluster to the robots go through it.

It is usually prepared and ready to use. Just connected the network wire to the router.

* Power on after Wifi is available
* Login into [OpenShift Console](https://console-openshift-console.apps.edge-gateway.lan/) and check all operators
  * User: kubeadmin
  * Password: *stored at bitwarden*
* Login into [OpenShift GitOps](https://openshift-gitops-server-openshift-gitops.apps.edge-gateway.lan/) and check everything is in synced
* Connect edge-date with data center

  <details>
  <summary>Run playbooks...</summary>

  At the [cloud-native-robotz-hackathon/infrastructure](https://github.com/cloud-native-robotz-hackathon/infrastructure) repo:

  ```bash
  cd infrastructure/automation/

  # Login into data center
  export KUBECONFIG=kubeconfig-data-center
  oc login -u admin --insecure-skip-tls-verify https://api.cluster-...

  # Login into edge gateway
  export KUBECONFIG=kubeconfig-edge-gateway
  oc login -u admin --insecure-skip-tls-verify https://edge-gateway.lan:6443

  # Optional: Adjust robot to team configuration
  vim inventory.yaml

  # Run playbook
  ansible-navigator run new-data-center.yaml  [-l <select location / specific robot>]
  ```

  Tip: If the playbook fails, this is propably due to a [bug](https://github.com/cloud-native-robotz-hackathon/infrastructure/issues/66) where the Interconnect Controller doesn't initalize correctly. You can restart the Interconnect Pod (skupper-site-controller-xxx...) in the openshift-operators project as a workaround. Once done, rerun the Ansible playbook.

  </details>

* Check all argocd applications at edge-gateway: <https://openshift-gitops-server-openshift-gitops.apps.edge-gateway.lan/>

## Assign team E-Mails to data center users

|E-Mail|User|
|---|---|
|team-1@example.com|team-1|
|team-2@example.com|team-2|
|team-3@example.com|team-3|
|team-4@example.com|team-4|
|team-5@example.com|team-5|
|team-6@example.com|team-6|
|team-7@example.com|team-7|
|team-8@example.com|team-8|
|team-9@example.com|team-9|

## Run the Hackathon

Have fun!
