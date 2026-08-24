#!/bin/bash

# MAC Address of Sony WH-1000XM3
MAC="38:18:4C:4C:0D:EF"

# Comprobar si ya están conectados
if bluetoothctl info $MAC | grep -q "Connected: yes"; then
    # Lanzar la notificación ANTES de desconectar
    if command -v notify-send &> /dev/null; then
        notify-send "Bluetooth" "Desconectando audífonos Sony..." -t 3000
    fi
    
    # Si están conectados, desconectarlos
    bluetoothctl disconnect $MAC
else
    # Lanzar la notificación ANTES de conectar
    if command -v notify-send &> /dev/null; then
        notify-send "Bluetooth" "Conectando audífonos Sony..." -t 3000
    fi
    
    # Si no están conectados, conectarlos
    bluetoothctl connect $MAC
fi
