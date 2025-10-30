---
title: Robot
hero: "Robot"
icon: material/robot
---

## Setup Robot from Scratch

This should only be neccessary with a new robot or when repairing/updating/replacing a robot.

### Install image and prepare robot

* Download image Ubuntu 22.04, Microshift 4.8 : <https://drive.google.com/file/d/139K2DgZnrxKIiAU-ErjdPXQHGoGOXubV>
* Write to SD Card, will be resized to SD Card size at first boot
    ```shell
    gunzip robot-hackathon-image.20240726.img.gz
    sudo dd if=robot-hackathon-image.20240726.img of=/dev/sdXXX status=progress
    ```
* The image will be resized to SD card size on first boot  
* The image is preconfigured with:
  * Automatic connection to the hackathon WIFI "robot-hackathon-78b09"
  * Robot hackathon SSH key (Bitwarden Collection)

### Network Setup

* If you want to configure another WIFI, attach a network cable and SSH into the robot (root / <PW> from Bitwarden collection) 
* For WLAN edit /etc/netplan/50-cloud-init.yaml and add your WLAN access point, reboot or run `netplan apply`. Config example:

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

To finish the configuration, run the Playbook `[automation/configure-robot.yaml](https://github.com/cloud-native-robotz-hackathon/infrastructure/blob/main/automation/configure-robot.yaml)` against the robot.

Example inventory:

```
---
all:
  vars:
    ansible_user: root
    ansible_ssh_private_key_file: ~/.ssh/robot-hackathon

robots:
  hosts:
    abcwarrior.lan:
      team: team-1
```

Run Ansible:

```
robot-hackathon/infrastructure/automation$ ansible-navigator run configure-robot.yaml -i myinventory.yaml 
```

And again to reset Microshift

```
robot-hackathon/infrastructure/automation$ ansible-navigator run microshift-reset.yaml -i myinventory.yaml 
```

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

### Microshift

Playbook microshift-reset.yaml is here [https://github.com/cloud-native-robotz-hackathon/infrastructure/tree/main/robot](https://github.com/cloud-native-robotz-hackathon/infrastructure/tree/main/robot)

* To reset Microshift: systemctl stop microshift.service; rm -rf /var/lib/microshift; systemctl start microshift.service
* To use oc locally: export KUBECONFIG=/var/lib/microshift/resources/kubeadmin/kubeconfig
* Or cat /var/lib/microshift/resources/kubeadmin/kubeconfig > ~/.kube/config

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