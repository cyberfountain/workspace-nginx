FROM nginx:1.15.0-alpine

LABEL maintainer="cyberfountain"

ENV NGINX_LARAVEL_API false
ENV DEV_DOMAIN "laravel.local"
ENV NGINX_SSL true

RUN apk update && apk add \
    openssl \
    bash

COPY ssl/generate-ssl.sh /etc/nginx/generate-ssl.sh
RUN chmod +x /etc/nginx/generate-ssl.sh
RUN cd /etc/nginx && ./generate-ssl.sh

COPY vhosts/vhost.sh /etc/nginx/vhost.sh
RUN chmod +x /etc/nginx/vhost.sh
RUN cd /etc/nginx && ./vhost.sh

COPY conf/nginx.conf /etc/nginx/nginx.conf

EXPOSE 80
EXPOSE 443