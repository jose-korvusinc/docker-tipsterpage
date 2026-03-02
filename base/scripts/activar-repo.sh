#!/bin/bash
PROJECT_NAME=$1
DOMAIN_NAME=$2
PORT=$3

if ! grep -q "$DOMAIN_NAME" /etc/hosts; then
    echo "127.0.0.1 $DOMAIN_NAME" | sudo tee -a /etc/hosts
fi

if [[ "$PROJECT_NAME" == "landing" || "$PROJECT_NAME" == "affiliabet" ]]; then
    mkdir -p "./$PROJECT_NAME"
    cat <<EOF > "./$PROJECT_NAME/apache.conf"
ServerName localhost
<VirtualHost *:80>
    ServerName ${DOMAIN_NAME}
    DocumentRoot /var/www/html/public
    RewriteEngine On
    RewriteCond %{HTTPS} off
    RewriteRule ^(.*)$ https://%{HTTP_HOST}%{REQUEST_URI} [L,R=301]
</VirtualHost>

<VirtualHost *:443>
    ServerName ${DOMAIN_NAME}
    DocumentRoot /var/www/html/public
    SSLEngine on
    # NOTA: Estas rutas son las del VOLUMEN dentro del contenedor
    SSLCertificateFile /etc/nginx/certs/apache.crt
    SSLCertificateKeyFile /etc/nginx/certs/apache.key
    <Directory /var/www/html/public>
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
EOF
fi

cat <<EOF >> "./base/gateway/nginx.conf"

server {
    listen 80;
    listen 443 ssl;
    server_name ${DOMAIN_NAME};
    ssl_certificate /etc/nginx/certs/apache.crt;
    ssl_certificate_key /etc/nginx/certs/apache.key;
    location / {
        proxy_pass http://${PROJECT_NAME}:${PORT};
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
    }
}
EOF