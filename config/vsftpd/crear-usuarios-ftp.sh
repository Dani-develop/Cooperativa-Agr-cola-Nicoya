#!/usr/bin/env bash
# ============================================================
# crear-usuarios-ftp.sh — Proyecto EIF4310 · Escenario 1
# Crea las cuentas FTP de los 5 integrantes con carpetas aisladas.
# Ejecutar en el SERVIDOR:  sudo ./crear-usuarios-ftp.sh
# ============================================================
set -euo pipefail

GRUPO="ftp-proyecto"
# Cuentas FTP dedicadas por integrante (separadas de las cuentas
# personales del sistema — ftp-axel no es el usuario admin "axel").
USUARIOS=(ftp-frander ftp-axel ftp-daniel ftp-ari ftp-andrews)
SHELL_FTP="/usr/sbin/nologin"   # Evita que los usuarios FTP entren por SSH

if [ "$(id -u)" -ne 0 ]; then
  echo "Ejecute como root o con sudo."; exit 1
fi

# Grupo común del proyecto (para auditar pertenencia)
getent group "$GRUPO" >/dev/null || groupadd "$GRUPO"

for u in "${USUARIOS[@]}"; do
  if ! id "$u" >/dev/null 2>&1; then
    echo "== Creando usuario FTP: $u =="
    adduser --disabled-password --shell "$SHELL_FTP" \
            --ingroup "$GRUPO" --gecos "FTP Escenario1" "$u"
    if [ -n "${CLAVE:-}" ]; then
      echo "$u:${CLAVE}" | chpasswd
    else
      echo ">> Asigne la contraseña de $u:"
      passwd "$u"
    fi
  else
    echo "== $u ya existe — solo se ajustan permisos =="
    usermod -aG "$GRUPO" "$u" 2>/dev/null || true
  fi

  # ---------- Estructura chroot segura ----------
  # /home/<user>  -> root:root 755 (chroot NO escribible, seguro)
  # /home/<user>/subida -> <user>:ftp-proyecto 700
  mkdir -p "/home/$u/subida"
  chown root:root "/home/$u"
  chmod 755 "/home/$u"
  chown "$u:$GRUPO" "/home/$u/subida"
  chmod 700 "/home/$u/subida"
done

echo
echo "Listo. Estructura creada:"
echo "  /home/<usuario>/subida  → cada integrante SOLO ve la suya."
echo "Siguiente paso: cp /etc/vsftpd.conf /etc/vsftpd.conf.bak"
echo "                cp vsftpd.conf /etc/vsftpd.conf"
echo "                systemctl restart vsftpd"
