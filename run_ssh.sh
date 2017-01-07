#!/bin/bash

if [ ! -z "$SHELL_PASSWORD" ]; then
    echo "root:${SHELL_PASSWORD}" | chpasswd
fi

if [ -z "$NGROK_AUTH" ]; then
    echo "Ngrok auth token required"
    exit 1
fi

/usr/sbin/sshd -E /var/log/sshd.log -D &
/usr/local/bin/ngrok tcp 22 -authtoken=$NGROK_AUTH -log /var/log/ngrok.log >> /var/log/ngrok.log &
tail -f /var/log/ngrok.log /var/log/sshd.log