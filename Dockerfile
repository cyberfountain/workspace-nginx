FROM nginx:alpine

LABEL maintainer="cyberfountain"

COPY conf/nginx.conf /etc/nginx/nginx.conf

EXPOSE 80
EXPOSE 443