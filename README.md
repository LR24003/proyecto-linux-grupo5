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

## 1. Configuración de Host, Usuarios, Grupos y Permisos

1.1 Configuración del hostname
Se asignó un nombre al servidor para identificarlo dentro del entorno del proyecto:

```bash
sudo hostnamectl set-hostname servidor-grupo5
```
1.2 Creación de usuarios

Se crearon los usuarios necesarios según los roles definidos en el proyecto:

```bash
sudo adduser adminsys
sudo adduser tecnico
sudo adduser visitante
```

1.3 Creación de grupos

Se crearon los grupos que clasifican los permisos del sistema:

```bash
sudo groupadd soporte
sudo groupadd web
```
Se comprobó su creación revisando el archivo de grupos del sistema:
```bash
cat /etc/group
```
1.4 Agregar usuarios a grupos

Se asignaron los usuarios a los grupos correspondientes:
```bash
sudo usermod -aG sudo adminsys
sudo usermod -aG soporte tecnico
sudo usermod -aG web visitante
getent group soporte
getent group web
```
Explicación:

- En el grupo soporte se agregó el usuario tecnico.
- En el grupo web se agregó el usuario visitante.

De esta forma cada usuario queda asociado al grupo que le corresponde.

1.5 Creación de estructura de directorios y permisos

1.5.1 Creación del directorio /proyecto

Se creó la estructura base del proyecto con las carpetas solicitadas:
```bash
sudo mkdir -p /proyecto/{datos,web,scripts,capturas}
cd /proyecto
ls
```
Esto genera las carpetas datos, web, scripts y capturas dentro de /proyecto.

1.5.2 Asignación de grupos a directorios

Se asignaron los grupos a los directorios correspondientes:
```bash
sudo chown :soporte /proyecto/datos
sudo chown :web /proyecto/web
ls -ld /proyecto/datos /proyecto/web
```
En el grupo soporte se deja la carpeta datos y en el grupo **webla carpetaweb`.

1.5.3 Configuración de herencia de grupo (setgid)

Para que los nuevos archivos creados dentro de los directorios mantengan el grupo correcto, se activó el bit setgid:
```bash
sudo chmod g+s /proyecto/datos
sudo chmod g+s /proyecto/web
ls -ld /proyecto/datos /proyecto/web
```
Con esto se confirma que la herencia de grupo se aplica correctamente en ambas carpetas.

## 2. AUTOMATIZACIÓN Y MONITOREO

2.1 Script de Monitoreo del Sistema

Dentro del directorio de scripts del proyecto se creó el archivo `reporte_sistema.sh` con el siguiente procedimiento:

```bash
cd /proyecto-linux-grupo5/proyecto/scripts
nano reporte_sistema.sh
chmod +x reporte_sistema.sh
```
El contenido del script fue el siguiente:
```bash
#!/bin/bash

echo "------------- REPORTE DEL SISTEMA -------------"

# 1. Fecha y hora actual
echo "Fecha y Hora: $(date '+%Y-%m-%d %H:%M:%S')"

# 2. Nombre del host del sistema
echo "Nombre del Host: $(hostname)"

# 3. Número de usuarios conectados
echo "Usuarios Conectados: $(who | wc -l)"

# 4. Espacio libre en el disco principal
echo "Espacio Libre en Disco (/): $(df -h / | tail -n 1 | awk '{print $4}')"

# 5. Memoria RAM disponible
echo "Memoria RAM Disponible: $(free -h | awk '/Mem/ {print $7}')"

# 6. Número de contenedores Docker activos
echo "Contenedores Docker Activos: $(docker ps -q | wc -l)"

echo "-----------------------------------------------"
echo ""
```
Explicación:
El script reporte_sistema.sh utiliza comandos básicos de Linux para obtener estadísticas del sistema:

- date → obtiene la hora actual.
- hostname → muestra el nombre del servidor.
- who | wc -l → cuenta los usuarios conectados.
- df -h / → muestra el uso del disco del directorio raíz.
- free -h → muestra la memoria RAM disponible.
- docker ps -q | wc -l → cuenta los contenedores Docker en ejecución.

Al ejecutarlo:
```bash
./reporte_sistema.sh
```
se genera un informe completo del estado del sistema, utilizado posteriormente por cron para automatizar el monitoreo.

2.2 Automatización con Cron

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

