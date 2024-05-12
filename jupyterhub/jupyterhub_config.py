import os
from jupyterhub.auth import PAMAuthenticator
from dockerspawner import SystemUserSpawner

c = get_config()

c.JupyterHub.log_level = 'DEBUG'
c.JupyterHub.authenticator_class = PAMAuthenticator
c.JupyterHub.spawner_class = 'dockerspawner.DockerSpawner'
c.JupyterHub.hub_ip = 'jupyterhub'

c.DockerSpawner.network_name = 'callisto'
c.DockerSpawner.image = 'jupyter/minimal-notebook:latest'
c.DockerSpawner.http_timeout = 180

# c.DockerSpawner.image = os.environ['DOCKER_JUPYTER_IMAGE']
# c.DockerSpawner.network_name = os.environ['DOCKER_NETWORK_NAME']
# c.DockerSpawner.start_timeout=180
# c.JupyterHub.hub_ip = os.environ['HUB_IP']

# c.JupyterHub.spawner_class = SystemUserSpawner
# c.SystemUserSpawner.image = 'jupyter/base-notebook:latest'
# c.SystemUserSpawner.host_homedir_format_string = '/home/{username}'
# c.SystemUserSpawner.image_homedir_format_string = '/home/{username}'
# c.SystemUserSpawner.host_homedir_format_string = '/workspace'
# c.SystemUserSpawner.image_homedir_format_string = '/workspace'
# c.SystemUserSpawner.http_timeout = 180
# c.SystemUserSpawner.remove = False
# c.SystemUserSpawner.use_internal_ip = True
# c.SystemUserSpawner.network_name = 'bridge'
# c.SystemUserSpawner.run_as_root = True
