#!/bin/bash

/usr/sbin/lighttpd start
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to lighttpd: $status"
  exit $status
fi

/usr/sbin/in.tftpd --user tftp --secure /tftpboot
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start tftpd: $status"
  exit $status
fi

while sleep 60; do
  ps aux |grep lighttpd |grep -q -v grep
  LIGHTTPD=$?
  ps aux |grep in.tftpd |grep -q -v grep
  TFTPD=$?
  if [ $LIGHTTPD -ne 0 -o $TFTPD -ne 0 ]; then
    echo "One of the processes has exited."
    exit 1
  fi
done
