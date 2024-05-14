# syntax=docker/dockerfile:1.2

ARG BASE_IMAGE=ecovoyage/docker:20250501
FROM --platform=$BUILDPLATFORM $BASE_IMAGE as osmtools

USER root

COPY --chown=$MAMBA_USER:$MAMBA_USER apt.txt /opt/conda/environments/apt.txt
RUN --mount=type=cache,target=/var/cache/apt,id=apt-jupyterhub apt-get update && xargs apt-get install -y < /opt/conda/environments/apt.txt

WORKDIR /code

RUN git clone https://github.com/felt/tippecanoe.git  && \
    cd /code/tippecanoe && \
    make && \
    make install


USER $MAMBA_USER

WORKDIR /data
CMD ["sleep", "infinity"]
