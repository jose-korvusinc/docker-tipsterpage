# 📁 Directorio Base - Recursos de Infraestructura

Este directorio contiene los archivos de configuración estática, certificados, scripts de automatización y plantillas de servicios necesarios para el funcionamiento del stack de Docker.

## 📂 Estructura de Carpetas

| Carpeta | Descripción |
| --- | --- |
| **`apache`** | Contiene el archivo `apache.conf` y configuraciones específicas para el servidor web de la landing. |
| **`certs`** | Almacena los certificados SSL (`apache.crt`, `apache.key`) para habilitar HTTPS en el entorno local. |
| **`dbbackups`** | Directorio destinado a respaldos de bases de datos. Incluye subcarpetas para **Mongo** y **MySQL**. |
| **`gateway`** | Configuraciones de Nginx (`nginx.conf`, `nginx-gateway.conf`) que actúa como puerta de enlace para los microservicios. |
| **`scripts`** | Centro de automatización del proyecto con herramientas para el ciclo de vida del stack. |

---

## 📜 Scripts Disponibles (`./scripts`)

Los scripts deben ejecutarse preferiblemente desde la raíz del proyecto para que las rutas relativas funcionen correctamente.

* **`init.sh`**: Automatiza el flujo completo de arranque: descarga submódulos, levanta Docker y configura Laravel.
* **`delete.sh`**: Detiene y remueve los contenedores y redes del ecosistema de forma segura.
* **`importar.sh`**: Facilita la carga de datos iniciales en la base de datos (MongoDB/MySQL).
* **`activar-repo.sh`**: Script de utilidad para gestionar o refrescar los estados de los repositorios anidados.

## 🔐 Seguridad y Certificados

Los archivos dentro de la carpeta `certs` son para **uso exclusivo en desarrollo local**. Para el despliegue en producción (ej. en tu servidor de Linode), estos deben ser reemplazados por certificados válidos emitidos por una autoridad (CA).