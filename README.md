# Dockerized tftpd server
Dockerized tftpd server for PXE boot of ubuntu 14, 16, and coreos. Also an http server for config files. Added matchbox service for CoreOS ignition.

### Building the container

1. Updated the variables file

2. Move the secrets.example to secrets and update 

3. Build the container

```
make build
```

4. Run the container

```
make docker/run
```

5. Update your DHCP server options to point to the new tftpserver (swap 1.1.1.1 with the ip of the tftp server):

DNSMasq options for PXE Boot
```
dhcp-boot=pxelinux.0,,1.1.1.1
```

DNSMasq Options for UEFI Boot with grub2
```
dhcp-boot=grubnetx64.efi.signed,,1.1.1.1
```

### Matchbox

Info on network setup: https://coreos.com/matchbox/docs/latest/network-setup.html

Added this the the tftp server pxelinux.cfg/default 

MATCHBOX_SERVER environment variable for http://<matchbox_server>:8082

```
LABEL iPXE CoreOS Install
KERNEL ipxe.lkrn
APPEND dhcp && chain %MATCHBOX_SERVER%/boot.ipxe
```

ipxe.lkrn is installed in the Docker build see scripts/download_netboot_images.sh 

### Ports

These are the ports that are exported on the host:

| service | protocol | docker port | host port |
| tftpd | udp | 69 | 69 |
| light_http | tcp | 80 | 8080 |
| matchbox | tcp 8080 | 8082 |
| matchbox gRPC | tcp 8081 | 8081 |

### Troubleshooting

testing udp port connection with netcat:

```
nc -uvz localhost 69
```

Testing tftp server:

```
tftp <ip_address>
tftp> get test.txt
tftp> quit
cat test.txt
```

If running on CoreOS make isn't included, you can build make with this command:

```
docker run -it --rm -v /opt/bin:/out ubuntu:16.04 bash -c "apt-get update && apt-get -y install make && cp /usr/bin/make /out/make"
```
