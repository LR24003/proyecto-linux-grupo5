#!/bin/bash

# --- 2.1 Script de Monitoreo del Sistema ---

echo "          REPORTE DEL SISTEMA"

# 1. Fecha y hora actual
echo " Fecha y Hora: $(date '+%Y-%m-%d %H:%M:%S')"

# 2. Nombre del host del sistema
echo " Nombre del Host: $(hostname)"

# 3. Número de usuarios conectados
echo " Usuarios Conectados: $(who | wc -l)"

# 4. Espacio libre en el disco principal
echo " Espacio Libre en Disco (/): $(df -h / | tail -n 1 | awk '{print $4}')"

# 5. Memoria RAM disponible
echo " Memoria RAM Disponible: $(free -h | awk '/Mem/ {print $7}')"

# 6. Número de contenedores Docker activos
echo " Contenedores Docker Activos: $(docker ps -q | wc -l)"

echo "--------------------------------------------------"
echo ""
