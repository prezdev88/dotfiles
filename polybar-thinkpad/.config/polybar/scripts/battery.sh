#!/bin/bash

# Obtiene el nivel de la batería y el estado de carga
battery_level=$(cat /sys/class/power_supply/BAT0/capacity)
charging_status=$(cat /sys/class/power_supply/BAT0/status)

# Determina el icono y el color según el nivel de batería y el estado
if [ "$charging_status" = "Charging" ]; then
    icon=""  # Icono de carga
    color="#03A9F4"  # Azul para cargar
else
    if [ "$battery_level" -ge 80 ]; then
        icon=""  # Batería llena
        color="#4CAF50"  # Verde
    elif [ "$battery_level" -ge 60 ]; then
        icon=""  # Batería 60-80%
        color="#8BC34A"  # Verde claro
    elif [ "$battery_level" -ge 40 ]; then
        icon=""  # Batería 40-60%
        color="#FFC107"  # Amarillo
    elif [ "$battery_level" -ge 20 ]; then
        icon=""  # Batería 20-40%
        color="#FF9800"  # Naranja
    else
        icon=""  # Batería baja (<20%)
        color="#F44336"  # Rojo
    fi
fi

# Imprime el icono con el color y el nivel de batería
echo "%{F$color}$icon%{F-} $battery_level%"
