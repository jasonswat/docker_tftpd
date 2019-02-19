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

ADD scripts/* /
ADD templates/* /

RUN apt-get update && \
    apt-get install -y tftpd-hpa \
    inetutils-inetd \
    syslinux \
    vim \
    wget \
    gettext-base \
    lighttpd && \
    /build_menu.sh && \
    chmod u+x /*.sh && \
    apt-get -q clean

COPY tftpboot /tftpboot

VOLUME /tftpboot

RUN /download_netboot_images.sh && \
    /bin/sh -c "envsubst < /ubuntu.desktop.preseed.template > /var/www/html/ubuntu.desktop.preseed" && \
    /bin/sh -c "envsubst < /ubuntu.minimal.preseed.template > /var/www/html/ubuntu.minimal.preseed" && \
    /bin/sh -c "envsubst < /bootstrap.sh.template > /var/www/html/bootstrap.sh"

EXPOSE 69/udp 80/tcp

CMD ["/start.sh"]
