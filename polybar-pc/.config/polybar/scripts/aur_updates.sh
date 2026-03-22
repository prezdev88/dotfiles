#!/bin/bash

# Verifica actualizaciones en AUR usando yay
aur_updates=$(yay -Qua 2> /dev/null | wc -l)

# Si hay errores (por ejemplo, sin conexión), establece 0 actualizaciones
aur_updates=${aur_updates:-0}

# Muestra el número de actualizaciones
echo "$aur_updates"
