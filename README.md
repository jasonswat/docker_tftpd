# Dockerized tftpd server

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
