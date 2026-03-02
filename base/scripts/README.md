## ⚡ Vía Rápida: Scripts de Automatización

Para agilizar el proceso de *onboarding* y el manejo diario del entorno local, el repositorio incluye scripts de Bash en la carpeta `./base/scripts/` que automatizan el levantamiento y la destrucción del ecosistema completo.

### 1. Dar permisos de ejecución (Solo la primera vez)

Antes de poder utilizar los scripts, debes otorgarles permisos de ejecución en tu entorno. Desde la raíz del proyecto, ejecuta:

```bash
chmod +x ./base/scripts/init.sh ./base/scripts/delete.sh

```

---

### 🚀 Inicializar el Ecosistema (`init.sh`)

Este script se encarga de preparar todo el entorno desde cero con un solo comando.

```bash
./base/scripts/init.sh

```

**¿Qué hace este script por detrás?**

1. **Sincronización:** Ejecuta `git submodule update --init --recursive` para descargar el código de los microservicios.
2. **Construcción:** Levanta la infraestructura con `docker-compose up -d --build`.
3. **Setup de Laravel:** Limpia cachés, genera la llave de la aplicación y ajusta los permisos de la carpeta `/storage` nativamente dentro del contenedor.

> **⚠️ Atención usuarios de Windows:** Asegúrense de ejecutar este script **exclusivamente** desde una terminal de Linux (WSL2) o Git Bash. Si clonan el repositorio usando CMD o PowerShell con saltos de línea CRLF, el script fallará.

---

### 🧹 Limpiar y Detener el Ecosistema (`delete.sh`)

Cuando termines de trabajar o si necesitas reiniciar el entorno desde cero (por ejemplo, si hay un problema con la base de datos o la caché), utiliza este script para destruir el stack de forma segura.

```bash
./base/scripts/delete.sh

```

**¿Qué hace este script por detrás?**

* Detiene todos los contenedores en ejecución.
* Elimina los contenedores, redes y, dependiendo de su configuración, los volúmenes de datos asociados al proyecto, liberando recursos en tu máquina.