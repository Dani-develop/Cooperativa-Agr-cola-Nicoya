#!/usr/bin/env bash
# ============================================================
# aplicar-ftp.sh — Proyecto EIF4310 · Escenario 1
# Un solo comando para: instalar vsftpd, crear las 5 cuentas FTP,
# aplicar vsftpd.conf y reiniciar el servicio.
# Uso (en el servidor, como root):
#   CLAVE=<clave-de-laboratorio> sudo -E bash aplicar-ftp.sh
# ============================================================
set -euo pipefail

DIR="$(cd "$(dirname "$0")" && pwd)"
export CLAVE="${CLAVE:-}"

echo "=== [1/5] Instalando vsftpd ==="
apt-get update -qq
DEBIAN_FRONTEND=noninteractive apt-get install -y vsftpd

echo "=== [2/5] Backup de la configuración original ==="
[ -f /etc/vsftpd.conf.bak ] || cp /etc/vsftpd.conf /etc/vsftpd.conf.bak

echo "=== [3/5] Creando usuarios FTP (lógica de crear-usuarios-ftp.sh) ==="
GRUPO="ftp-proyecto"
USUARIOS=(ftp-frander ftp-axel ftp-daniel ftp-ari ftp-andrews)
SHELL_FTP="/usr/sbin/nologin"

getent group "$GRUPO" >/dev/null || groupadd "$GRUPO"

for u in "${USUARIOS[@]}"; do
  if ! id "$u" >/dev/null 2>&1; then
    echo "-- Creando usuario FTP: $u"
    adduser --disabled-password --shell "$SHELL_FTP" \
            --ingroup "$GRUPO" --gecos "FTP Escenario1" "$u"
    if [ -n "$CLAVE" ]; then
      echo "${u}:${CLAVE}" | chpasswd
    else
      echo ">> Asigne la contraseña de $u:"; passwd "$u"
    fi
  else
    echo "-- $u ya existe — solo se ajustan permisos"
    usermod -aG "$GRUPO" "$u" 2>/dev/null || true
  fi

  HOME_U="/home/$u"
  mkdir -p "$HOME_U/subida"
  chown root:root "$HOME_U"
  chmod 755 "$HOME_U"
  chown "$u:$GRUPO" "$HOME_U/subida"
  chmod 700 "$HOME_U/subida"
done

echo "=== [4/5] Aplicando vsftpd.conf ==="
cp "$DIR/vsftpd.conf" /etc/vsftpd.conf

echo "=== [5/5] Reiniciando y habilitando el servicio ==="
systemctl restart vsftpd
systemctl enable vsftpd
systemctl --no-pager -l status vsftpd | head -6

echo
echo "APLICACIÓN COMPLETA ✔"
