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
