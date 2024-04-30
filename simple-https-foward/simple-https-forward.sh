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
        listen 443 ssl;
        server_name yourdomain.com;
        access_log /dev/stdout;

        ssl_certificate /etc/ssl/certs/ssl-cert-snakeoil.pem;
        ssl_certificate_key /etc/ssl/private/ssl-cert-snakeoil.key;

        location / {
            proxy_pass http://localhost:$PORT;
            proxy_set_header Host \$host;
            proxy_set_header X-Real-IP \$remote_addr;
            proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;

	    proxy_connect_timeout 300s; # Estabelecer a conexão em até 300 segundos
    	    proxy_send_timeout 300s;    # Enviar solicitação em até 300 segundos
            proxy_read_timeout 300s;    # Ler a resposta em até 300 segundos 
       }
    }
}
" > $TMP_FILE
netstat -plunt | grep 443
sudo nginx -g "daemon off;error_log /dev/stdout debug;" -c "$TMP_FILE"
