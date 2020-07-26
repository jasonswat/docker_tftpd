docker run -d --rm \
  -p 8080:80 \
  -p 69:69/udp \
  -p 8082:8080 \
  -p 8081:8081 \
  -e MATCHBOX_RPC_ADDRESS="0.0.0.0:8081" \
  -e MATCHBOX_ASSETS_PATH="/tftpboot/coreos/" \
  -v "${PWD}/tls:/etc/matchbox" \
  --name tftpd_server \
  jasonswat/tftpd_server:latest
