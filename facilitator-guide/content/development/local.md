---
title: Local Development
icon: material/laptop
---

# Local Development

Creating a local setup to test the assets.

You will need :

 * A Robot Hackathon Cluster at demo.redhat.com (Data Center)
 * One Robot

## Prepare the robot

### Connect Robot to your Network

* Connect to wired network & findout ip address
* Connect via SSH (wire) to robot
* The robot private keyfile needs to be named ~/.ssh/robot-hackathon
* You will want to connect the robot via Wifi now
  * If you have Slate Router, you can connect it the same way this is done for actual workshops
  * Alternatively you can connect the robot directly to another wifi router
  * Note down the IP address

### Update inventory

The default workshop `automation/inventory.yaml` looks like this:

From
```yaml
---
all:
  vars:
    ansible_user: root
    ansible_ssh_private_key_file: ~/.ssh/robot-hackathon

datacenter:
  hosts:
    🏢-datacenter:
      ansible_connection: local

robots:
  hosts:
    gort:
      ansible_host: 192.168.8.105
      team: team-1
    t-1000:
      ansible_host: 192.168.8.106
      team: team-2
    marvin:
      ansible_host: 192.168.8.104
      team: team-3
    c3po:
      ansible_host: 192.168.8.109
      team: team-4
    r2d2:
      ansible_host: 192.168.8.108
      team: team-5
    marc13:
      ansible_host: 192.168.8.107
      team: team-6
    data:
      ansible_host: 192.168.8.103
      team: team-7
    terminator:
      ansible_host: 192.168.8.100
      team: team-8
    ultron:
      ansible_host: 192.168.8.102
      team: team-9
    # robocop:
    #   team: team-3

```

For your local setup, copy the file to `automation/local_inventory.yaml` and modify with the name and IP of your robot.

e.g.:

```yaml
---
all:
  vars:
    ansible_user: root
    ansible_ssh_private_key_file: ~/.ssh/robot-hackathon

datacenter:
  hosts:
    🏢-datacenter:
      ansible_connection: local
robots:
  hosts:
    number5:
      ansible_host: 192.168.8.110
      team: team-1
```

### Reset MicroShift at the Robot (Only required once)

At the [cloud-native-robotz-hackathon/infrastructure](https://github.com/cloud-native-robotz-hackathon/infrastructure) repo:

```bash
cd automation
ansible-navigator run ./microshift-reset.yaml -i ./local_inventory.yaml
```

## Bring Data Center & Robot together

At the [cloud-native-robotz-hackathon/infrastructure](https://github.com/cloud-native-robotz-hackathon/infrastructure) repo:

### Create connection between data-center and local env

```bash
cd automation
export KUBECONFIG=$(pwd)/kubeconfig-data-center
oc login -u admin --insecure-skip-tls-verify https://api.cluster-...

# Run
ansible-navigator run ./skupper-tunnel.yaml -i ./local_inventory.yaml

# Connect robots and teams / ArgoCD

ansible-navigator run ./update-robot-to-team.yaml -i ./local_inventory.yaml
```

## Testing the Robot Calls

You can test the calls bei adding the hostname or ip of the robot as user_key.

Now test the API Connection from the DC Cluster, for example from the WebTerminal (make sure to replace data your user_key) :

```bash
curl http://api.hub-controller.svc.cluster.local./robot/status?user_key=your-robot

curl -X 'POST' 'http://api.hub-controller.svc.cluster.local./robot/forward/1' -H 'accept: text/html' -H 'Content-Type: application/x-www-form-urlencoded' -d 'user_key=your-robot'
```

## Custom user_key Mapping

If you want to map another other user_key to the robot you can set up a mapping:

In your Data Center open the ConfigMap `robot-mapping-configmap` in namespace `hub-controller` and edit the Roboname (user_key) mapping (e.g. data) to your Robot hostname (e.g. data.lan)

Restart the Hubcontroller Pod.

