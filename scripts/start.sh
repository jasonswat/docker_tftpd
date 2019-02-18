#!/bin/bash
/usr/sbin/lighttpd -D -f /etc/lighttpd/lighttpd.conf
/usr/sbin/in.tftpd --foreground --user tftp --secure /tftpboot
