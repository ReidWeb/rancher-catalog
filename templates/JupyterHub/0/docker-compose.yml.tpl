version: '2'
services:
  hub-db:
    image: postgres:9.5
    container_name: jupyterhub-db
    restart: always
    environment:
      POSTGRES_DB: "jupyterhub"
      PGDATA: "/var/lib/postgresql/data"
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
    volumes:
      - ${DATA_PATH}:/var/lib/postgresql/data

  hub:
    depends_on:
      - hub-db
    restart: always
    image: 458985664841.dkr.ecr.eu-west-1.amazonaws.com/reidweb/jupyter/jupyterhub:latest
    container_name: jupyterhub
    volumes:
      # Bind Docker socket on the host so we can connect to the daemon from
      # within the container
      - "/var/run/docker.sock:/var/run/docker.sock:rw"
      # Bind Docker volume on host for JupyterHub database and cookie secrets
      - ${DATA_PATH}:/data
      - "/data/jupyter-certs:/etc/letsencrypt"
    labels:
      com.reidweb.nginx.host: ${DOMAIN_NAMES}
      com.reidweb.nginx.port: 8000
      com.reidweb.nginx.le_host: ${LE_DOMAIN_NAMES}
    links:
      - hub-db
    environment:
      DOCKER_NETWORK_NAME: "jupyterhub-network"
      # JupyterHub will spawn this Notebook image for users
      DOCKER_NOTEBOOK_IMAGE: "reidweb/jupyter-notebook:latest"
      # Notebook directory inside user image
      DOCKER_NOTEBOOK_DIR: "/home/jup/work"
      DOCKER_SPAWN_CMD: "start-singleuser.sh"
      # Postgres db info  
      POSTGRES_DB: "jupyterhub"
      POSTGRES_HOST: hub-db
      SSL_KEY: "/etc/letsencrypt/privkey.pem"
      SSL_CERT: "/etc/letsencrypt/cert.pem"
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
      GITHUB_CLIENT_ID: ${GITHUB_CLIENT_ID}
      GITHUB_CLIENT_SECRET: ${GITHUB_CLIENT_SECRET}
      OAUTH_CALLBACK_URL: ${OAUTH_CALLBACK_URL}
    command: >
      jupyterhub -f /srv/jupyterhub/jupyterhub_config.py
networks:
  default:
    external:
      name: "jupyterhub-network"
