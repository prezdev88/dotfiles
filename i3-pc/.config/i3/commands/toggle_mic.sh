#!/bin/bash

CARD="bluez_card.38_18_4C_4C_0D_EF"

# Obtiene el perfil activo de la tarjeta
CURRENT_PROFILE=$(pactl list cards | grep -A 50 "$CARD" | grep -E "Perfil Activo:|Active Profile:" | head -n 1 | awk -F': ' '{print $2}')

if [ "$CURRENT_PROFILE" == "a2dp_sink" ]; then
    echo "Micrófono OFF -> Encendiendo Micrófono (Cambiando a Manos Libres)..."
    pactl set-card-profile "$CARD" handsfree_head_unit
    notify-send -t 3000 -u normal "🎧 Audífonos Sony" "Micrófono ACTIVADO (Modo Manos Libres)"
elif [ "$CURRENT_PROFILE" == "handsfree_head_unit" ]; then
    echo "Micrófono ON -> Apagando Micrófono (Cambiando a Alta Fidelidad)..."
    pactl set-card-profile "$CARD" a2dp_sink
    notify-send -t 3000 -u normal "🎧 Audífonos Sony" "Micrófono DESACTIVADO (Alta Calidad)"
else
    echo "No se pudo determinar el estado actual o los audífonos no están conectados."
    echo "Estado detectado: '$CURRENT_PROFILE'"
    
    # Intento de forzar un perfil si se desconoce
    echo "Forzando perfil de Alta Fidelidad por precaución..."
    pactl set-card-profile "$CARD" a2dp_sink
    notify-send -t 3000 -u critical "🎧 Audífonos Sony" "Estado desconocido. Forzando Alta Fidelidad."
fi
