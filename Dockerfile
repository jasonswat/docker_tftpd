# tftpd
FROM ubuntu:16.04

MAINTAINER Jason Swatniki jason.swat@gmail.com

# http server path that hosts post configuration files
ARG HTTP_SERVER

# interfacename that should be configured for booting to e.g. eth0
ARG INTERFACE

RUN apt-get update && \
    apt-get install -y tftpd-hpa inetutils-inetd syslinux wget && \
    apt-get -q clean

COPY tftpboot /tftpboot

ADD scripts/* /

RUN chmod u+x /*.sh && \
    /download_netboot_images.sh && \
    /build_menu.sh

VOLUME /tftpboot

EXPOSE 69/udp

CMD /usr/sbin/in.tftpd --foreground --user tftp --secure /tftpboot
