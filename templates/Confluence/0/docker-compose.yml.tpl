version: '2'
services:
  confluence:
    image: atlassian/confluence-server:6.4
    volumes:
      - ${DATA_PATH}:/var/atlassian/application-data/confluence
    restart: always
    links:
      - database
    environment:
      CATALINA_CONNECTOR_SECURE: ${SERVER_SECURE}
      CATALINA_CONNECTOR_SCHEME: ${PROXY_SCHEME}
      CATALINA_CONNECTOR_PROXYPORT: ${PROXY_PORT}
      CATALINA_CONNECTOR_PROXYNAME: ${DOMAIN_NAME}
    labels:
      com.reidweb.nginx.host: ${DOMAIN_NAMES}
      com.reidweb.nginx.port: 8090
      com.reidweb.nginx.le_host: ${LE_DOMAIN_NAMES}
    external_links:
      - crowd/crowd:crowd
    links:
      - database
    depends_on:
      - database

  database:
    image: postgres:9.4
    restart: always
    volumes:
      - ${DB_DATA_PATH}:/var/lib/postgresql/data