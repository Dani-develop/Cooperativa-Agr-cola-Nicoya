# Evidencias: ftp

Estado: **registrado** el 25/10/2026, más impacto estructural y de cliente del 30/10/2026. Referencias: C04/T04.

Evidencia sin datos privados (no se incluyen contraseñas ni hashes; los ejemplos de comandos usan marcadores `<clave>`).

## Contexto

- Equipo: `cooperativa-server` (Ubuntu 24.04+, host del proyecto). Usuario de administración: `axel`. Responsable FTP: Frander.
- Servicio: `vsftpd 3.0.5-0.4`, manejado con systemd, activo y habilitado tras el arranque del 25/10/2026.
- Fuente versionada y reproducible: `config/vsftpd/` — [`vsftpd.conf`](../../config/vsftpd/vsftpd.conf), [`crear-usuarios-ftp.sh`](../../config/vsftpd/crear-usuarios-ftp.sh), [`aplicar-ftp.sh`](../../config/vsftpd/aplicar-ftp.sh), propuesta de diseño en [`propuesta-ftp.md`](../../config/vsftpd/propuesta-ftp.md).

## 1. Primer arranque del servicio tras aplicar la conf — 25/10/2026 23:44

`journalctl -u vsftpd`:

```
Oct 25 23:44:18 cooperativa-server systemd[1]: Starting vsftpd.service - vsftpd FTP server...
Oct 25 23:44:18 cooperativa-server systemd[1]: Started vsftpd.service - vsftpd FTP server.
```

## 2. Rechazo de acceso anónimo — 25/10/2026

`/var/log/vsftpd.log`, primer intento de conexión sin cuenta (correcto: `anonymous_enable=NO`):

```
Sun Oct 25 23:44:37 2026 [pid 144847] CONNECT: Client "::ffff:192.168.50.1"
Sun Oct 25 23:44:39 2026 [pid 144846] [anonymous] FAIL LOGIN: Client "::ffff:192.168.50.1"
```

Respuesta de verificación con cliente (`curl ftp://...`, con credenciales anónimas): exit 67, `530 Login incorrect`.

## 3. Estructura chroot y aislamiento — 25/10/2026

Permisos observados (por usuario, 5 cuentas `ftp-*` con grupo común `ftp-proyecto`):

```
/home/ftp-andrews/          drwxr-xr-x  root        root          755   ← chroot NO escribible
/home/ftp-andrews/subida    drwx------  ftp-andrews ftp-proyecto  700   ← escritura privada
```

Prueba de contramedida con protocolo crudo (desde el chroot de un usuario):

| Acción | Respuesta del servidor |
|---|---|
| `CWD ..` | vuelve a `/` (límite del chroot) |
| `CWD ../../` | vuelve a `/` (idem) |
| `CWD /home` | `550` — denegado |

La vista de `ftp-andrews` no contiene la carpeta de `ftp-frander`: el aislamiento es estructural (chroot), no de visibilidad.

## 4. Cuentas FTP fuera de SSH — 25/10/2026

Intento `ssh ftp-andrews@<servidor>`: `Permission denied` — shell `/usr/sbin/nologin` (vánida para el requisito, aparte del fix de PAM documentado en el diseño D6).

## 5. Impacto estructural y cliente — 30/10/2026

Cambios: carpeta compartida `trabajo/` (775, grupo `ftp-proyecto`) en cada chroot; bind-mounts permanentes de `/var` (5 usuarios) y `/etc` + `/srv` (ftp-daniel) agregados a `/etc/fstab` (persisten tras reinicio); ACLs sobre los montajes. Cliente probado desde host: `lftp -u ftp-andrews ftp://100.78.86.80`.

`/var/log/vsftpd.log`:

```
Fri Oct 30 21:44:58 2026 [pid 18989] [ftp-andrews] OK LOGIN: Client "::ffff:100.78.86.80"
Fri Oct 30 21:48:50 2026 [pid 20193] CONNECT: Client "::ffff:100.78.86.80"
Fri Oct 30 21:48:51 2026 [pid 20192] [ftp-andrews] OK LOGIN: Client "::ffff:100.78.86.80"
```

Solidez: `vsftpd` acepta conexiones IPv4 sobre el socket dual-stack IPv6 (`listen_ipv6=YES`).
