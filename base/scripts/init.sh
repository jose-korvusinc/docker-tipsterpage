#!/bin/bash
proyectos=(
    "landing:tipsterpage.test:80"
    "affiliabet:app.affiliabet.test:80"
    "apibagon:app.bagon.test:4002"
    "apiekans:ekans.test:4003"
    "apipikachu:pikachu.test:4001"
    "admin:admin.test:4200"
    "backend:app.backend.test:2030"
)

if [ -d "./base/gateway/nginx.conf" ]; then
    rm -rf ./base/gateway/nginx.conf
fi

CERT_DIR="./base/apache/certs"
mkdir -p "$CERT_DIR"

if [ ! -f "$CERT_DIR/apache.crt" ]; then
    echo "🔐 Generando certificados SSL multi-dominio para el ecosistema..."
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout "$CERT_DIR/apache.key" \
        -out "$CERT_DIR/apache.crt" \
        -subj "/CN=tipsterpage-local" \
        -addext "subjectAltName = DNS:admin.test, DNS:app.backend.test, DNS:app.affiliabet.test, DNS:tipsterpage.test, DNS:ekans.test, DNS:pikachu.test, DNS:app.bagon.test"
    
    echo "🛡️ Añadiendo certificado al llavero de macOS (se requiere sudo)..."
    sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain "$CERT_DIR/apache.crt"
fi

GATEWAY_CONF="./base/gateway/nginx.conf"
echo "resolver 127.0.0.11 valid=30s;" > "$GATEWAY_CONF"
echo "# Configuración Global de Gateway - TipsterPage" >> "$GATEWAY_CONF"

for entrada in "${proyectos[@]}"; do
    IFS=':' read -r carpeta dominio puerto <<< "$entrada"
    
    echo "--- Procesando $dominio ($carpeta) ---"

    SCRIPT_PATH="./base/scripts/activar-repo.sh"
    if [ -f "$SCRIPT_PATH" ]; then
        chmod +x "$SCRIPT_PATH"
        "$SCRIPT_PATH" "$carpeta" "$dominio" "$puerto"
    else
        echo "❌ Error: No se encuentra $SCRIPT_PATH"
        exit 1
    fi

    echo "
server {
    listen 80;
    listen 443 ssl;
    server_name $dominio;
    client_max_body_size 100M;
    ssl_certificate /etc/nginx/certs/apache.crt;
    ssl_certificate_key /etc/nginx/certs/apache.key;
    
    location / {
        set \$upstream_$carpeta $carpeta;
        proxy_pass http://\$upstream_$carpeta:$puerto;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection \"upgrade\";
        proxy_connect_timeout 600;
        proxy_send_timeout 600;
        proxy_read_timeout 600;
    }
}" >> "$GATEWAY_CONF"
done

echo "🚀 Construyendo y levantando contenedores en Docker..."
docker-compose down
docker-compose up -d --build