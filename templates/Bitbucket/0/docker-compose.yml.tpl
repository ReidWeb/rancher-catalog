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
      SERVER_PROXY_NAME: ${DOMAIN_NAME}
      ELASTICSEARCH_ENABLED: true
    links:
      - database
    depends_on:
      - database
    external_links:
      - ${CROWD_SERVICE}:crowd
    networks:
      - proxy-tier
    labels:
      rap.host: ${DOMAIN_NAME}
      rap.port: 7990
      rap.le_host: ${DOMAIN_NAME}
  database:
    image: postgres:9.4
    restart: always
    volumes:
      - ${DB_DATA_PATH}:/var/lib/postgresql/data

networks:
  proxy-tier:
    external:
      name: nginx-proxy