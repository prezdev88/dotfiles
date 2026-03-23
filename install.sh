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

# Función para limpiar conflictos antes de hacer stow
clean_conflicts() {
    local pkg=$1
    msg "Limpiando conflictos para $pkg..."
    
    # Buscamos archivos en el paquete y verificamos sus destinos en el HOME
    # Usamos -mindepth 1 para no procesar la carpeta del paquete en sí
    find "$pkg" -mindepth 1 -maxdepth 2 | while read -r source; do
        # Convertimos la ruta del paquete a la ruta equivalente en el HOME
        # Ej: i3-pc/.config/i3 -> ~/.config/i3
        local relative_path=$(echo "$source" | sed "s|^$pkg/||")
        local target="$HOME/$relative_path"
        
        if [ -e "$target" ] || [ -L "$target" ]; then
            # Si ya es un enlace simbólico a nuestro repo, no hacemos nada
            if [ -L "$target" ] && [[ $(readlink -f "$target") == $(readlink -f "$source") ]]; then
                continue
            fi
            
            # Si no, procedemos a borrarlo para que stow pueda crear el enlace
            echo "  ${DOT_YELLOW}Removiendo existente:${DOT_NORMAL} $target"
            rm -rf "$target"
        fi
    done
}

# Función para aplicar stow
stow_package() {
    local pkg=$1
    
    # Primero limpiamos conflictos
    clean_conflicts "$pkg"
    
    msg "Instalando $pkg con stow..."
    if stow "$pkg"; then
        success "$pkg enlazado correctamente."
    else
        error "Hubo un error al ejecutar stow para $pkg."
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
