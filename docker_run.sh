docker run -d --rm \
  -p 8080:80 \
  -p 69:69/udp \
  -p 8082:8080 \
  -p 8081:8081 \
  -e SAN="DNS.1:core,IP.1:192.168.10.150" \ 
  -e MATCHBOX_ASSETS_PATH="/tftpboot/coreos/" \
  -v "${PWD}/tls:/etc/matchbox" \
  --name tftpd_server \
  jasonswat/tftpd_server:latest
