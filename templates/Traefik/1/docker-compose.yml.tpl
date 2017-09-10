version: '2'
services:
  traefik:
    ports:
    - ${admin_port}:8000/tcp
    - ${http_port}:8080/tcp
    - ${https_port}:8443/tcp
    labels:
      io.rancher.scheduler.global: 'true'
      io.rancher.scheduler.affinity:host_label: ${host_label}
      io.rancher.scheduler.affinity:container_label_ne: io.rancher.stack_service.name=$${stack_name}/$${service_name}
      io.rancher.sidekicks: traefik-conf
        {{- if eq .Values.acme_enable "true" -}}
          ,traefik-acme
        {{- end}}
      io.rancher.container.hostname_override: container_name
    image: reidweb/alpine-traefik:v1.0.1
    environment:
    - CONF_INTERVAL=${refresh_interval}
    - TRAEFIK_HTTP_PORT=8080
    - TRAEFIK_HTTPS_PORT=8443
    - TRAEFIK_HTTPS_ENABLE=${https_enable}
  {{- if eq .Values.acme_enable "true"}}
    - TRAEFIK_ACME_ENABLE=${acme_enable}
    - TRAEFIK_ACME_EMAIL=${acme_email}
    - TRAEFIK_ACME_ONDEMAND=${acme_ondemand}
    - TRAEFIK_ACME_ONHOSTRULE=${acme_onhostrule}
  {{- end}}
    - TRAEFIK_INSECURE_SKIP=${insecure_skip}
    volumes_from:
    - traefik-conf
  {{- if eq .Values.acme_enable "true"}}
    - traefik-acme
  {{- end}}
  traefik-conf:
    labels:
      io.rancher.scheduler.global: 'true'
      io.rancher.scheduler.affinity:host_label: ${host_label}
      io.rancher.scheduler.affinity:container_label_ne: io.rancher.stack_service.name=$${stack_name}/$${service_name}
      io.rancher.container.start_once: 'true'
    image: reidweb/rancher-traefik:v1.0.0
    network_mode: none
    volumes:
      - tools-volume:/opt/tools
  {{- if eq .Values.acme_enable "true"}}
  traefik-acme:
    network_mode: none
    labels:
      io.rancher.scheduler.affinity:container_label_soft_ne: io.rancher.stack_service.name=$${stack_name}/$${service_name}
      io.rancher.container.hostname_override: container_name
      io.rancher.container.start_once: true
    environment:
      - SERVICE_UID=10001
      - SERVICE_GID=10001
      - SERVICE_VOLUME=/opt/traefik/acme
    volumes:
      - ${VOLUME_NAME}:/opt/traefik/acme
    image: rawmind/alpine-volume:0.0.2-1
  {{- end}}
volumes:
  tools-volume:
    driver: local
    per_container: true
  {{- if eq .Values.acme_enable "true"}}
  ${VOLUME_NAME}:
    driver: ${VOLUME_DRIVER}
  {{- end}}
