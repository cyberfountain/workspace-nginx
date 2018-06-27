#!/bin/bash

if [ ! -f /etc/nginx/${DEV_DOMAIN//.}.crt ]; then
    cd /etc/nginx && ./generate-ssl.sh
fi

cd /etc/nginx && ./vhost.sh

exec nginx -g 'daemon off;'