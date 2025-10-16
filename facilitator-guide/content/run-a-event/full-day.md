---
title: Full day
hero: "Full day"
description: "..."
icon: material/run
---
# Full day

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
|GPU Worker Nodes|At least one for the Code Assistent|
|Enable workshop user interface|True|

### Check GitOps sync state

```shell
% oc get applications.argoproj.io -n openshift-gitops

```

## Setting up the environment on site

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

    At the infrastructure repo:

    ```bash
    % cd automation/
    % ansible-navigator run ./ping-all.yaml
    ```

    And let it dance via:

    ```bash
    % cd automation/
    % ansible-navigator run ./move-robots.yaml
    ```

### Conntect 🤖 Robot's to Data Center

Connect robots to data center, via Skupper.

At the [cloud-native-robotz-hackathon/infrastructure](https://github.com/cloud-native-robotz-hackathon/infrastructure) repo:

```shell
cd infrastructure/automation/

# Login into data center
export KUBECONFIG=kubeconfig-data-center
rm $KUBECONFIG
oc login -u admin --insecure-skip-tls-verify https://api.cluster-...

# Reset MicroShift at all robots
ansible-navigator run microshift-reset.yaml

# Setup skupper tunnels
ansible-navigator run skupper-tunnel.yaml

# Update the robot to team mapping
ansible-navigator run update-robot-to-team.yaml

# Finally check the different network connections:
ansible-navigator run check-environments.yaml
```

## Assign team E-Mails to users

At demo.redhat.com workshop interface, add the E-Mail addresses to the users:

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
