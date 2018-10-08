FROM nginx:alpine

LABEL maintainer="cyberfountain"

ENV APPLICATION=wordpress
ENV NGINX_LARAVEL_API false
ENV DEV_DOMAIN "laravel.local"
ENV NGINX_SSL true

RUN apk update && apk add \
    openssl \
    bash

COPY ssl/generate-ssl.sh /etc/nginx/generate-ssl.sh
RUN chmod +x /etc/nginx/generate-ssl.sh

COPY vhosts/vhost.sh /etc/nginx/vhost.sh
RUN chmod +x /etc/nginx/vhost.sh

COPY conf/nginx.conf /etc/nginx/nginx.conf

COPY entrypoint/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 80
EXPOSE 443

ENTRYPOINT ["/entrypoint.sh"]