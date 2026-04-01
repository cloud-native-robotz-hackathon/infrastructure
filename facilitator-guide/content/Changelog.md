---
title: Changelog
hero: "Changelog"
description: "..."
icon: material/receipt-text-clock
---

# Changelog

## v3 - 2026-04-01

* The most significant change is the new robot auto register service at the data center. There is no need anymore to run playbooks. Just Deploy demo env and boot the robot - magic happends and robot is connect to the data center. If you have a robot at home, please re-install the robot based in the new robot image (20260218) and information in the lab guide. (Links provided later)

* Demo env / data center is upgraded to OpenShift 4.20 & Operators #223
* We have now an awesome robot dashboard and leaderboard board.
* A couple facilitator guide updates
* Workbench Image is updated to Python 3.11 #191
* Fixed: Demo env is sometimes broken after stop & start #206
* Not used in the lab but available, a Jupyter Notebook uses the webcam of the laptop, and try to detect the fedora. #135

## v2.1 - 2025-11-06 

* [True SSO Login for Sites where possible](https://github.com/cloud-native-robotz-hackathon/infrastructure/issues/198)

## v2 - 2025-10-24

* [Include a LLM code assistent in dev spaces](https://github.com/cloud-native-robotz-hackathon/infrastructure/issues/154)
* [Add Label Studio installation to RHDP CI](https://github.com/cloud-native-robotz-hackathon/infrastructure/issues/202)
* [Add new facilitator-guide](https://github.com/cloud-native-robotz-hackathon/infrastructure/issues/200) - <https://cloud-native-robotz-hackathon.github.io/infrastructure/>
* [Remove export ROBOT_NAME to make it easier](https://github.com/cloud-native-robotz-hackathon/infrastructure/issues/130)
* Fix self-signed certificate issue during provisioning
* Fix password management - remove hard-coded default password.

## Start of the Changelog

Unfortunately, we started really late with the changelog.
