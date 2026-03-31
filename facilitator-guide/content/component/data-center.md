---
title: Data Center
hero: "Data Center"
description: "Provision the OpenShift data center on Red Hat Demo Platform, optional robot auto-registration, and console branding."
icon: material/server
---

## Overview

The **data center** is the hosted OpenShift environment for the hackathon. Facilitators provision it through **Red Hat Demo Platform** (RHDP), optionally enable **robot auto-registration** during order, and can customize console login branding via GitOps in this repository.

## Provision on Red Hat Demo Platform

1. Open the [RHDP catalog](https://catalog.demo.redhat.com/catalog/babylon-catalog-prod?search=robot) and search for **robot**, or use the [Cloud Native Robot Hackathon](https://catalog.demo.redhat.com/catalog?search=Cloud+Native+Robot+Hackathon&item=babylon-catalog-prod%2Fsandboxes-gpte.cloud-native-robot.prod) catalog entry directly.
2. Complete the order wizard using the field guidance in [Full day — Order OpenShift Data Center env](../run-a-event/full-day.md#order-openshift-data-center-env).

![](demo-portal.png)

## Robot auto registration (optional)

In the provisioning form, enable **robot auto registration** if teams should register robots against a GitHub repo automatically:

![](demo-robot-auto-registration.png)

Values depend on your teams, robot names, and the associated **robot-auto-register** repository. For setup details and examples, see **[Robot Auto Register](../robot/auto-register.md)**.

Example repository URL:

* <https://github.com/cloud-native-robotz-hackathon/robot-auto-register-78b09.git>

## Customize OpenShift console branding

Branding lives under **`datacenter/cluster-configuration/`** in the [infrastructure](https://github.com/cloud-native-robotz-hackathon/infrastructure) repo. Work from a clone of that repository on your machine.

### Login and OAuth HTML templates

1. Log in to the **data center** OpenShift cluster as an admin (see [Full day](../run-a-event/full-day.md) for ordering and access).
2. Edit the HTML sources in  
   `datacenter/cluster-configuration/base/namespace/openshift-config/Secret/`  
   — `errors-template.html`, `login-template.html`, and `providers-template.html`.
3. From that **`Secret/`** directory, run:

   ```bash
   ./update-secrets.sh
   ```

### Console logo (light / dark)

1. In  
   `datacenter/cluster-configuration/base/namespace/openshift-config/ConfigMap/`  
   replace or edit **`openshift-robot-black.png`** and **`openshift-robot-white.png`** as needed (for example export from GIMP as PNG).
2. From that **`ConfigMap/`** directory, run:

   ```bash
   ./update-configmap.sh
   ```

### Publish and sync

1. Commit and push your changes.
2. In **Argo CD**, refresh and sync the **`cluster-configuration`** application so the cluster picks up the updates.
