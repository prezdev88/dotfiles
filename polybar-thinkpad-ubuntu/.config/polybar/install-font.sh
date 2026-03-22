#!/usr/bin/env bash
set -euo pipefail

FONT_DIR="${HOME}/.local/share/fonts"
TMP_DIR="$(mktemp -d)"
ZIP_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Hack.zip"
ZIP_FILE="${TMP_DIR}/Hack.zip"

cleanup() {
  rm -rf "${TMP_DIR}"
}
trap cleanup EXIT

echo "==> Instalando dependencias (wget, unzip, fontconfig)..."
sudo apt update
sudo apt install -y wget unzip fontconfig

echo "==> Creando directorio de fuentes: ${FONT_DIR}"
mkdir -p "${FONT_DIR}"

echo "==> Descargando Hack Nerd Font..."
wget -qO "${ZIP_FILE}" "${ZIP_URL}"

echo "==> Descomprimiendo en ${FONT_DIR}..."
unzip -o -q "${ZIP_FILE}" -d "${FONT_DIR}"

echo "==> Reconstruyendo caché de fuentes..."
fc-cache -f "${FONT_DIR}" >/dev/null
fc-cache -f >/dev/null

echo "==> Verificando instalación..."
if fc-list | grep -qi "Hack Nerd Font"; then
  echo "OK: Hack Nerd Font instalada."
  fc-list | grep -i "Hack Nerd Font" | head -n 5
else
  echo "AVISO: No encontré 'Hack Nerd Font' en fc-list."
  echo "Muestra fuentes relacionadas con 'Hack':"
  fc-list | grep -i "hack" | head -n 10
  exit 1
fi

echo
echo "Listo. Si Polybar está corriendo, reinícialo para que tome la fuente."
