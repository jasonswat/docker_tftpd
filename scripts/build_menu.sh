#!/bin/bash

declare -a ubuntu_distros=("xenial" "cosmic")

build_flatcar_menu(){
    tee /tftpboot/flatcar/flatcar.menu <<EOF
LABEL 5
        MENU LABEL FlatcarOS (64-bit)
        KERNEL flatcar/flatcar_production_pxe.vmlinuz
        INITRD flatcar/flatcar_production_pxe_image.cpio.gz
        APPEND flatcar.autologin=tty1 cloud-config-url=${HTTP_SERVER}/bootstrap.sh
EOF
sed -i -e "s|%HTTP_SERVER%|${HTTP_SERVER}|g" /tftpboot/pxelinux.cfg/default
}

build_ubuntu_menu(){
  for ((distro = 0; distro < ${#ubuntu_distros[@]}; ++distro))
  do
    label=$(( ${distro} + 1 ))
    tee -a /tftpboot/ubuntu/ubuntu.menu <<EOF
LABEL ${label}
        MENU LABEL Ubuntu ${ubuntu_distros[${distro}]} (64-bit) Desktop Install
        KERNEL ubuntu/${ubuntu_distros[${distro}]}/amd64/linux
        APPEND initrd=ubuntu/${ubuntu_distros[${distro}]}/amd64/initrd.gz auto locale=en_US.UTF-8 keyboard-configuration/layoutcode=us url=${HTTP_SERVER}/ubuntu.desktop.preseed netcfg/get_hostname=${HOSTNAME} vga=0x317
        TEXT HELP
        Boot the Ubuntu ${ubuntu_distros[${distro}]} 64-bit Unattended Desktop Install
        ENDTEXT
LABEL ${label}.5
        MENU LABEL Ubuntu ${ubuntu_distros[${distro}]} (64-bit) Minimal Install
        KERNEL ubuntu/${ubuntu_distros[${distro}]}/amd64/linux
        APPEND initrd=ubuntu/${ubuntu_distros[${distro}]}/amd64/initrd.gz auto locale=en_US.UTF-8 keyboard-configuration/layoutcode=us   ↪  url=${HTTP_SERVER}/ubuntu.minimal.preseed netcfg/get_hostname=${HOSTNAME} vga=0x317
        TEXT HELP
        Boot the Ubuntu ${ubuntu_distros[${distro}]} 64-bit Unattended Minimal Install
        ENDTEXT
EOF
  done
}
build_flatcar_menu
build_ubuntu_menu
