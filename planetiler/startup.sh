#!/bin/bash

# Check if sudo privileges are available
# if sudo -l &>/dev/null; then
#     USER_UID=$(id -u)
#     USER_GID=$(id -g)

#     sudo chown -R "$USER_UID:$USER_GID" /var/run/docker.sock
#     sudo chown -R "$USER_UID:$USER_GID" /home
# else
#     echo "Sudo privileges are not available."
# fi

mkdir -p /data/planetiler
cd /data/planetiler
java -Xmx4g -jar /code/planetiler.jar  --download --area=austria --output austria.pmtiles


# java -Xmx1g -jar /code/planetiler/target/planetiler-openmaptiles-0.7-SNAPSHOT.jar  --download --area=monaco

# java -jar /code/planetiler/planetiler-core/target/planetiler-core-0.7-SNAPSHOT.jar \
#   --input "austria-latest.osm.pbf" \
#   --output "austria-latest.pmtiles" \
#   --maxzoom 14 \
#   --minzoom 0 \
#   --bounds "bbox_of_austria" \
#   --download \
#   --optimize \
#   --tile-format pmtiles


sleep infinity