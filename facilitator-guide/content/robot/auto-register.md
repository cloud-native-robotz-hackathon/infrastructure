---
title: Robot Auto Register
linktitle: Robot Auto Register
---

## Flow

![](auto-register-flow.drawio)

### How to setup your own `robot-auto-register` repository

Create new private repo, for example `robot-auto-register-78b09`

Create Fine-grained token: https://github.com/settings/personal-access-tokens

![](token-permissions.png)


#### Example curl commands

```
export TOKEN="github_pat_xxx"

curl -H "Authorization: token $TOKEN" \
    https://raw.githubusercontent.com/cloud-native-robotz-hackathon/robot-auto-register-78b09/main/terminator
```


#### Run `configure-robot.yml` manualy

```shell
export RCS_HUBCONTROLLER_USER=admin
export RCS_HUBCONTROLLER_PASSWORD=xxx
export RCS_HUBCONTROLLER_URL=https://web-hub-controller.apps.cluster-kxpkk.kxpkk.sandbox3582.opentlc.com
cd /opt/robot-config-service/ansible
ansible-playbook -i inventory configure-robot.yml
```