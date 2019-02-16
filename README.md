# Dockerized tftpd server

This is a work in progress

testing udp port connection with netcat:

```
nc -uvz localhost 69
```

Added these options to my dd-wrt router:

```
Additional DNSMasq Options
dhcp-boot=pxelinux.0,,"192.168.10.150"
```
