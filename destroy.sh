#!/bin/bash

# Network name
NETWORK_NAME="callisto"

# Get IDs of all containers connected to the specified network
container_ids=$(docker network inspect $NETWORK_NAME --format '{{range .Containers}}{{.Name}} {{end}}')

# Stop each container found
for container in $container_ids; do
    echo "Stopping container: $container"
    docker stop $container
done

echo "All containers connected to the network $NETWORK_NAME have been stopped."

docker network rm $NETWORK_NAME

rm jupyterhub-proxy.pid jupyterhub.sqlite jupyterhub_cookie_secret

docker rm -f jupyter-admin