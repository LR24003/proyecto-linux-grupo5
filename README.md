# Proyecto Linux - Grupo 5

## Descripción del Proyecto
Este proyecto fue desarrollado como parte de la asignatura **Introducción al Software Libre** en la Universidad de El Salvador.
El objetivo principal es implementar un servidor Linux automatizado utilizando **Docker**, **scripts Bash**, y **Git** como herramienta de control de versiones.

El proyecto incluye:
- Configuración de usuarios, grupos y permisos.
- Automatización del sistema con cron.
- Implementación de contenedores Docker.
- Despliegue de un servidor web Nginx.
- Control de versiones con Git y GitHub.


## 2. AUTOMATIZACIÓN Y MONITOREO

### 2.2 Automatización con Cron

Se configuró una tarea programada bajo el usuario `adminsys` para ejecutar el script de monitoreo cada 30 minutos, asegurando que la salida se guarde en la ubicación de logs del sistema (`/var/log/proyecto/`).

**Comando de Configuración (crontab):**
```bash
*/30 * * * * /home/adminsys/proyecto-linux-grupo5/proyecto/scripts/reporte_sistema.sh >> /var/log/proyecto/reporte_sistema.log 2>&1
```

## 3. CONTROL DE VERSIONES
En esta fase se implementó el control de versiones utilizando Git y GitHub para mantener el historial de cambios y facilitar la colaboración del grupo.

### Repositorio Local
Se inicializó el repositorio local dentro del directorio `/proyecto` con el comando:
```bash
git init
```

Luego se realizó el primer commit con toda la estructura del proyecto:
```bash
git add .
git commit -m "Primer commit con estructura del proyecto"
```
### Repositorio Remoto

Se creó el repositorio remoto en GitHub con el nombre proyecto-linux-grupo5, y se vinculó mediante:
```bash
git remote add origin https://github.com/LR24003/proyecto-linux-grupo5.git
git branch -M main
git push -u origin main
```

### Sincronización

Cada integrante clonó el repositorio desde GitHub con:
```bash
git clone https://github.com/LR24003/proyecto-linux-grupo5.git
```

y mantuvo su versión actualizada usando los comandos:
```bash
git pull
git add .
git commit -m "Actualización del proyecto"
git push
```
# 4. CONFIGURACIÓN DE DOCKER

Para esta etapa se realizó la instalación, configuración y verificación del entorno Docker dentro del sistema.

### Verificación de instalación y versión de Docker
Se confirmó que Docker se encontraba instalado y funcionando correctamente mediante:

```bash
docker --version
sudo systemctl status docker
```

Asignación de permisos a usuarios

Se agregaron los usuarios adminsys y tecnico al grupo de Docker:
```bash
sudo usermod -aG docker adminsys
sudo usermod -aG docker tecnico
```
Prueba inicial con imagen hello-world

Se ejecutó el contenedor de prueba para verificar que Docker funcionara sin errores:
```bash
sudo docker run hello-world
```

# 5. SERVICIO WEB CONTAINERIZADO

### Creación del archivo HTML personalizado
En el directorio `/proyecto/web/` se creó el archivo `index.html`, el cual contiene la página personalizada del grupo 
Este archivo se utilizó como contenido principal del servidor web dentro del contenedor Nginx.

### Vista previa del sitio web
El contenedor inicial se ejecutó utilizando Nginx con el siguiente comando:

```bash
sudo docker run -d -p 8080:80 --name nginx-servidor-grupo5 nginx
```
El sitio personalizado fue accesible desde:
http://localhost:8080

Creación de la imagen personalizada del servidor web

Se construyó una imagen propia utilizando el contenido del directorio /web/:
```bash
sudo docker build -t nginx-servidor-grupo5 .
```
Verificación del contenedor

Se verificó que el contenedor estuviera corriendo mediante:
```bash
sudo docker ps
```
También se revisaron los logs del servidor:
```bash
sudo docker logs nginx-servidor-grupo5
```
Actualización del repositorio

El archivo HTML creado fue agregado y versionado correctamente en el repositorio del proyecto.

# 6. DOCKER AVANZADO

### Creación del Dockerfile personalizado
Dentro del directorio `/proyecto/` se creó un archivo `Dockerfile` basado en la imagen oficial de Nginx. 
Este archivo permite copiar el contenido del sitio web personalizado y preparar un servidor web completo dentro del contenedor.

Contenido del Dockerfile utilizado en el proyecto:

```dockerfile
FROM nginx:latest

# Copiar contenido del directorio web al servidor nginx del contenedor
COPY web/ /usr/share/nginx/html/

# Exponer el puerto 80 para que el contenedor pueda servir contenido
EXPOSE 80

# Mantener nginx en ejecución
CMD ["nginx", "-g", "daemon off;"]
```
Construcción de la imagen personalizada

Se construyó la imagen usando el Dockerfile creado con el siguiente comando:
```bash
sudo docker build -t servidor-grupo5 .
```
Esta imagen contiene el servidor web completamente configurado y con el sitio del grupo incorporado.

Ejecución del contenedor avanzado

El contenedor final se ejecutó mapeando el puerto 8081 del host al puerto 80 del contenedor:
```bash
sudo docker run -d -p 8081:80 --name servidor-grupo5 servidor-grupo5
```

La página personalizada del proyecto se mostró correctamente al acceder a:
http://localhost:8081

Verificación del funcionamiento

Se comprobó el estado del contenedor mediante:
```bash
sudo docker ps
```
Se validó que la imagen personalizada estuviera corriendo sin errores.


Comparación con la imagen oficial de Nginx

Se ejecutó también un contenedor con la imagen oficial de Nginx para comparar:
```bash
sudo docker run -d -p 8080:80 --name nginx-oficial nginx:latest
```

Diferencias entre el contenedor oficial y el personalizada

Aunque ambos usan la misma imagen base (`nginx:latest`), la diferencia principal es:
- **Contenedor oficial (`nginx-oficial`)**: muestra la página por defecto de Nginx y se ejecutó en el puerto **8080**.
- **Contenedor personalizado (`servidor-grupo5`)**: sirve el contenido HTML del proyecto (carpeta `web/`) y se ejecutó en el puerto **8081**.

La imagen es la misma, solo cambia el contenido servido y el puerto expuesto.

Ambos contenedores funcionaron correctamente, demostrando que la imagen avanzada construida por el grupo está activa y operativa.

# 7. Conclusiones

El desarrollo de este proyecto permitió aplicar de manera práctica múltiples conceptos fundamentales de la administración de sistemas Linux. Se implementó la gestión de usuarios y permisos, la automatización de tareas mediante cron, el uso de Git como herramienta de control de versiones y el despliegue de servicios mediante contenedores Docker.

La creación de un servidor web personalizado utilizando Nginx dentro de un contenedor demostró la importancia de la containerización y la modularidad en entornos modernos. A través del Dockerfile personalizado, se integró exitosamente el sitio web del grupo dentro de una imagen propia, la cual funcionó correctamente al compararse con la imagen oficial de Nginx.

En conjunto, el proyecto fortaleció el dominio de herramientas esenciales para la administración de servidores, la automatización de procesos y la gestión eficiente de infraestructura basada en software libre.

