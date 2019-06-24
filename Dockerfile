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

COPY tftpboot /tftpboot

RUN chmod u+x /*.sh && \
    apt-get update && \
    apt-get install -y tftpd-hpa \
    inetutils-inetd \
    grub-ipxe \
    syslinux \
    vim \
    wget \
    gettext-base \
    lighttpd && \
    apt-get -q clean

RUN /download_netboot_images.sh && \
    /build_menu.sh && \
    /bin/sh -c "envsubst < /ubuntu.desktop.preseed.template > /var/www/html/ubuntu.desktop.preseed" && \
    /bin/sh -c "envsubst < /ubuntu.minimal.preseed.template > /var/www/html/ubuntu.minimal.preseed" && \
    /bin/sh -c "envsubst < /bootstrap.sh.template > /var/www/html/bootstrap.sh"

# install matchbox for coreos and ignition
RUN wget https://github.com/coreos/matchbox/releases/download/v0.8.0/matchbox-v0.8.0-linux-amd64.tar.gz && \
    tar -xzf matchbox-v0.8.0-linux-amd64.tar.gz && \
    rm matchbox-v0.8.0-linux-amd64.tar.gz && \
    cp matchbox-v0.8.0-linux-amd64/matchbox /usr/local/bin && \
    mkdir -p /var/lib/matchbox/assets && \
    rm -rf ./matchbox-v0.8.0-linux-amd64
 
VOLUME /tftpboot
EXPOSE 69/udp 80/tcp 8080/tcp

CMD ["/start.sh"]
