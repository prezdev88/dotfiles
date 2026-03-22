#!/bin/bash

# Configura la interfaz de red activa
interface="enp2s0"  # Cambia si usas otra interfaz, como wlan0

# Obtiene el contador de bytes inicial
rx1=$(cat /proc/net/dev | grep "$interface" | awk '{print $2}')
sleep 1
# Obtiene el contador de bytes después de 1 segundo
rx2=$(cat /proc/net/dev | grep "$interface" | awk '{print $2}')

# Calcula la diferencia y convierte a bits por segundo (bps)
bytes=$((rx2 - rx1))
speed=$((bytes * 8 / 1024 / 1024)) # Convierte a Mbps

# Muestra la velocidad en Mbps con formato
if [ "$speed" -lt 1 ]; then
    echo "$((bytes * 8 / 1024)) Kbps"
else
    echo "$speed Mbps"
fi
