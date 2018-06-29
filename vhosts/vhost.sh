#!/usr/bin/env bash

if [ "$NGINX_SSL" = true ]; then
cat > /etc/nginx/conf.d/default.conf <<- EOF
server {
    listen 80;
    server_name $DEV_DOMAIN;
    return 301 https://$DEV_DOMAIN\$request_uri;
}

server {
    listen 443 ssl;
    index index.php index.html;
    server_name $DEV_DOMAIN;
    error_log  /var/log/nginx/error.log;
    access_log /var/log/nginx/access.log;
    root /code/public;

    ssl_certificate /etc/nginx/${DEV_DOMAIN//.}.crt;
    ssl_certificate_key /etc/nginx/${DEV_DOMAIN//.}.key;
    ssl_protocols       TLSv1 TLSv1.1 TLSv1.2;
    ssl_ciphers         HIGH:!aNULL:!MD5;

EOF
if [ "$NGINX_LARAVEL_API" = true ]; then
cat >> /etc/nginx/conf.d/default.conf <<- EOF
    location / {
        proxy_pass http://workspace:3000;
    }

    location /api {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }
EOF
else
cat >> /etc/nginx/conf.d/default.conf <<- EOF
    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }
EOF
fi
cat >> /etc/nginx/conf.d/default.conf <<- EOF
    location /toolbox/redis-commander/ {
        proxy_pass http://redis-commander:8081/;
    }

    location ~ \.php$ {
        try_files \$uri =404;
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass php:9000;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        fastcgi_param PATH_INFO \$fastcgi_path_info;
    }
}
EOF
else
cat > /etc/nginx/conf.d/default.conf <<- EOF
server {
    index index.php index.html;
    server_name $DEV_DOMAIN;
    error_log  /var/log/nginx/error.log;
    access_log /var/log/nginx/access.log;
    root /code/public;


EOF
if [ "$NGINX_LARAVEL_API" = true ]; then
cat >> /etc/nginx/conf.d/default.conf <<- EOF
    location / {
        proxy_pass http://workspace:3000;
    }

    location /api {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }
EOF
else
cat >> /etc/nginx/conf.d/default.conf <<- EOF
    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }
EOF
fi
cat >> /etc/nginx/conf.d/default.conf <<- EOF
    location /toolbox/redis-commander/ {
        proxy_pass http://redis-commander:8081/;
    }

    location ~ \.php$ {
        try_files \$uri =404;
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass php:9000;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        fastcgi_param PATH_INFO \$fastcgi_path_info;
    }
}
EOF
fi
