#!/bin/bash

cd /etc/nginx && ./vhost.sh

exec nginx -g 'daemon off;'