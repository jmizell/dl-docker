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
/usr/local/bin/tmux_collab.sh

sleep 5s

echo "import requests
for tunnel in requests.get('http://localhost:4040/api/tunnels').json()['tunnels']:
    print(\"TUNNEL STARTED: %s\"  % tunnel['public_url'])" | python >> /var/log/ngrok.log

tail -f /var/log/ngrok.log /var/log/sshd.log
