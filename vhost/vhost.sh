#!/usr/bin/env bash

if [ "$APPLICATION" = "laravel" ]; then
cat > /etc/nginx/conf.d/default.conf <<- EOF
server {
    index index.php index.html;
    server_name $DEV_DOMAIN;
    root /code/public;
    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

#    location / {
#        proxy_pass http://workspace:3000;
#    }
#
#    location /api {
#        try_files \$uri \$uri/ /index.php?\$query_string;
#    }

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

if [ "$APPLICATION" = "wordpress" ]; then
cat > /etc/nginx/conf.d/default.conf <<- EOF
server {
    index index.php index.html;
    server_name $DEV_DOMAIN;
    root /code;

    location / {
        try_files \$uri \$uri/ /index.php?\$args;
    }

    location ~ \.php$ {
        fastcgi_pass php:9000;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        include fastcgi_params;
    }

    location ~* \.(js|css|png|jpg|jpeg|gif|ico)$ {
            expires max;
            log_not_found off;
    }

    client_max_body_size 100M;
}
EOF
fi

if [ "$APPLICATION" = "phalcon" ]; then
cat > /etc/nginx/conf.d/default.conf <<- EOF
server {
    index index.php index.html;
    server_name $DEV_DOMAIN;

    root /var/www/default/public;
    index index.php index.html index.htm;

    charset utf-8;
    client_max_body_size 100M;
    fastcgi_read_timeout 1800;

    location / {
        try_files \$uri \$uri/ /index.php?_url=\$uri&\$args;
    }

    location ~ [^/]\.php(/|$) {
        fastcgi_pass php:9000;
        fastcgi_index index.php;
        fastcgi_split_path_info ^(.+?\.php)(/.*)$;
        if (!-f \$document_root\$fastcgi_script_name) {
            return 404;
        }
        fastcgi_param PATH_INFO \$fastcgi_path_info;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        include fastcgi_params;
    }

    location ~ /\.ht {
        deny all;
    }

    location ~* \.(js|css|png|jpg|jpeg|gif|ico)$ {
        expires       max;
        log_not_found off;
        access_log    off;
    }
}
EOF
fi