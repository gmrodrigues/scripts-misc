#!/bin/bash
# warning: only run this script with sudo
set -x
PORT=$1
TMP_FILE=$(tempfile)
echo "
worker_processes 1;

events {
    worker_connections 1024;
}

http {
    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    sendfile on;

    server {
        listen 80;
        server_name yourdomain.com;
        return 301 https://\$server_name\$request_uri;
    }

    server {
        listen 443 ssl;
        server_name yourdomain.com;

        ssl_certificate /etc/ssl/certs/ssl-cert-snakeoil.pem;
        ssl_certificate_key /etc/ssl/private/ssl-cert-snakeoil.key;

        location / {
            proxy_pass http://localhost:$PORT;
            proxy_set_header Host \$host;
            proxy_set_header X-Real-IP \$remote_addr;
            proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        }
    }
}
" > $TMP_FILE
netstat -plunt | grep 443
sudo nginx -g "daemon off;" -c "$TMP_FILE"
