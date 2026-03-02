#!/bin/bash
proyectos=(
    "landing:tipsterpage.test:80"
    "affiliabet:app.affiliabet.test:80"
    "apibagon:app.bagon.test:4002"
    "apiekans:ekans.test:4003"
    "pikachu-api:pikachu.test:4001"
    "admin:admin.test:4200"
    "backend:app.backend.test:2030"
)

mkdir -p "./base/certs"
if [ ! -f "./base/certs/apache.crt" ]; then
    echo "🔐 Generando certificados SSL..."
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout "./base/certs/apache.key" \
        -out "./base/certs/apache.crt" \
        -subj "/C=CO/ST=Antioquia/L=Medellin/O=Tipster/CN=*.test"
fi

GATEWAY_CONF="./base/gateway/nginx.conf"
echo "resolver 127.0.0.11 valid=30s;" > "$GATEWAY_CONF"
echo "# Configuración Global de Gateway" >> "$GATEWAY_CONF"

for entrada in "${proyectos[@]}"; do
    IFS=':' read -r carpeta dominio puerto <<< "$entrada"

    SCRIPT_PATH="./base/scripts/activar-repo.sh"
    if [ -f "$SCRIPT_PATH" ]; then
        chmod +x "$SCRIPT_PATH"
        "$SCRIPT_PATH" "$carpeta" "$dominio" "$puerto"
    else
        echo "❌ Error: No se encuentra $SCRIPT_PATH"
        exit 1
    fi
done

sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain "$(pwd)/base/certs/apache.crt"

echo "🚀 Ejecutando: docker-compose up -d --build"
docker-compose up -d --build