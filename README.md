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

5. Update your DHCP server options to point to the new tftpserver:

```
Additional DNSMasq Options
dhcp-boot=pxelinux.0,,"192.168.10.150"
```

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
