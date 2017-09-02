#!/usr/bin/env bash

echo "################################## Run nginx"
export DOLLAR='$'
printf '%s\n' "${!ROOT_DOMAIN}"
envsubst < ./src/configs/nginx/nginx.conf.template > /etc/nginx/nginx.conf # /etc/nginx/conf.d/default.conf
nginx -g "daemon off;"
