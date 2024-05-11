#!/bin/bash
cd /code
git clone https://github.com/graphhopper/graphhopper.git

cd graphhopper
git checkout master
mvn clean install -DskipTests
# curl -LO http://download.geofabrik.de/europe/germany/berlin-latest.osm.pbf
# java -Ddw.graphhopper.datareader.file=berlin-latest.osm.pbf -jar web/target/graphhopper-web-*.jar server config-example.yml
