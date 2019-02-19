#!/bin/bash

declare -a ubuntu_distros=("cosmic" "xenial")

download_coreos(){
  wget http://stable.release.core-os.net/amd64-usr/current/coreos_production_pxe.vmlinuz -P /tftpboot/coreos
  wget http://stable.release.core-os.net/amd64-usr/current/coreos_production_pxe_image.cpio.gz -P /tftpboot/coreos
}

download_ubuntu(){
  for distro in "${ubuntu_distros[@]}"
  do
    url="http://archive.ubuntu.com/ubuntu/dists/${distro}-updates/main/installer-amd64/current/images/netboot/netboot.tar.gz"
    wget -qO- ${url} | tar -xzv
    if [ "${distro}" = "cosmic" ]; then
      cp ./ubuntu-installer/amd64/pxelinux.0 /tftpboot/
      cp ./ubuntu-installer/amd64/boot-screens/libcom32.c32 /tftpboot/
      cp ./ubuntu-installer/amd64/boot-screens/libutil.c32 /tftpboot/
      cp ./ubuntu-installer/amd64/boot-screens/ldlinux.c32 /tftpboot/
      cp ./ubuntu-installer/amd64/boot-screens/vesamenu.c32 /tftpboot/
    fi
    mv ./ubuntu-installer/amd64/initrd.gz /tftpboot/ubuntu/${distro}/amd64
    mv ./ubuntu-installer/amd64/linux /tftpboot/ubuntu/${distro}/amd64
    rm -rf ./ubuntu-installer
  done
}

download_coreos
download_ubuntu
