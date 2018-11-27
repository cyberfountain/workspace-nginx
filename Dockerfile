FROM nginx:alpine

LABEL maintainer="cyberfountain"

ENV APPLICATION "wordpress"
ENV NGINX_LARAVEL_API false
ENV DEV_DOMAIN "test.local"

RUN apk update && apk add \
    openssl \
    bash

COPY vhost/vhost.sh /etc/nginx/vhost.sh
RUN chmod +x /etc/nginx/vhost.sh

COPY conf/nginx.conf /etc/nginx/nginx.conf

COPY entrypoint/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 80
EXPOSE 443

ENTRYPOINT ["/entrypoint.sh"]