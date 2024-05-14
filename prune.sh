#!/bin/bash

# Get a list of all networks and their connected containers
networks=$(docker network inspect $(docker network ls -q) --format '{{json .}}')

# Get a list of all running container IDs
all_containers=$(docker ps -aq)

# Iterate over each container and check if it's connected to any network
for container in $all_containers; do
    # Check if the current container ID appears in the network information
    if echo "$networks" | jq --arg CONTAINER "$container" '.[].Containers | to_entries[] | .value.Name' | grep -q "$container"; then
        echo "Container $container is connected to a network."
    else
        echo "Container $container is NOT connected to any network. Removing..."
        docker rm -f $container
    fi
done
