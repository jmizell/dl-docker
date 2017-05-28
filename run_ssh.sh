#!/bin/bash

# start ssh server
/usr/sbin/sshd -E /var/log/sshd.log -D &

# update password if set
if [ ! -z "$SHELL_PASSWORD" ]; then
    echo "root:${SHELL_PASSWORD}" | chpasswd
fi

# start ngrok if set
if [ ! -z "$NGROK_AUTH" ]; then
  /usr/local/bin/ngrok tcp 22 -authtoken=$NGROK_AUTH -log /var/log/ngrok.log >> /var/log/ngrok.log &
  sleep 5s
  echo "import requests
for tunnel in requests.get('http://localhost:4040/api/tunnels').json()['tunnels']:
    print(\"TUNNEL STARTED: %s\"  % tunnel['public_url'])" | python >> /var/log/ngrok.log
else
  touch /var/log/ngrok.log
fi

# start tmux session
/usr/local/bin/tmux_collab.sh

# display logs
tail -f /var/log/ngrok.log /var/log/sshd.log
