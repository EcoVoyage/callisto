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

java -Xmx4g -jar /code/planetiler.jar  --download True --download_dir=/data/osm --area=austria --output /data/planetiler/austria.pmtiles --osm-path=/data/osm/austria.osm.pbf

# java -Xmx4g -jar /code/planetiler/planetiler-dist/target/planetiler-dist-0.7-SNAPSHOT-with-deps.jar  --download True --download_dir=/data/osm --area=austria --output /data/planetiler/austria.pmtiles --osm-path=/data/osm/austria.osm.pb

sleep infinity