# FTP con vsftpd

Estado: **implementado y aplicado en el servidor** el 25/10/2026 (extendido el 30/10/2026). C04/T04.

## Contenido de esta carpeta

| Archivo | Qué es |
|---|---|
| [`vsftpd.conf`](vsftpd.conf) | Configuración efectiva del servidor (comentada). Se aplica con `sudo cp vsftpd.conf /etc/vsftpd.conf` tras hacer respaldo en `/etc/vsftpd.conf.bak` |
| [`crear-usuarios-ftp.sh`](crear-usuarios-ftp.sh) | Solo crea las 5 cuentas con su estructura chroot (`root:root 755` en el home, `subida/` 700) |
| [`aplicar-ftp.sh`](aplicar-ftp.sh) | Todo en uno: instala vsftpd, respalda la conf, crea usuarios, aplica `vsftpd.conf` y reinicia el servicio (`CLAVE=<clave> sudo -E bash aplicar-ftp.sh`) |
| [`propuesta-ftp.md`](propuesta-ftp.md) | Propuesta original de diseño (decisiones D1–D5, integración con respaldos, matriz de pruebas y registro de verificación del 25/10/2026) |

No incluir contraseñas en Git: los scripts toman la contraseña por variable de entorno (`CLAVE`) o la piden interactivamente.

## Orden de aplicación en el servidor

```bash
sudo apt-get update && sudo apt-get install vsftpd
sudo cp /etc/vsftpd.conf /etc/vsftpd.conf.bak   # si aún no existe
sudo bash crear-usuarios-ftp.sh                  # pedirá las 5 contraseñas
sudo cp vsftpd.conf /etc/vsftpd.conf
sudo systemctl restart vsftpd && sudo systemctl enable vsftpd
```

## Nota PAM (Ubuntu)

`/etc/pam.d/vsftpd` incluye `pam_shells.so`, que rechaza el shell `/usr/sbin/nologin` de las cuentas FTP. Contramedida aplicada: agregar `/usr/sbin/nologin` a `/etc/shells` (las cuentas pasan PAM y siguen bloqueadas para SSH).

## Reversión

Restaurar `/etc/vsftpd.conf.bak` con `sudo cp /etc/vsftpd.conf.bak /etc/vsftpd.conf && sudo systemctl restart vsftpd`.

Documentación y resultados: [docs/05-ftp-y-permisos.md](../../docs/05-ftp-y-permisos.md) · evidencia: [evidencias/ftp/README.md](../../evidencias/ftp/README.md).
