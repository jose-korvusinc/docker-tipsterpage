#!/bin/bash
echo ">>> Iniciando importación desde la carpeta scripts..."
mongorestore --db tipsterpage-dev /dump/tipsterpage-dev --gzip
echo ">>> Importación finalizada."