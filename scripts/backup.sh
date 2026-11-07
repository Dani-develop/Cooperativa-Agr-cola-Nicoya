#!/usr/bin/env bash
# C05: respaldo de MariaDB (cooperativa_wp) para ejecutar desde Cron.
# 1) Volcado logico (principal): sudo /usr/local/sbin/dump-bd.sh, script de root.
# 2) Copia de la carpeta de datos (secundaria, en caliente): validar con una restauracion.
set -uo pipefail
umask 077
export PATH=/usr/local/bin:/usr/bin:/bin

DUMP=/usr/local/sbin/dump-bd.sh
ORIGEN=/var/lib/docker/volumes/cooperativa-nicoya_datos_bd/_data
DESTINO=/var/backups/cooperativa
LOG=/var/log/cooperativa-backup.log
RETENCION=7
fallo=0

registrar() { printf '%s %s\n' "$(date '+%F %T')" "$*" >> "$LOG"; }

# Conserva las RETENCION copias mas recientes de un patron; se llama solo tras una copia valida
retener() {
  ls -1t "$DESTINO"/$1 2>/dev/null | tail -n +$((RETENCION + 1)) | while read -r viejo; do
    rm -f "$viejo" "$viejo.sha256"
    registrar "RETENCION eliminado $viejo"
  done
}

mkdir -p "$DESTINO" || { echo "No se pudo crear $DESTINO" >&2; exit 1; }

# Evitar ejecuciones simultaneas
exec 9>"$DESTINO/.lock"
if ! flock -n 9; then registrar "ERROR otra ejecucion en curso"; exit 1; fi

marca=$(date +%Y%m%d-%H%M%S)
tmp="$DESTINO/.bd-$marca.tar.gz.tmp"
final="$DESTINO/bd-$marca.tar.gz"
salida_f=$(mktemp)
trap 'rm -f "$tmp" "$salida_f"' EXIT

# 1) Volcado logico. Entrada desde /dev/null y salida a un archivo: con la salida capturada por
# $(...) y la entrada en la terminal, mariadb-dump se quedaba bloqueado. 9>&- evita que los
# procesos hijos hereden el bloqueo; timeout evita que un volcado atascado lo retenga.
registrar "INICIO volcado logico"
if timeout -k 10 600 sudo -n "$DUMP" < /dev/null > "$salida_f" 2>>"$LOG" 9>&-; then
  salida=$(< "$salida_f")
  ultimo=$(awk '{print $2}' <<< "$salida")
  if ( cd "$DESTINO" && sha256sum -c "$(basename "$ultimo").sha256" > /dev/null 2>&1 ); then
    registrar "$salida"
    registrar "OK hash verificado $ultimo"
    retener 'bd-*.sql.gz'
  else
    registrar "ERROR el hash del volcado no coincide: $ultimo"; fallo=1
  fi
else
  registrar "ERROR el volcado fallo"; fallo=1
fi

# 2) Copia de la carpeta de datos
registrar "INICIO copia de archivos de $ORIGEN"
tar -czf "$tmp" -C "$ORIGEN" . 2>>"$LOG"
rc=$?
if [ "$rc" -eq 1 ]; then
  registrar "AVISO tar reporto cambios durante la copia (esperado con MariaDB encendida)"
fi
if [ "$rc" -gt 1 ]; then
  registrar "ERROR tar fallo con codigo $rc"; fallo=1
elif ! gzip -t "$tmp" || ! tar -tzf "$tmp" > /dev/null; then
  registrar "ERROR el archivo generado no es valido"; fallo=1
else
  mv "$tmp" "$final"
  ( cd "$DESTINO" && sha256sum "bd-$marca.tar.gz" > "bd-$marca.tar.gz.sha256" )
  registrar "OK $final $(stat -c %s "$final") bytes"
  retener 'bd-*.tar.gz'
fi

registrar "FIN codigo $fallo"
exit "$fallo"
