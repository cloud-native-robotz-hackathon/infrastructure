---
title: Robot - GiPiGo
hero: "Robot - GiPiGo"
icon: material/robot
---

## BOM

|Name|Example Shop Link|
|---|---|
|**GoPiGo Kit**|<https://gopigo.io/gopigo/>|
|**Raspberry Pi 4 B - 8 GB Memory Version**|<https://www.berrybase.de/en/raspberry-pi-4-computer-modell-b-8gb-ram>|
|**Raspberry Pi Camera Modules v2**|<https://www.berrybase.de/en/raspberry-pi-camera-module-8mp-v2>|
|**SD Card**<br/> * 128 GB recommended<br/> * 64 GB minimum |<https://www.berrybase.de/en/sandisk-extreme-microsdxc-a2-uhs-i-u3-v30-190mb-s-speicherkarte-adapter-128gb>
|**3D Printed Camera Mounts**<br>🛠️ custom, **you have to print it.**|<https://github.com/cloud-native-robotz-hackathon/3dprint-parts>|
|**WiFi Router**, optional but recommended|<https://store-eu.gl-inet.com/collections/new-arrivals/products/flint-3-gl-be9300-tri-band-wi-fi-7-home-router>

It is roughly 350 Euro per robot + 200 Euro the optional WiFi router.

## Pictures

![](robot-a.JPG){ width="150" }
![](robot-b.JPG){ width="150" }
![](robot-c.JPG){ width="150" }
![](robot-d.JPG){ width="150" }

## Setup Robot from Scratch

This should only be neccessary with a new robot or when repairing/updating/replacing a robot.

### Install image and prepare robot

* Download image Ubuntu 22.04, Microshift 4.8 : <https://drive.google.com/file/d/139K2DgZnrxKIiAU-ErjdPXQHGoGOXubV>
* Write to SD Card, will be resized to SD Card size at first boot
    ```shell
    gunzip robot-hackathon-image.20260212.img.gz
    sudo dd if=robot-hackathon-image.20260212.img of=/dev/sdXXX status=progress
    ```
* The image will be resized to SD card size on first boot  
* The image is preconfigured with:
  * Automatic connection to the hackathon WIFI "robot-hackathon-78b09", password in Bitwarden collection.
  * Robot hackathon SSH key (Bitwarden Collection)
* Adjust inventory `automation/inventory.yaml`, add the robot to `robots`, for example:
  ```yaml
  robots:
  hosts:
    ....
    <NAME OF THE ROBOT>:
      team: team-X
      ansible_host: 192.168.8.xxx
  ```
* Run playbook to configure the robot
  ```
  ansible-navigator run ./configure-robot.yaml -l <NAME OF THE ROBOT>
  ```
* Login into the robot and reboot.
* Now the boot screen should look like this:
  ![](bootscreen.png)

### Network Setup

* The robot will automatically connect to a WIFI with the SSID and key/password listed above.
* If you want to configure another WIFI, attach a network cable and SSH into the robot (root / <PW> from Bitwarden collection) or mount the SD card.
* Edit /etc/netplan/50-cloud-init.yaml and add your WIFI access point, reboot or run `netplan apply`. Config example:

    ```
    network:
        ethernets:
            eth0:
                dhcp4: true
                optional: true
        version: 2
        Wifis:
            wlan0:
            access-points: 
            "robot-hackathon-78b09":
                password: "PASSWORD"
            "otherssid":
                password: "<PASSWORD>"
            dhcp4: true
    ```

### Finish configuration

To finish the configuration, you have to run a number of Playbooks against the robot(s).

