#!/bin/bash
curl -O ${HTTP_SERVER}/ignition.json
sudo flatcar-install -d /dev/sda -i ignition.json
