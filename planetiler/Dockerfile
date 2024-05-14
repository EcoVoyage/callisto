# syntax=docker/dockerfile:1.2

ARG BASE_IMAGE=ecovoyage/docker:20250501
FROM --platform=$BUILDPLATFORM $BASE_IMAGE as java

USER root

WORKDIR /code
RUN git clone https://github.com/onthegomap/planetiler.git planetiler

WORKDIR /code/planetiler/planetiler-openmaptiles
RUN git submodule init && git submodule update

WORKDIR /code/planetiler
RUN ./mvnw clean package
RUN ln -s /code/planetiler/planetiler-dist/target/planetiler-dist-0.7-SNAPSHOT-with-deps.jar /code/planetiler.jar

# RUN curl -LO https://github.com/onthegomap/planetiler/releases/latest/download/planetiler.jar

USER root
COPY startup.sh /usr/bin/startup.sh
RUN chmod +x /usr/bin/startup.sh
ENTRYPOINT ["startup.sh"]

WORKDIR /data
USER $MAMBA_USER
RUN mkdir -p /data/{planetiler,osm}
