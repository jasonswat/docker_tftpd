#!/bin/bash
#
curl -O ${HTTP_SERVER}/cloud-config.yml
sudo coreos-install -d /dev/sda -c cloud-config.yaml coreos.autologin=tty1
