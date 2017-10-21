version: '3'
services:
  jira:
    image: cptactionhank/atlassian-jira-software:7.5.0
    restart: always
    ports:
    {{- if (.Values.EXPOSE_APP_PORT)}}
      - 8080:8080
    {{- end}}
    volumes:
      - ${DATA_PATH}:/var/atlassian/jira
    environment:
      CATALINA_OPTS: "-Xms1024m -Xmx4096m -Datlassian.plugins.enable.wait=300"
      X_PROXY_SCHEME: ${PROXY_SCHEME}
      X_PROXY_PORT: ${PROXY_PORT}
      X_PROXY_NAME: ${DOMAIN_NAME}
    labels:
      com.reidweb.nginx.host: ${DOMAIN_NAMES}
      com.reidweb.nginx.port: 8080
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