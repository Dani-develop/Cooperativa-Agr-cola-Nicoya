#!/usr/bin/env bash
# Copia de los respaldos del servidor a la Mint (pull con rsync sobre SSH, solo lectura).
# Pensado para Cron. Solo ASCII y sin asteriscos, para poder pegarlo por SSH.
# Verifica el ultimo volcado y solo entonces aplica la retencion local.
# Procedimiento y estado de la prueba: docs/14-andres-respaldo-cron.md (paso 11).
set -u
set -o pipefail

CARPETA="${CARPETA:-$HOME/copia-cooperativa}"
CLAVE_SSH="${CLAVE_SSH:-$HOME/.ssh/id_respaldos}"
SERVIDOR="${SERVIDOR:-ftp-andrews@192.168.50.1}"
LOG="${LOG:-$HOME/copia-cooperativa.log}"
LOCK="${LOCK:-$HOME/.copia-cooperativa.lock}"
CONSERVAR=30

msg() { printf '%s %s\n' "$(date '+%F %T')" "$1" >> "$LOG"; }

exec 9>"$LOCK"
flock -n 9 || { msg "OMITIDO: otra copia en curso"; exit 0; }

msg "INICIO copia desde $SERVIDOR"
mkdir -p "$CARPETA"

# Sin --delete: si en el servidor se pierden o borran copias, aqui se conservan
rsync -a --exclude=.lock -e "ssh -i $CLAVE_SSH -o BatchMode=yes -o ConnectTimeout=15" "$SERVIDOR:/" "$CARPETA/" >> "$LOG" 2>&1
codigo=$?
if [ "$codigo" -ne 0 ]; then
  msg "ERROR rsync codigo $codigo"
  exit 1
fi

ultimo="$(ls "$CARPETA" | grep -E '^bd-[0-9]{8}-[0-9]{6}\.sql\.gz$' | sort | tail -n 1)"
if [ -z "$ultimo" ]; then
  msg "ERROR no hay volcados en $CARPETA"
  exit 1
fi
if ! ( cd "$CARPETA" && sha256sum -c "$ultimo.sha256" ) >> "$LOG" 2>&1; then
  msg "ERROR el hash del ultimo volcado no coincide: $ultimo"
  exit 1
fi
msg "OK ultimo volcado verificado: $ultimo"

# Retencion: se conservan los $CONSERVAR mas recientes de cada tipo (los nombres ordenan por fecha)
for tipo in sql tar; do
  ls "$CARPETA" | grep -E "^bd-[0-9]{8}-[0-9]{6}\.$tipo\.gz$" | sort -r | tail -n +$((CONSERVAR + 1)) | while read -r f; do
    rm -f -- "$CARPETA/$f" "$CARPETA/$f.sha256"
    msg "RETENCION eliminado $f"
  done
done

msg "FIN codigo 0"
exit 0
