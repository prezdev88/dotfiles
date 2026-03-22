#!/usr/bin/env bash

# Colores para la interfaz
DOT_BOLD=$(tput bold)
DOT_NORMAL=$(tput sgr0)
DOT_RED=$(tput setaf 1)
DOT_GREEN=$(tput setaf 2)
DOT_YELLOW=$(tput setaf 3)
DOT_BLUE=$(tput setaf 4)

# Función para imprimir mensajes con color
msg() {
    echo -e "${DOT_BLUE}==>${DOT_NORMAL} ${DOT_BOLD}$1${DOT_NORMAL}"
}

error() {
    echo -e "${DOT_RED}Error:${DOT_NORMAL} $1"
}

success() {
    echo -e "${DOT_GREEN}Hecho:${DOT_NORMAL} $1"
}

# Verificar si stow está instalado
if ! command -v stow &> /dev/null; then
    error "GNU Stow no está instalado. Por favor instálalo antes de continuar."
    exit 1
fi

# Obtener lista de paquetes (carpetas que no empiezan con .)
get_packages() {
    find . -maxdepth 1 -type d ! -name ".*" ! -name "." | sed 's|./||' | sort
}

# Función para aplicar stow
stow_package() {
    local pkg=$1
    msg "Instalando $pkg..."
    # Intentamos hacer stow. Si falla por archivos existentes, avisamos.
    if stow "$pkg" 2>/dev/null; then
        success "$pkg enlazado correctamente."
    else
        error "No se pudo enlazar $pkg. ¿Ya existen los archivos en ~/.config/?"
        echo "Prueba borrando la carpeta original primero (ej: rm -rf ~/.config/$pkg)"
    fi
}

# Función para quitar stow
unstow_package() {
    local pkg=$1
    msg "Desinstalando $pkg..."
    if stow -D "$pkg"; then
        success "$pkg desenlazado correctamente."
    else
        error "Hubo un problema al desenlazar $pkg."
    fi
}

# Menú principal
PS3="${DOT_YELLOW}Seleccione una opción (1-N o q para salir): ${DOT_NORMAL}"

show_menu() {
    clear
    echo -e "${DOT_BOLD}--- Gestor de Dotfiles (Stow) ---${DOT_NORMAL}"
    echo "Carpeta actual: $(pwd)"
    echo "---------------------------------"
    
    packages=($(get_packages))
    
    options=("Instalar TODO" "Desinstalar TODO" "${packages[@]}" "Salir")
    
    select opt in "${options[@]}"; do
        case $opt in
            "Instalar TODO")
                for p in "${packages[@]}"; do stow_package "$p"; done
                break ;;
            "Desinstalar TODO")
                for p in "${packages[@]}"; do unstow_package "$p"; done
                break ;;
            "Salir")
                msg "¡Hasta luego!"
                exit 0 ;;
            *)
                if [[ -n $opt ]]; then
                    stow_package "$opt"
                else
                    error "Opción no válida."
                fi
                break ;;
        esac
    done
}

# Bucle infinito para el menú
while true; do
    show_menu
    read -p "Presione Enter para continuar..."
done
