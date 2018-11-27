FROM nginx:alpine

LABEL maintainer="cyberfountain"

ENV APPLICATION "wordpress"
ENV NGINX_LARAVEL_API false
ENV DEV_DOMAIN "test.local"

RUN apk update && apk add \
    openssl \
    bash

COPY conf/nginx.conf /etc/nginx/nginx.conf

EXPOSE 80
EXPOSE 443