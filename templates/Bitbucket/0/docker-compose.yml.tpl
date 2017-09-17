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
    labels:
      com.reidweb.nginx.host: ${DOMAIN_NAMES}
      com.reidweb.nginx.port: 7990
      com.reidweb.nginx.le_host: ${LE_DOMAIN_NAMES}
      com.reidweb.nginx.le_test: ${USE_TEST_LE}
  database:
    image: postgres:9.4
    restart: always
    volumes:
      - ${DB_DATA_PATH}:/var/lib/postgresql/data