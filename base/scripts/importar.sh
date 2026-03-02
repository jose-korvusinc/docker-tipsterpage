#!/bin/bash
echo ">>> Iniciando importación desde la carpeta scripts..."
# La ruta /dump es la interna que definimos en el docker-compose
mongorestore --db tipsterpage-dev /dump/tipsterpage-dev --gzip
echo ">>> Importación finalizada."