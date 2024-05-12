# syntax=docker/dockerfile:1.2

ARG BASE_IMAGE=debian:bookworm-slim
FROM --platform=$BUILDPLATFORM $BASE_IMAGE AS fetch
ARG VERSION=1.5.8

RUN --mount=type=cache,target=/var/cache/apt,id=apt-micromamba-fetch apt-get update && apt-get install -y --no-install-recommends bzip2 ca-certificates curl
RUN if [ "$BUILDPLATFORM" = 'linux/arm64' ]; then \
    export ARCH='aarch64'; \
  else \
    export ARCH='64'; \
  fi; \
  curl -L "https://micro.mamba.pm/api/micromamba/linux-${ARCH}/${VERSION}" | \
  tar -xj -C "/tmp" "bin/micromamba"

FROM --platform=$BUILDPLATFORM $BASE_IMAGE as micromamba

ARG MAMBA_ROOT_PREFIX="/opt/conda"
ARG MAMBA_EXE="/bin/micromamba"

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV MAMBA_ROOT_PREFIX=$MAMBA_ROOT_PREFIX
ENV MAMBA_EXE=$MAMBA_EXE
ENV PATH="${PATH}:${MAMBA_ROOT_PREFIX}/bin"

COPY --from=fetch /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=fetch /tmp/bin/micromamba "$MAMBA_EXE"

ARG MAMBA_USER=admin
ARG MAMBA_USER_ID=1000
ARG MAMBA_USER_GID=1000

ENV MAMBA_USER=$MAMBA_USER
ENV MAMBA_USER_ID=$MAMBA_USER_ID
ENV MAMBA_USER_GID=$MAMBA_USER_GID

RUN groupadd -g "${MAMBA_USER_GID}" "${MAMBA_USER}" && \
    useradd -m -u "${MAMBA_USER_ID}" -g "${MAMBA_USER_GID}" -s /bin/bash "${MAMBA_USER}"
RUN mkdir -p "${MAMBA_ROOT_PREFIX}/environments" && \
    chown "${MAMBA_USER}:${MAMBA_USER}" "${MAMBA_ROOT_PREFIX}"
RUN mkdir -p /code && chown -R $MAMBA_USER:$MAMBA_USER /code
RUN mkdir -p /data && chown -R $MAMBA_USER:$MAMBA_USER /data

ARG CONTAINER_WORKSPACE_FOLDER=/workspace
RUN mkdir -p "${CONTAINER_WORKSPACE_FOLDER}"
WORKDIR "${CONTAINER_WORKSPACE_FOLDER}"

USER $MAMBA_USER
RUN micromamba shell init --shell bash --prefix=$MAMBA_ROOT_PREFIX
SHELL ["/bin/bash", "--rcfile", "/$MAMBA_USER/.bashrc", "-c"]
