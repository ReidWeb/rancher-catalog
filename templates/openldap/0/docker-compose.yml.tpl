version: '2'
services:
  ldap-host:
    image: "osixia/openldap:1.1.9"
    domainname: "${domain_name}"
    hostname: ldap
    environment:
      LDAP_ORGANISATION: "${org_name}"
      LDAP_DOMAIN: "${domain_name}"
      LDAP_ADMIN_PASSWORD: "${admin_pwd}"
      LDAP_READONLY_USER: "${readonly_user}"
      LDAP_BASE_DN: "${base_dn}"
      LDAP_READONLY_USER_USERNAME: "${readonly_user_username}"
      LDAP_READONLY_USER_PASSWORD: "${readonly_user_password}"
{{- if (.Values.cert_path)}}
      LDAP_TLS: true
      LDAP_TLS_CRT_FILENAME: "fullchain.pem"
      LDAP_TLS_KEY_FILENAME: "privkey.pem"
      LDAP_TLS_CA_CRT_FILENAME: "ca.pem"
      LDAP_TLS_CIPHER_SUITE: "NORMAL"
      LDAP_TLS_VERIFY_CLIENT: "allow"
{{- end}}
    volumes:
      - /srv/openldap/var/lib/ldap:/var/lib/ldap:rw
      - /srv/openldap/etc/ldap/slapd.d:/etc/ldap/slapd.d:rw
{{- if (.Values.cert_path)}}
      - ${cert_path}:/container/service/slapd/assets/certs
{{- end}}
{{- if (.Values.custom_ldif_path)}}
      - ${custom_ldif_path}:/container/service/slapd/assets/config/bootstrap/ldif/custom
{{- end}}
    expose:
{{- if (.Values.ldap_external_port)}}
      - "389"
{{- end}}
{{- if (.Values.ldap_tls_port)}}
      - "636"
{{- end}}
    ports:
{{- if (.Values.ldap_external_port)}}
      - ${ldap_external_port}:389
{{- end}}
{{- if (.Values.ldap_tls_port)}}
      - ${ldap_tls_port}:636
{{- end}}
  ldap-admin:
    image: "osixia/phpldapadmin:0.7.1"
    depends_on:
      - ldap-host
    links:
      - ldap-host
    environment:
      LDAP_ORGANISATION: "${org_name}"
      LDAP_DOMAIN: "${domain_name}"
      LDAP_ADMIN_PASSWORD: "${admin_pwd}"
      LDAP_READONLY_USER: ${readonly_user}
      LDAP_BASE_DN: "${base_dn}"
      LDAP_READONLY_USER_USERNAME: "${readonly_user_username}"
      LDAP_READONLY_USER_PASSWORD: "${readonly_user_password}"
      PHPLDAPADMIN_SERVER_ADMIN: "${admin_email}"
      PHPLDAPADMIN_HTTPS: false
{{- if (.Values.cert_path)}}
      PHPLDAPADMIN_LDAP_CLIENT_TLS: true
      PHPLDAPADMIN_LDAP_CLIENT_TLS_CRT_FILENAME: "fullchain.pem"
      PHPLDAPADMIN_LDAP_CLIENT_TLS_KEY_FILENAME: "privkey.pem"
      PHPLDAPADMIN_LDAP_CLIENT_TLS_CA_CRT_FILENAME: "ca.pem"
      PHPLDAPADMIN_LDAP_CLIENT_TLS_REQCERT: "never"
{{- end}}
    volumes:
      - /home/reid/tmp/env.yaml:/container/environment/01-custom/env.yaml
{{- if (.Values.cert_path)}}
      - ${cert_path}:/container/service/ldap-client/assets/certs/
{{- end}}
{{- if (.Values.ui_hostname)}}
    labels:
      com.reidweb.nginx.host: ${ui_hostname}
      com.reidweb.nginx.port: 80
      com.reidweb.nginx.le_host: ${ui_hostname}
{{- end}}
{{- if (.Values.admin_ui_port)}}
    expose:
      - "80"
    ports:
      - ${admin_ui_port}:80
{{- end}}