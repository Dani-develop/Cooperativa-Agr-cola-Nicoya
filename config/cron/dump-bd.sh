#!/bin/bash
# C05: volcado logico de cooperativa_wp. Corre como root via sudo (regla limitada a este script).
set -euo pipefail
umask 027
export PATH=/usr/local/bin:/usr/bin:/bin

DEST=/var/backups/cooperativa
COMPOSE=/srv/cooperativa/compose.yaml
marca=$(date +%Y%m%d-%H%M%S)
final="$DEST/bd-$marca.sql.gz"
tmp="$DEST/.bd-$marca.$$.tmp"
tmps="$DEST/.bd-$marca.$$.sha.tmp"
trap 'rm -f "$tmp" "$tmps"' EXIT

# Abrir con O_EXCL (noclobber): no sigue symlinks. Escribir y ajustar modo por descriptor.
set -C
exec 8>"$tmp"
exec 7>"$tmps"
set +C
chmod 0640 /proc/self/fd/8 /proc/self/fd/7

docker compose -f "$COMPOSE" exec -T bd sh -c 'exec mariadb-dump --single-transaction --routines --triggers --events -u"$MARIADB_USER" -p"$MARIADB_PASSWORD" "$MARIADB_DATABASE"' | gzip >&8

gzip -t "$tmp"
sha256sum < "$tmp" | sed "s|-\$|bd-$marca.sql.gz|" >&7
mv -f "$tmp" "$final"
mv -f "$tmps" "$final.sha256"
echo "OK $final $(stat -c %s "$final") bytes"
