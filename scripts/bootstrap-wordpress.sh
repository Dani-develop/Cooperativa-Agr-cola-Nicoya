#!/usr/bin/env bash
# C02/C03: inicializa solo un sitio nuevo; no cambia una instalación existente.
set -euo pipefail
fuente=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
cd "$fuente"
[[ -n ${WP_BOOT_ADMIN_USER:-} ]] || read -rp 'Administrador tecnico WordPress: ' WP_BOOT_ADMIN_USER
[[ -n ${WP_BOOT_ADMIN_EMAIL:-} ]] || read -rp 'Correo del administrador: ' WP_BOOT_ADMIN_EMAIL
if [[ -z ${WP_BOOT_ADMIN_PASSWORD:-} ]]; then
    read -rsp 'Clave nueva de al menos 16 caracteres: ' WP_BOOT_ADMIN_PASSWORD
    printf '\n'
fi
export WP_BOOT_ADMIN_USER WP_BOOT_ADMIN_EMAIL WP_BOOT_ADMIN_PASSWORD
docker compose exec -T --user www-data \
    --env WP_BOOT_ADMIN_USER --env WP_BOOT_ADMIN_EMAIL --env WP_BOOT_ADMIN_PASSWORD \
    wordpress php < "$fuente/config/wordpress/instalar.php"
unset WP_BOOT_ADMIN_PASSWORD
