version: '2'
services:
  bitbucket:
    image: atlassian/bitbucket-server:5.2.0
    volumes:
      - ${DATA_PATH}:/var/atlassian/application-data/bitbucket
    restart: always
    ports:
      - 7999:7999
    environment:
      SERVER_SECURE: ${SERVER_SECURE}
      SERVER_SCHEME: ${PROXY_SCHEME}
      SERVER_PROXY_PORT: ${PROXY_PORT}
      SERVER_PROXY_NAME: ${SUB_DOMAIN}.${BASE_DOMAIN_NAME}
      ELASTICSEARCH_ENABLED: true
      VIRTUAL_HOST: ${SUB_DOMAIN}.${BASE_DOMAIN_NAME}
      LETSENCRYPT_HOST: ${SUB_DOMAIN}.${BASE_DOMAIN_NAME}
      VIRTUAL_PORT: 7990
      LETSENCRYPT_EMAIL: ssl@reidweb.com
      VIRTUAL_NETWORK: nginx-proxy
    links:
      - database
    depends_on:
      - database
    external_links:
      - ${CROWD_SERVICE}:crowd
    networks:
      - proxy-tier
    labels:
      traefik.enable: stack
      traefik.domain: ${BASE_DOMAIN_NAME}
      traefik.alias: ${SUB_DOMAIN}
      traefik.port: 7990
      traefik.protocol: http
      traefik.acme: true
  database:
    image: postgres:9.4
    restart: always
    volumes:
      - ${DB_DATA_PATH}:/var/lib/postgresql/data