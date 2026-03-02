#!/bin/bash
dominios=(
    "tipsterpage.test"
    "app.affiliabet.test"
    "app.bagon.test"
    "ekans.test"
    "pikachu.test"
    "admin.test"
    "app.backend.test"
)

echo "🚨 INICIANDO LIMPIEZA TOTAL DEL ENTORNO..."

if [ -f "./docker-compose.yml" ]; then
    echo "🐳 Deteniendo contenedores y borrando volúmenes..."
    docker-compose down --volumes --remove-orphans
    echo "🧹 Eliminando imágenes locales del proyecto..."
    docker rmi $(docker images -q "tipster_*" 2>/dev/null) --force 2>/dev/null
fi

echo "📝 Eliminando dominios del archivo /etc/hosts..."
for dominio in "${dominios[@]}"; do
    sudo sed -i '' "/$dominio/d" /etc/hosts
done

CERT_FILE="./base/certs/apache.crt"
if [ -f "$CERT_FILE" ]; then
    echo "🔐 Eliminando certificado del Llavero de macOS..."
    sudo security delete-certificate -c "*.test" /Library/Keychains/System.keychain 2>/dev/null
fi

echo "🗑️  Borrando archivos de configuración y certificados"
rm -rf ./base/certs
rm -f ./base/gateway/nginx.conf

echo "📂 Limpiando archivos de configuración en proyectos Laravel..."
rm -f ./landing/apache.conf
rm -f ./affiliabet/apache.conf

echo "-------------------------------------------------------"
echo "✨ ¡Limpieza completada! Tu sistema está limpio."
echo "-------------------------------------------------------"