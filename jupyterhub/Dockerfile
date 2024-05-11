# syntax=docker/dockerfile:1.2

ARG BASE_IMAGE=debian:bookworm-slim
FROM --platform=$BUILDPLATFORM $BASE_IMAGE AS fetch
ARG VERSION=1.5.3

RUN --mount=type=cache,target=/var/cache/apt,id=apt-jupyterhub-fetch apt-get update && apt-get install -y --no-install-recommends bzip2 ca-certificates curl
RUN if [ "$BUILDPLATFORM" = 'linux/arm64' ]; then \
    export ARCH='aarch64'; \
  else \
    export ARCH='64'; \
  fi; \
  curl -L "https://micro.mamba.pm/api/micromamba/linux-${ARCH}/${VERSION}" | \
  tar -xj -C "/tmp" "bin/micromamba"

FROM --platform=$BUILDPLATFORM $BASE_IMAGE as jupyterhub

COPY --chown=$MAMBA_USER:$MAMBA_USER apt.txt /opt/conda/environments/apt.txt
RUN --mount=type=cache,target=/var/cache/apt,id=apt-jupyterhub apt-get update && xargs apt-get install -y < /opt/conda/environments/apt.txt

RUN curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
    $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

RUN --mount=type=cache,target=/var/cache/apt,id=apt-jupyterhub apt-get update && apt-get install -y docker-ce docker-ce-cli containerd.io

ARG MAMBA_ROOT_PREFIX="/opt/conda"
ARG MAMBA_EXE="/bin/micromamba"

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV MAMBA_ROOT_PREFIX=$MAMBA_ROOT_PREFIX
ENV MAMBA_EXE=$MAMBA_EXE
ENV PATH="${PATH}:${MAMBA_ROOT_PREFIX}/bin"

COPY --from=fetch /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=fetch /tmp/bin/micromamba "$MAMBA_EXE"

ARG MAMBA_USER=jovian
ARG MAMBA_USER_ID=1000
ARG MAMBA_USER_GID=1000

ENV MAMBA_USER=$MAMBA_USER
ENV MAMBA_USER_ID=$MAMBA_USER_ID
ENV MAMBA_USER_GID=$MAMBA_USER_GID

RUN groupadd -g "${MAMBA_USER_GID}" "${MAMBA_USER}" && \
    useradd -m -u "${MAMBA_USER_ID}" -g "${MAMBA_USER_GID}" -s /bin/bash "${MAMBA_USER}"
RUN mkdir -p "${MAMBA_ROOT_PREFIX}/environments" && \
    chown "${MAMBA_USER}:${MAMBA_USER}" "${MAMBA_ROOT_PREFIX}"

ARG CONTAINER_WORKSPACE_FOLDER=/workspace
RUN mkdir -p "${CONTAINER_WORKSPACE_FOLDER}"
WORKDIR "${CONTAINER_WORKSPACE_FOLDER}"

USER $MAMBA_USER
RUN micromamba shell init --shell bash --prefix=$MAMBA_ROOT_PREFIX
SHELL ["/bin/bash", "--rcfile", "/$MAMBA_USER/.bashrc", "-c"]
COPY --chown=$MAMBA_USER:$MAMBA_USER environment.yml /opt/conda/environments/environment.yml
RUN --mount=type=cache,target=/home/jovian/pkgs,id=mamba-jupyterhub micromamba install -y --override-channels -c conda-forge -n base -f /opt/conda/environments/environment.yml

USER root
RUN usermod -aG sudo $MAMBA_USER
RUN echo "$MAMBA_USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN echo 'export MAMBA_USER_ID=$(id -u)' >> /home/$MAMBA_USER/.bashrc && \
    echo 'export MAMBA_USER_GID=$(id -g)' >> /home/$MAMBA_USER/.bashrc && \
    echo 'export CONDA_BLD_PATH=/workspace/build' >> /home/$MAMBA_USER/.bashrc && \ 
    echo "micromamba activate" >> /home/$MAMBA_USER/.bashrc

RUN mkdir -p /code && chown -R $MAMBA_USER:$MAMBA_USER /code
RUN mkdir -p /data && chown -R $MAMBA_USER:$MAMBA_USER /data


USER $MAMBA_USER

WORKDIR /code
RUN git clone https://github.com/jupyterhub/jupyterhub.git
WORKDIR /code/jupyterhub
RUN --mount=type=cache,target=/home/jovian/.cache/pip,id=pip-jupyterhub pip install .

WORKDIR /code
RUN git clone https://github.com/jupyterlab/jupyterlab.git
WORKDIR /code/jupyterlab
RUN yarn install  && yarn build

WORKDIR /code
RUN git clone https://github.com/jupyterhub/dockerspawner.git
WORKDIR /code/dockerspawner
RUN --mount=type=cache,target=/home/jovian/.cache/pip,id=pip-jupyterhub pip install .

USER root
COPY startup.sh /usr/bin/startup.sh
RUN chmod +x /usr/bin/startup.sh
ENTRYPOINT ["startup.sh"]

USER $MAMBA_USER
WORKDIR /workspace