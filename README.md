# 🚀 TipsterPage Ecosystem - Docker Stack

Este repositorio contiene la infraestructura completa del ecosistema **TipsterPage**, orquestada mediante Docker. El stack incluye servicios de **Laravel**, **NestJS**, **Angular**, **Firebase Admin**, y persistencia en **MongoDB** y **Redis**.

## 🏗 Arquitectura del Stack

El ecosistema se divide en los siguientes componentes clave:

| Servicio | Tecnología | Puerto | Descripción |
| :--- | :--- | :--- | :--- |
| **`landing`** | PHP 8.2 / Apache | `80`, `443` | Landing Page multi-tenant con soporte SSL. |
| **`backend`** | Node.js / Firebase | `2030`, `4000` | Core backend basado en funciones de Firebase. |
| **`admin`** | Angular | `4200` | Panel de administración (optimizado para Apple Silicon). |
| **`apiekans`** | NestJS | `4003` | Microservicio de integración de datos deportivos (Ekans). |
| **`apibagon`** | NestJS | `4002` | Microservicio de gestión de cuotas y apuestas (Bagon). |
| **`pikachu-api`** | NestJS | `4001` | Microservicio de notificaciones y alertas (Pikachu). |
| **`mongodb`** | MongoDB 4.4 | `27017` | Base de datos principal NoSQL. |
| **`redis`** | Redis Alpine | `6379` | Capa de caché compartida para todos los servicios. |

---

## 🛠 Requisitos Previos (macOS)

Para el correcto funcionamiento de los subdominios locales (ej. `molina.tipsterpage.test`), es necesario configurar **Dnsmasq** para resolver el wildcard `.test`:

1. **Instalar:** `brew install dnsmasq`
2. **Configurar:** 
   `echo "address=/.test/127.0.0.1" >> $(brew --prefix)/etc/dnsmasq.conf`
3. **Resolver:**
   `sudo mkdir -p /etc/resolver`
   `sudo bash -c 'echo "nameserver 127.0.0.1" > /etc/resolver/test'`

4. **Iniciar**: `sudo brew services start dnsmasq`

**NOTA**
SSL Local: Para accesos HTTPS, el navegador mostrará una advertencia de certificado no confiable. En Chrome/Arc, simplemente escribe `thisisunsafe` en cualquier parte de la pantalla de error para saltar la advertencia.

## 🚀 Levantamiento del Proyecto
Sigue estos pasos en orden para garantizar que todos los microservicios y bases de datos se comuniquen correctamente.

1. Preparación de Variables de Entorno
    Asegúrate de que tener cada repositorio actualizado con los ultimos cambios y pega en la raiz de cada uno el `.env` file. Estos archivos son ignorados por Git por seguridad, por lo que deben gestionarse manualmente.

    | **Backend: `.env`** | Debe ser copiado de manera manual dentro de la carpeta `/backend/functions`.

2. Construcción e Inicio del Stack
    Ejecuta el siguiente comando desde la raíz del proyecto para construir las imágenes personalizadas y levantar los contenedores:
    `docker-compose up -d --build`

3. Inicialización de Laravel (Landing)
    Una vez que el contenedor landing_laravel esté corriendo, es necesario asegurar que las dependencias y la configuración estén al día:

    ### Limpiar caché de configuración
    `docker exec -it landing_laravel php artisan config:clear`

    ### Generar llave de aplicación (si no existe en el .env)
    `docker exec -it landing_laravel php artisan key:generate`

    ### Ajustar permisos de storage (en caso de errores de escritura)
    `docker exec -it landing_laravel chown -R www-data:www-data /var/www/html/storage`

4. Inicialización de Base de Datos
    El servicio mongodb cuenta con un script de importación automática en `./scripts/import.sh`. Si necesitas realizar una carga manual de datos:

    ### Acceder al contenedor de Mongo para verificar la data
    `docker exec -it mongo_db mongo`

5. Verificación de Salud del Stack
    Puedes monitorear que todos los servicios hayan iniciado correctamente con:

    ### Ver estado de los contenedores
    `docker-compose ps`

    ### Monitorear logs en tiempo real para el Landing
    `docker-compose logs -f`