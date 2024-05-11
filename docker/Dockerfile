# syntax=docker/dockerfile:1.2

ARG BASE_IMAGE=callisto-micromamba
FROM --platform=$BUILDPLATFORM $BASE_IMAGE AS fetch

USER root

RUN --mount=type=cache,target=/var/cache/apt,id=apt-docker apt-get update && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

RUN curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
    $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

RUN --mount=type=cache,target=/var/cache/apt,id=apt-docker apt-get update && apt-get install -y docker-ce docker-ce-cli containerd.io

