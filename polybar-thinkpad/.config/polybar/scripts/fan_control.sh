#!/bin/bash

fan_path="/proc/acpi/ibm/fan"

# Si no existe el archivo del ventilador, no mostrar nada
if [ ! -f "$fan_path" ]; then
    exit 0
fi

# Función para mostrar estado del ventilador
get_status() {
    level=$(awk '/level:/ {print $2}' "$fan_path")
    speed=$(awk '/speed:/ {print $2}' "$fan_path")
    echo "$level ($speed RPM)"
}

# Función para ajustar nivel del ventilador según clic
set_level() {
    action=$1
    current=$(awk '/level:/ {print $2}' "$fan_path")

    case $action in
        left)
            if [ "$current" = "auto" ]; then
                echo level auto | sudo tee "$fan_path" > /dev/null
            elif [ "$current" -ge 1 ]; then
                next=$((current - 1))
                if [ $next -ge 1 ]; then
                    echo level $next | sudo tee "$fan_path" > /dev/null
                else
                    echo level auto | sudo tee "$fan_path" > /dev/null
                fi
            fi
            ;;
        middle)
            echo level auto | sudo tee "$fan_path" > /dev/null
            ;;
        right)
            if [ "$current" = "auto" ]; then
                echo level 1 | sudo tee "$fan_path" > /dev/null
            elif [ "$current" -ge 0 ]; then
                next=$((current + 1))
                if [ $next -le 7 ]; then
                    echo level $next | sudo tee "$fan_path" > /dev/null
                fi
            fi
            ;;
    esac
}

# Comportamiento según argumento
if [ -z "$1" ]; then
    get_status
else
    set_level "$1"
fi
