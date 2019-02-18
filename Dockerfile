# tftpd
FROM ubuntu:16.04

MAINTAINER Jason Swatniki jason.swat@gmail.com

ARG TIME_ZONE
ARG HTTP_SERVER
ARG HOSTNAME
ARG PARTMAN_GUIDED_SIZE
ARG CLOUD_CONFIG
ARG DEVICE
ARG SSH_AUTHORIZED_KEY
ARG USERNAME
ARG USER_PASSWORD
ARG ROOT_PASSWORD

RUN apt-get update && \
    apt-get install -y tftpd-hpa \
    inetutils-inetd \
    syslinux \
    wget \
    gettext-base \
    lighttpd && \
    apt-get -q clean

COPY tftpboot /tftpboot

ADD scripts/* /
ADD templates/* /

VOLUME /tftpboot

RUN chmod u+x /*.sh && \
    /download_netboot_images.sh && \
    /build_menu.sh && \
    /bin/sh -c "envsubst < /ubuntu.desktop.preseed.template > /var/www/html/ubuntu.desktop.preseed" && \
    /bin/sh -c "envsubst < /ubuntu.minimal.preseed.template > /var/www/html/ubuntu.minimal.preseed" && \
    /bin/sh -c "envsubst < /bootstrap.sh.template > /var/www/html/bootstrap.sh"

EXPOSE 69/udp 80/tcp

CMD ["sh", "-c", "/usr/sbin/lighttpd -D -f /etc/lighttpd/lighttpd.conf && /usr/sbin/in.tftpd --foreground --user tftp --secure /tftpboot"]
