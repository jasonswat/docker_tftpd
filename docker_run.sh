#docker run -d --name ubuntu ubuntu:16.04 "sleep 60"
     #-p 2069:69/udp \
     #-v ${PWD}/scripts/tftpd_server_setup.sh:/scripts/tftpd_server_setup.sh \
#docker run -it --rm -p 69:69 -v $(pwd):/var/lib/tftpboot --name tftpd drerik/tftpd
#docker run -it --rm -p 69:69 -v $(pwd):/var/lib/tftpboot --name ubuntu ubuntu:18.04 bash
#docker run -it --rm -p 69:69 --name tftpd_server jasonswat/tftpd_server:latest bash
docker run -d --rm -p 192.168.1.22:69:69/udp --network=host --name tftpd_server jasonswat/tftpd_server:latest
