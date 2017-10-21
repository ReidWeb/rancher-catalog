version: '2'
services:
  nginx:
    image: reidweb/rancher-nginx:v1.3.3
    environment:
      DEFAULT_HOST: ${DEFAULT_HOST}
      DEFAULT_EMAIL: ${DEFAULT_EMAIL}
      CRON: ${CRON}
      DEBUG: ${DEBUG}
      DEFAULT_PORT: ${DEFAULT_PORT}
    stdin_open: true
    volumes:
    - ${PATH}/htpasswd:/etc/nginx/htpasswd
    - ${PATH}/vhost.d:/etc/nginx/vhost.d
    - ${PATH}/letsencrypt:/etc/letsencrypt
    tty: true
    ports:
    - ${DEFAULT_PORT}:80/tcp
    - 443:443/tcp
    {{- foreach from=(.Values.EXTRA_PORTS) item=extraPortItem}}
    - {$extraPortItem}:{$extraPortItem}/tcp
    {{/foreach}}
    labels:
      io.rancher.container.pull_image: always