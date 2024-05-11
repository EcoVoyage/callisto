# syntax=docker/dockerfile:1.2

ARG BASE_IMAGE=callisto-docker

FROM --platform=$BUILDPLATFORM $BASE_IMAGE as jupyterhub


USER root

COPY --chown=$MAMBA_USER:$MAMBA_USER apt.txt /opt/conda/environments/apt.txt
RUN --mount=type=cache,target=/var/cache/apt,id=apt-jupyterhub apt-get update && xargs apt-get install -y < /opt/conda/environments/apt.txt

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