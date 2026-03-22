#!/bin/bash

# Verifica actualizaciones en los repositorios oficiales
arch_updates=$(checkupdates 2> /dev/null | wc -l)

# Si hay errores (por ejemplo, sin conexión), establece 0 actualizaciones
arch_updates=${arch_updates:-0}

# Muestra el número de actualizaciones
echo "$arch_updates"
