#!/bin/bash

# Terminar todas las instancias existentes de Polybar
killall -q polybar

# Esperar a que los procesos se detengan
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Lanzar las barras
polybar topbar &
polybar bottombar &
