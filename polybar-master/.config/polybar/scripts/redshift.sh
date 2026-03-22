#!/bin/bash

# Obtiene la información de Redshift
output=$(redshift -p 2>/dev/null)

# Extrae la temperatura de color
temp=$(echo "$output" | grep 'Temperatura de color' | awk '{print $4}')

# Si no se puede obtener el valor, mostrar un mensaje predeterminado
if [ -z "$temp" ]; then
    echo "N/A"
else
    echo "${temp}K"
fi
