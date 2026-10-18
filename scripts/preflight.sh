#!/usr/bin/env bash
# Inventario de solo lectura para Ubuntu. No cargar .env ni usar sudo.
set -u

if [[ "$(uname -s)" != "Linux" ]]; then
  printf '%s\n' 'Ejecutar dentro de la VM Ubuntu del proyecto.' >&2
  exit 2
fi

show() {
  printf '\n### %s\n' "$1"
  shift
  if command -v "$1" >/dev/null 2>&1; then
    "$@" 2>&1 || printf '%s\n' '[No disponible o sin permisos; registrar el resultado.]'
  else
    printf 'Herramienta ausente: %s\n' "$1"
  fi
}

printf '%s\n' 'INVENTARIO DEL PROYECTO - SOLO LECTURA'
show 'Fecha con zona horaria' date --iso-8601=seconds
show 'Sistema' uname -sr
if [[ -r /etc/os-release ]]; then
  while IFS= read -r line; do
    case "$line" in PRETTY_NAME=*|VERSION_ID=*) printf '%s\n' "$line" ;; esac
  done < /etc/os-release
fi
show 'CPU disponibles' nproc
show 'Memoria' free -h
show 'Disco raíz' df -h /
show 'Interfaces IPv4' ip -br -4 address
show 'Rutas IPv4' ip -4 route
show 'Docker' docker --version
show 'Compose' docker compose version
show 'Git' git --version
show 'Apache' apache2 -v
show 'BIND9' named -v
show 'Puertos TCP en escucha' ss -tln
show 'Puertos UDP en escucha' ss -uln
printf '\n%s\n' 'Completar docs/inventario.md con valores observados. Este informe no aprueba requisitos.'