Clone the GitHub repo [infrastructure](https://github.com/cloud-native-robotz-hackathon/infrastructure.git).

```
git clone https://github.com/cloud-native-robotz-hackathon/infrastructure.git
```

Example inventory:

```
---
all:
  vars:
    ansible_user: root
    ansible_ssh_private_key_file: ~/.ssh/robot-hackathon

robots:
  hosts:
    abcwarrior:
      team: team-1
```

The robot name has to resolve of course. If not, use the IP address.

#### Robot Base Config

The Playbook [automation/configure-robot.yaml](https://github.com/cloud-native-robotz-hackathon/infrastructure/blob/main/automation/configure-robot.yaml):

-  Ensures the robot is running image robot-hackathon-image.20260212 before proceeding.
- Stops and removes the deprecated edgehub service and its associated files.
- Clones and installs edge-controller in a specified version from GitHub to /opt/edge-controller.
- Configures, enables, and restarts the edge-controller systemd unit and makes sure it runs.
- Updates /etc/issue (login banner), /etc/hosts, and sets the system hostname to match the inventory.

Run it:

```
robot-hackathon/infrastructure/automation$ ansible-navigator run configure-robot.yaml -i myinventory.yaml 
```

After the Playbook has run, reboot the robot.

#### Microshift Reset

The Playbook [automation/microshift-reset.yaml](https://github.com/cloud-native-robotz-hackathon/infrastructure/blob/main/automation/microshift-reset.yaml) performs a destructive reset and fresh configuration of MicroShift on the robot. Run it now and whenever the IP or hostname changes:

- Calculates current disk usage and aborts the process if it exceeds a predefined disk_limit.
- Stops the microshift.service and deletes all existing data in /var/lib/microshift.
- Updates /etc/hosts with the robot's local IP and sets the cluster domain in the MicroShift config.
- Prepares a kustomization.yaml and a specific Pod manifest (pin-triton.yaml) to pin a Triton server image in the local registry.
- Restarts MicroShift and waits for the system to generate a new kubeconfig file.
- Prepares the kubeconfig
- Waits for the API to respond on port 6443 and provides the exact command needed to export the KUBECONFIG environment variable.

Run it:

```
robot-hackathon/infrastructure/automation$ ansible-navigator run microshift-reset.yaml -i myinventory.yaml 
```

#### Optional: Install Self-Register Service

Clone the GitHub repo [robot-config-service](https://github.com/cloud-native-robotz-hackathon/robot-config-service.git).

```
git clone https://github.com/cloud-native-robotz-hackathon/robot-config-service.git
```

Follow the instructions in the readme to install the service to the robot(s) using Ansible.

After the Playbook has run, reboot the robot to activate the self-registration.

### Camera Setup (Raspi camera v2)

Playbook camera-test.yaml is here [https://github.com/cloud-native-robotz-hackathon/infrastructure/tree/main/robot](https://github.com/cloud-native-robotz-hackathon/infrastructure/tree/main/robot)

* Cable orientation: blue “bar” on cable oriented to USB ports, blue bar at camera away from lens
* Test camera is detected: vcgencmd get_camera
* Script to test image acquisition

```
  import cv2
  # open camera
  cap = cv2.VideoCapture('/dev/video0', cv2.CAP_V4L)

  # set dimensions
  cap.set(cv2.CAP_PROP_FRAME_WIDTH, 2560)
  cap.set(cv2.CAP_PROP_FRAME_HEIGHT, 1440)

  # take frame
  ret, frame = cap.read()
  # write frame to file
  cv2.imwrite('/root/ramfilesystem/image.jpg', frame)
  # release camera
  cap.release()
```

### Triton

[https://docs.nvidia.com/deeplearning/triton-inference-server/user-guide/docs/getting\_started/quickstart.html](https://docs.nvidia.com/deeplearning/triton-inference-server/user-guide/docs/getting_started/quickstart.html)

Check model
`curl --location --request GET 'http://localhost:8000/v2/models/densenet_onnx/stats'`

## Bill of materials

|#|Item|price in Euro|Example Shop|
|---|---|---|---|
|1|GoPiGo Kits|178|<https://gopigo.io/gopigo/>|
|2|Raspberry Pi 4 B - 8 GB Memory Version|79|<https://www.berrybase.de/raspberry-pi-4-computer-modell-b-8gb-ram>|
|3|Raspberry Pi Camera Modules v2|17|<https://www.berrybase.de/raspberry-pi-camera-module-8mp-v2>|
|4|3D Printed Camera Mounts Custom, you have to print it.|30|<https://github.com/cloud-native-robotz-hackathon/3dprint-parts>|