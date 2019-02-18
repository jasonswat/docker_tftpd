#!/bin/bash
/usr/sbin/lighttpd start 
/usr/sbin/in.tftpd --foreground --user tftp --secure /tftpboot
