---
title: Robot Auto Register
linktitle: Robot Auto Register
---

## Flow

![](auto-register-flow.drawio)

### How to setup an `robot-auto-register` repository

Create new private repo, for example `robot-auto-register-78b09`

Create Fine-grained token: https://github.com/settings/personal-access-tokens

![](token-permissions.png)


#### Example curl commands

```
export TOKEN="github_pat_xxx"

curl -H "Authorization: token $TOKEN" \
    https://raw.githubusercontent.com/cloud-native-robotz-hackathon/robot-auto-register-78b09/main/terminator
```