#!/usr/bin/env bash
# Restauracion de PRUEBA de la BD en un contenedor aislado (se ejecuta en la Mint).
# Trae (opcional) las copias, verifica el hash, levanta MariaDB desechable,
# carga el volcado, comprueba el resultado y limpia. No toca el sitio real.
# Solo ASCII y sin asteriscos para que no se dane al pegarlo por SSH.
# Procedimiento y estado de la prueba: docs/14-andres-respaldo-cron.md (paso 10).
#
# Uso:
#   restaurar-prueba-mint.sh                    usa el volcado mas reciente de la carpeta
#   restaurar-prueba-mint.sh ARCHIVO.sql.gz     usa ese volcado
#   Opciones: --traer (rsync antes)  --conservar (no borra el contenedor al final)
set -u
set -o pipefail

CARPETA="${CARPETA:-$HOME/copia-cooperativa}"
CLAVE_SSH="${CLAVE_SSH:-$HOME/.ssh/id_respaldos}"
SERVIDOR="${SERVIDOR:-ftp-andrews@192.168.50.1}"
IMAGEN="${IMAGEN:-mariadb:11.8.9}"
NOMBRE="bd-restauracion"
BASE="cooperativa_wp"
ESPERA=120
INTENTOS=3
LOG="${LOG:-$HOME/restauracion-prueba.log}"

TRAER=0
CONSERVAR=0
VOLCADO=""
for a in "$@"; do
  if [ "$a" = "--traer" ]; then
    TRAER=1
  elif [ "$a" = "--conservar" ]; then
    CONSERVAR=1
  elif [ "${a#-}" != "$a" ]; then
    echo "Opcion desconocida: $a" >&2
    exit 2
  else
    VOLCADO="$a"
  fi
done

msg() { printf '%s %s\n' "$(date '+%F %T')" "$1" | tee -a "$LOG"; }
fallar() { msg "ERROR: $1"; exit 1; }

# Docker: directo si se puede; si no, con sudo
if docker info >/dev/null 2>&1; then DOCKER="docker"; else DOCKER="sudo docker"; fi
$DOCKER info >/dev/null 2>&1 || fallar "no se puede usar Docker ($DOCKER)"

limpiar() {
  if [ "$CONSERVAR" -eq 0 ]; then
    $DOCKER rm -f "$NOMBRE" >/dev/null 2>&1
    msg "Contenedor $NOMBRE eliminado"
  else
    msg "Contenedor $NOMBRE conservado (borrar con: $DOCKER rm -f $NOMBRE)"
  fi
}

# Ejecuta una consulta SQL dentro del contenedor (la clave se resuelve alli)
sql() {
  $DOCKER exec "$NOMBRE" sh -c 'exec mariadb -uroot -p"$MARIADB_ROOT_PASSWORD" -N -B "$2" -e "$1"' sh "$1" "$BASE"
}

msg "INICIO restauracion de prueba"

# 1. Traer las copias
if [ "$TRAER" -eq 1 ]; then
  mkdir -p "$CARPETA"
  msg "rsync desde $SERVIDOR"
  rsync -a --exclude=.lock -e "ssh -i $CLAVE_SSH" "$SERVIDOR:/" "$CARPETA/" || fallar "rsync fallo"
fi

# 2. Elegir el volcado
if [ -z "$VOLCADO" ]; then
  VOLCADO="$CARPETA/$(ls -t "$CARPETA" | grep -E '^bd-[0-9]{8}-[0-9]{6}\.sql\.gz$' | head -n 1)"
fi
[ -f "$VOLCADO" ] || fallar "no hay volcado: $VOLCADO"
msg "Volcado: $VOLCADO ($(du -h "$VOLCADO" | cut -f1))"

# 3. Verificar el hash
if [ -f "$VOLCADO.sha256" ]; then
  ( cd "$(dirname "$VOLCADO")" && sha256sum -c "$(basename "$VOLCADO").sha256" ) >/dev/null 2>&1 \
    || fallar "el hash no coincide: volcado danado"
  msg "Hash verificado"
else
  fallar "falta $VOLCADO.sha256"
fi
gzip -t "$VOLCADO" || fallar "gzip -t fallo"

# 4. Crear el contenedor (con reintentos si el arranque es lento)
CLAVE="$(openssl rand -base64 18)"
LISTO=0
n=1
while [ "$n" -le "$INTENTOS" ] && [ "$LISTO" -eq 0 ]; do
  $DOCKER rm -f "$NOMBRE" >/dev/null 2>&1
  msg "Intento $n/$INTENTOS: creando $NOMBRE ($IMAGEN, sin puertos publicados)"
  $DOCKER run -d --name "$NOMBRE" -e MARIADB_ROOT_PASSWORD="$CLAVE" -e MARIADB_DATABASE="$BASE" "$IMAGEN" >/dev/null \
    || fallar "docker run fallo"
  t=0
  while [ "$t" -lt "$ESPERA" ]; do
    if [ "$($DOCKER inspect -f '{{.State.Running}}' "$NOMBRE" 2>/dev/null)" != "true" ]; then
      msg "El contenedor se detuvo; ultimas lineas del registro:"
      $DOCKER logs --tail 5 "$NOMBRE" 2>&1 | tee -a "$LOG"
      break
    fi
    if $DOCKER exec "$NOMBRE" healthcheck.sh --connect --innodb_initialized >/dev/null 2>&1; then
      LISTO=1
      break
    fi
    sleep 3
    t=$((t + 3))
  done
  n=$((n + 1))
done
[ "$LISTO" -eq 1 ] || { limpiar; fallar "MariaDB no arranco tras $INTENTOS intentos"; }
msg "MariaDB lista"

# 5. Cargar el volcado midiendo el tiempo
inicio=$(date +%s.%N)
zcat "$VOLCADO" | $DOCKER exec -i "$NOMBRE" sh -c 'exec mariadb -uroot -p"$MARIADB_ROOT_PASSWORD" "$1"' sh "$BASE"
codigos=("${PIPESTATUS[@]}")
fin=$(date +%s.%N)
if [ "${codigos[0]}" -ne 0 ] || [ "${codigos[1]}" -ne 0 ]; then
  limpiar; fallar "la carga fallo (zcat=${codigos[0]} mariadb=${codigos[1]})"
fi
msg "Carga completada en $(awk -v a="$inicio" -v b="$fin" 'BEGIN{printf "%.1f", b-a}') s"

# 6. Comprobaciones
TABLAS="$(sql "SELECT COUNT(1) FROM information_schema.tables WHERE table_schema='$BASE'")"
NOMBRESITIO="$(sql "SELECT option_value FROM wp_options WHERE option_name='blogname'")"
SITEURL="$(sql "SELECT option_value FROM wp_options WHERE option_name='siteurl'")"
USUARIOS="$(sql "SELECT COUNT(1) FROM wp_users")"
msg "Tablas: $TABLAS"
msg "blogname: $NOMBRESITIO"
msg "siteurl: $SITEURL"
msg "Usuarios de WordPress: $USUARIOS"

RESULTADO=0
[ "${TABLAS:-0}" -gt 0 ] 2>/dev/null || RESULTADO=1
[ "${USUARIOS:-0}" -gt 0 ] 2>/dev/null || RESULTADO=1
[ -n "$SITEURL" ] || RESULTADO=1

# 7. Limpiar
limpiar
msg "FIN codigo $RESULTADO"
exit "$RESULTADO"
