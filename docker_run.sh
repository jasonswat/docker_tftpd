#docker run -it --rm -p 69:69 -v $(pwd):/var/lib/tftpboot --name tftpd drerik/tftpd
#docker run -it --rm -p 69:69 -v $(pwd):/var/lib/tftpboot --name ubuntu ubuntu:18.04 bash
#docker run -it --rm -p 69:69 --name tftpd_server jasonswat/tftpd_server:latest bash
docker run -d --rm -p 8080:80 -p 69:69/udp -p 8082:8080 --network=host --name tftpd_server jasonswat/tftpd_server:latest
