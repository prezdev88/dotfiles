#!/bin/bash

# Obtener la lista de dispositivos emparejados y darle un formato amigable para rofi
# Ejemplo de salida: "LE_WH-1000XM3 (38:18:4C:4C:0D:EF)"
DEVICES=$(bluetoothctl devices | sed -E 's/Device ([0-9A-F:]+) (.*)/\2 (\1)/')

# Pasarle la lista a rofi y guardar la opción que elija el usuario
# -dmenu convierte a rofi en un menú de selección
# -i hace que la búsqueda no distinga entre mayúsculas y minúsculas
# -p "Bluetooth:" es el texto del prompt
SELECTED=$(echo "$DEVICES" | rofi -dmenu -i -p "Bluetooth:")

# Si el usuario cierra rofi sin seleccionar nada, salimos del script
if [ -z "$SELECTED" ]; then
    exit 0
fi

# Extraer la dirección MAC (lo que está entre los paréntesis)
MAC=$(echo "$SELECTED" | grep -o -E '([0-9A-F:]{17})')

if [ -n "$MAC" ]; then
    # Nombre del dispositivo sin la MAC (para mostrar en la notificación)
    DEVICE_NAME=$(echo "$SELECTED" | sed -E 's/ \([0-9A-F:]+\)//')

    # Comprobar si ya está conectado para alternar (conectar/desconectar)
    if bluetoothctl info "$MAC" | grep -q "Connected: yes"; then
        if command -v notify-send &> /dev/null; then
            notify-send "Bluetooth" "Desconectando $DEVICE_NAME..." -t 3000
        fi
        bluetoothctl disconnect "$MAC"
    else
        if command -v notify-send &> /dev/null; then
            notify-send "Bluetooth" "Conectando $DEVICE_NAME..." -t 3000
        fi
        bluetoothctl connect "$MAC"
    fi
fi
