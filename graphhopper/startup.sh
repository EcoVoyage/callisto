#!/bin/bash

# Check if sudo privileges are available
if sudo -l &>/dev/null; then
    USER_UID=$(id -u)
    USER_GID=$(id -g)

    sudo chown -R "$USER_UID:$USER_GID" /var/run/docker.sock
    sudo chown -R "$USER_UID:$USER_GID" /home
else
    echo "Sudo privileges are not available."
fi
# Loop indefinitely
while true; do
    sleep 1
done
