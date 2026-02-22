# 🗄️ MongoDB Auto-Import Script - TipsterPay
Este sistema automatiza la restauración de la base de datos `tipsterpage-dev` cada vez que el entorno de Docker se inicializa desde cero. Esto garantiza que todos los desarrolladores trabajen con la misma data de prueba.

# 📋 Descripción del Script
El archivo import.sh es un script de Bash que utiliza la herramienta mongorestore para procesar los dumps de la base de datos.

Contenido del Script (scripts/import.sh)
> Bash
> #!/bin/bash
> echo ">>> Iniciando importación desde la carpeta scripts..."
> mongorestore --db tipsterpage-dev /dump/tipsterpage-dev --gzip`
> echo ">>> Importación finalizada."

# 🛠️ Integración con Docker
Para que la importación funcione, el servicio mongodb en tu docker-compose.yml debe tener mapeados el volumen de datos y el script de inicio.

Configuración de Docker Compose
MongoDB ejecuta automáticamente cualquier script .sh que encuentre en la ruta interna /docker-entrypoint-initdb.d/ únicamente durante la primera creación del contenedor.

YAML
  mongodb:
    image: mongo:5.0
    container_name: mongo_db
    ports:
      - "27017:27017"
    volumes:
      - ./mongo-data:/dump                             # Carpeta local con los archivos .bson.gz
      - ./scripts/import.sh:/docker-entrypoint-initdb.d/import.sh:ro # Inyección del script (Solo lectura)

# 🚀 Instrucciones de Uso
1. Preparar el Dump
Coloca los archivos de respaldo comprimidos (.gz) en la carpeta local:
`./mongo-data/tipsterpage-dev/`

2. Forzar la Importación
Si la base de datos ya tiene volúmenes creados, el script no se ejecutará. Para forzar una importación limpia, debes borrar los volúmenes previos:

**Detener contenedores y eliminar volúmenes de datos**
`docker-compose down -v`

# Levantar el entorno (el script se ejecutará automáticamente)
`docker-compose up -d`

# ⚠️ Solución de Problemas
Error de Permisos: Si el log de Docker indica que no puede ejecutar el script, otorga permisos locales:

`chmod +x scripts/import.sh`

Límite de Almacenamiento: Asegúrate de que Docker Desktop tenga asignado suficiente espacio (mínimo 64GB) para evitar que mongorestore falle por disco lleno. Actualmente, tu sistema reporta un uso de 31.9 GB sobre un límite de 20 GB.

Versión de Mongo: Este script está probado para la imagen mongo:5.0.