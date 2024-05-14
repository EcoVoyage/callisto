# syntax=docker/dockerfile:1.2

ARG BASE_IMAGE=ecovoyage/docker:20250501

FROM --platform=$BUILDPLATFORM $BASE_IMAGE as jupyterhub

USER root

COPY --chown=$MAMBA_USER:$MAMBA_USER apt.txt /opt/conda/environments/apt.txt
RUN --mount=type=cache,target=/var/cache/apt,id=apt-jupyter apt-get update && xargs apt-get install -y < /opt/conda/environments/apt.txt

ARG ADMIN_USER=admin
ARG ADMIN_GROUP=admin
ARG ADMIN_PASSWORD=MyPass
ARG ADMIN_UID: "1000"
ARG ADMIN_GID: "1000"

# Create the group if it does not exist
RUN getent group ${ADMIN_GID} || \
    groupadd -g ${ADMIN_GID} ${ADMIN_GROUP}

# Create the user if it does not exist and set the user's group
RUN getent passwd ${ADMIN_UID} || \
    useradd -m -u ${ADMIN_UID} -g ${ADMIN_GID} ${ADMIN_USER} || \
    usermod -g ${ADMIN_GID} ${ADMIN_USER}

# Set the user's password
RUN echo "${ADMIN_USER}:${ADMIN_PASSWORD}" | chpasswd && \
    echo "${MAMBA_USER} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${MAMBA_USER}

USER $MAMBA_USER
RUN micromamba shell init --shell bash --prefix=$MAMBA_ROOT_PREFIX
SHELL ["/bin/bash", "--rcfile", "/$MAMBA_USER/.bashrc", "-c"]
COPY --chown=$MAMBA_USER:$MAMBA_USER environment.yml /opt/conda/environments/environment.yml
RUN --mount=type=cache,target=/home/admin/pkgs,id=mamba-jupyterhub micromamba install -y --override-channels -c conda-forge -n base -f /opt/conda/environments/environment.yml

COPY --chown=$MAMBA_USER:$MAMBA_USER requirements.txt /opt/conda/environments/requirements.txt
RUN --mount=type=cache,target=/home/admin/.cache,id=pip-jupyterhub pip install -r /opt/conda/environments/requirements.txt

# WORKDIR /code
# RUN git clone https://github.com/jupyterhub/jupyterhub.git
# WORKDIR /code/jupyterhub
# RUN --mount=type=cache,target=/home/admin/.cache/pip,id=pip-jupyterhub pip install .

# WORKDIR /code
# RUN git clone https://github.com/jupyterlab/jupyterlab.git
# WORKDIR /code/jupyterlab
# RUN yarn install  && yarn build

# WORKDIR /code
# RUN git clone https://github.com/jupyterhub/dockerspawner.git
# WORKDIR /code/dockerspawner
# RUN --mount=type=cache,target=/home/admin/.cache/pip,id=pip-jupyterhub pip install .

USER root
COPY startup.sh /usr/bin/startup.sh
RUN chmod +x /usr/bin/startup.sh
ENTRYPOINT ["startup.sh"]

RUN mkdir -p /srv/jupyterhub && chown -R $MAMBA_USER:$MAMBA_USER /srv/jupyterhub

USER $MAMBA_USER
COPY jupyterhub_config.py /srv/jupyterhub/jupyterhub_config.py
WORKDIR /workspace