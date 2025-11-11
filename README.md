## 2. AUTOMATIZACIÓN Y MONITOREO

### 2.2 Automatización con Cron

Se configuró una tarea programada bajo el usuario `adminsys` para ejecutar el script de monitoreo cada 30 minutos, asegurando que la salida se guarde en la ubicación de logs del sistema (`/var/log/proyecto/`).

**Comando de Configuración (crontab):**
```bash
*/30 * * * * /home/adminsys/proyecto-linux-grupo5/proyecto/scripts/reporte_sistema.sh >> /var/log/proyecto/reporte_sistema.log 2>&1
