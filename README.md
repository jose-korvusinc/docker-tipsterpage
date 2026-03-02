# 🚀 TipsterPage - Docker

Este repositorio contiene la infraestructura completa del ecosistema **TipsterPage**, creado mediante Docker y estructurada a través de **Git Submodules**. El stack incluye servicios de **Laravel**, **NestJS**, **Angular**, **Firebase Admin**, y persistencia en **MySQL**, **MongoDB** y **Redis**.

## 🏗 Arquitectura del Stack

El ecosistema se divide en los siguientes componentes clave y repositorios anidados:

| Servicio | Tecnología | Puerto | Descripción |
| --- | --- | --- | --- |
| **`landing`** | PHP 8.2 / Apache | `80`, `443` | Landing Page multi-tenant con soporte SSL. |
| **`backend`** | Node.js / Firebase | `2030`, `4000` | Core backend basado en funciones de Firebase. |
| **`admin`** | Angular | `4200` | Panel de administración (optimizado para Apple Silicon/WSL2). |
| **`apiekans`** | NestJS | `4003` | Microservicio de integración de datos deportivos (Ekans). |
| **`apibagon`** | NestJS | `4002` | Microservicio de gestión de cuotas y apuestas (Bagon). |
| **`apipikachu`** | NestJS | `4001` | Microservicio de notificaciones y alertas (Pikachu). |
| **`affiliabet`** | - | - | Módulo de afiliación. |
| **`mongodb`** | MongoDB 4.4 | `27017` | Base de datos principal NoSQL. |
| **`redis`** | Redis Alpine | `6379` | Capa de caché compartida para todos los servicios. |

---

## 🛠 Requisitos Previos

Antes de clonar el repositorio, asegúrate de configurar tu entorno según tu sistema operativo para garantizar la correcta resolución de dominios locales (`*.test`) y el manejo de archivos.

### 🍎 Para usuarios de macOS

Para el correcto funcionamiento de los subdominios locales (ej. `molina.tipsterpage.test`), es necesario configurar **Dnsmasq** para resolver el wildcard `.test`:

1. **Instalar:** `brew install dnsmasq`
2. **Configurar:** `echo "address=/.test/127.0.0.1" >> $(brew --prefix)/etc/dnsmasq.conf`
3. **Resolver:**
```bash
sudo mkdir -p /etc/resolver
sudo bash -c 'echo "nameserver 127.0.0.1" > /etc/resolver/test'

```


4. **Iniciar**: `sudo brew services start dnsmasq`

### 🪟 Para usuarios de Windows

Es estrictamente necesario utilizar **Docker Desktop con integración WSL2** (Windows Subsystem for Linux). Trabaja siempre desde la terminal de tu distribución Linux (ej. Ubuntu) o Git Bash, nunca desde CMD o PowerShell.

1. **Evitar errores de saltos de línea (CRLF a LF):**
Antes de clonar el repositorio, ejecuta este comando para evitar que los scripts de bash fallen en los contenedores de Linux:
```bash
git config --global core.autocrlf false

```


2. **Resolución de DNS Local (.test):**
Windows no soporta comodines nativos. Tienes dos opciones:
* **Opción A (Archivo Hosts):** Abre el bloc de notas como Administrador, edita `C:\Windows\System32\drivers\etc\hosts` y añade manualmente los tenants:
```text
127.0.0.1 tipsterpage.test
127.0.0.1 admin.tipsterpage.test
127.0.0.1 molina.tipsterpage.test

```


* **Opción B (Acrylic DNS):** Instala [Acrylic DNS Proxy](https://mayakron.altervista.org/support/acrylic/Home.htm), añade `127.0.0.1 *.test` a su archivo de configuración y usa `127.0.0.1` como tu servidor DNS principal en Windows.



> **NOTA - SSL Local (Ambos OS):** Para accesos HTTPS, el navegador mostrará una advertencia de certificado no confiable. En Chrome/Brave/Arc, simplemente escribe `thisisunsafe` (sin espacios ni barra de búsqueda) en cualquier parte de la pantalla de error para saltar la advertencia.

---

## 🚀 Levantamiento del Proyecto

Sigue estos pasos en orden para garantizar la correcta descarga del código, configuración de variables y comunicación de los contenedores.

### 1. Inicialización de Submódulos

Dado que los microservicios son repositorios independientes, debes inicializarlos y descargar su código fuente después de clonar este repositorio principal:

```bash
git submodule update --init --recursive

```

### 2. Preparación de Variables de Entorno

Asegúrate de copiar los archivos `.env` correspondientes dentro de cada submódulo. Estos archivos son ignorados por Git por seguridad.

* **Backend:** El archivo `.env` debe ser copiado manualmente dentro de la ruta `./backend/functions/`.
* **Otros servicios:** Revisa la raíz de `./landing`, `./apiekans`, etc., para configurar sus respectivos `.env`.

### 3. Construcción e Inicio del Stack

Ejecuta el siguiente comando desde la raíz del proyecto para construir las imágenes de los submódulos y levantar los contenedores en segundo plano:

```bash
docker-compose up -d --build

```

### 4. Inicialización de Laravel (Landing)

Una vez que el contenedor `landing_laravel` esté corriendo, asegura que las dependencias y la configuración estén operativas:

```bash
# Limpiar caché de configuración
docker exec -it landing_laravel php artisan config:clear

# Generar llave de aplicación (si no existe en el .env)
docker exec -it landing_laravel php artisan key:generate

# Ajustar permisos de storage (Crucial en Linux/WSL2)
docker exec -it landing_laravel chown -R www-data:www-data /var/www/html/storage

```

### 5. Inicialización de Base de Datos

El servicio `mongodb` cuenta con un script de importación automática en `./scripts/import.sh`. Si necesitas realizar una carga manual o verificar los datos:

```bash
# Acceder al shell interactivo del contenedor de Mongo
docker exec -it mongo_db mongo

```

### 6. Verificación de Salud del Stack

Puedes monitorear que todos los servicios estén en estado "Up" y revisar los registros de actividad:

```bash
# Ver estado de los contenedores
docker-compose ps

# Monitorear logs en tiempo real (ej: docker-compose logs -f landing)
docker-compose logs -f

```