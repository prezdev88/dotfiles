#!/bin/bash

# Encuentra el sink en RUNNING
current_sink=$(pactl list short sinks | grep "RUNNING" | awk '{print $2}')

# Si no hay un sink en RUNNING, usa el primero de la lista
if [ -z "$current_sink" ]; then
    current_sink=$(pactl list short sinks | awk 'NR==1 {print $2}')
fi

# Verifica si hay un sink
if [ -z "$current_sink" ]; then
    echo "N/A"
    exit 1
fi

# Mapear nombres internos a descripciones personalizadas
case "$current_sink" in
    bluez_sink.38_18_4C_4C_0D_EF.a2dp_sink)
        echo "%{F#03A9F4}󰂯%{F-} WH-1000XM3"  # Azul
        ;;
    alsa_output.pci-0000_00_1f.3.analog-stereo)
        echo "%{F#FF0000}󱡬%{F-} Altavoces Analógicos"  # Rojo
        ;;
    alsa_output.pci-0000_01_00.1.hdmi-stereo)
        echo "%{F#FFA500}󰡁%{F-} HDMI"  # Naranjo
        ;;
    *)
        echo "Dispositivo Desconocido ($current_sink)"
        ;;
esac
