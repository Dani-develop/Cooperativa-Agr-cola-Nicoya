# FTP y permisos

Estado: **implementado en el servidor** (cooperativa-server) y verificado el 25 y 30 de octubre de 2026. C04/T04 exige aislamiento efectivo, no solo cinco inicios de sesión.

## Decisiones de diseño

| # | Decisión | Justificación |
|---|---|---|
| D1 | vsftpd en el **host**, no dentro del contenedor | La plataforma web es Docker (WordPress + MariaDB); FTP es infraestructura de operación. En contenedor complicaría la config y fuera evita duplicación. |
| D2 | Cuentas del sistema **dedicadas** `ftp-<nombre>` | Separadas de las cuentas personales del sistema (p. ej. `ftp-axel` ≠ usuario admin `axel`): no se expone la cuenta de administración. Simples y auditables con `id <usuario>`. |
| D3 | Aislamiento por **chroot** | `chroot_local_user=YES` encierra a cada usuario en `/home/<usuario>`: ni siquiera puede *ver* las carpetas de los demás. Es más fuerte que impedir por permisos. |
| D4 | Home seguro: chroot no escribible | `/home/<usuario>` → `root:root 755` (evita el bug del kernel 2.6.19 y no se necesita `allow_writeable_chroot`). `subida/` → `<usuario>:ftp-proyecto 700` (único punto propio de escritura). |
| D5 | `local_umask=022` | Todo lo subido queda 644/755. |
| D6 | Shell `/usr/sbin/nologin` | Las cuentas FTP quedan bloqueadas para SSH; el acceso es solo por el servicio FTP. |
| D7 | Bind-mounts permanentes en `fstab` | Exposición de lectura de `/var` (todos) y `/etc` + `/srv` (solo ftp-daniel) dentro del chroot, para diagnóstico. Ver §Estructura. |

## Cuentas creadas (25/10/2026)

| Usuario | UID | Grupo | Shell | Rol |
|---|---|---|---|---|
| `ftp-frander` | 1001 | `ftp-proyecto` | nologin | Integrante — responsable FTP |
| `ftp-axel` | 1002 | `ftp-proyecto` | nologin | Integrante — red/DNS |
| `ftp-daniel` | 1003 | `ftp-proyecto` | nologin | Integrante — Docker |
| `ftp-ari` | 1004 | `ftp-proyecto` | nologin | Integrante — WordPress |
| `ftp-andrews` | 1005 | `ftp-proyecto` | nologin | Integrante — respaldos BD |

Estructura por usuario (chroot seguro):

```
/home/<usuario>/        root:root        755   ← chroot, NO escribible
    ├── subida/         <usuario>:ftp-proyecto  700   ← escritura privada
    ├── trabajo/        <usuario>:ftp-proyecto  775   ← escritura compartida del grupo
    └── var/            bind-mount de /var     ← solo lectura para diagnóstico
```

Nota Ubuntu/PAM: `/etc/pam.d/vsftpd` incluye `pam_shells.so`, que rechaza el shell `/usr/sbin/nologin`. Contramedida aplicada: agregar `/usr/sbin/nologin` a `/etc/shells`. Las cuentas pasan PAM y siguen bloqueadas para SSH.

## Configuración efectiva

Fuente versionada: [config/vsftpd/vsftpd.conf](../config/vsftpd/vsftpd.conf) (aplicada a `/etc/vsftpd.conf`).

Directivas clave:

- `anonymous_enable=NO` — sin acceso anónimo.
- `local_enable=YES`, `write_enable=YES` — cuentas locales con escritura.
- `chroot_local_user=YES` — aislamiento por chroot.
- `local_umask=022`, `use_localtime=YES`.
- `pasv_enable=YES`, puertos pasivos `40000–40100` (rango a cubrir en el firewall/red del laboratorio).
- `xferlog_enable=YES` → `/var/log/vsftpd.log`; `connect_from_port_20=YES` (modo activo).
- Banner: `FTP Cooperativa Agricola Nicoya - EIF4310`.
- `listen=NO`, `listen_ipv6=YES` — escucha en `*:21` (dual-stack).

Copia previa de la configuración original en el servidor: `/etc/vsftpd.conf.bak` (creado antes de aplicar cambios).

## Cómo se aplica / reproduce

En el servidor, como root:

```bash
# 1) Instalar vsftpd + respaldo de la conf original
sudo apt-get update && sudo apt-get install vsftpd
sudo cp /etc/vsftpd.conf /etc/vsftpd.conf.bak   # si aún no existe

# 2) Cuentas + estructura chroot
sudo bash crear-usuarios-ftp.sh    # pedirá asignar las 5 contraseñas

# 3) Configuración y servicio
sudo cp vsftpd.conf /etc/vsftpd.conf
sudo systemctl restart vsftpd && sudo systemctl enable vsftpd
```

Todo en un paso con [`aplicar-ftp.sh`](../config/vsftpd/aplicar-ftp.sh) (`CLAVE=<clave> sudo -E bash aplicar-ftp.sh`). Sin contraseñas en Git.

Clientes de prueba (Mint/host del servidor): `lftp -u ftp-<nombre> ftp://100.78.86.80` o el gestor de archivos con `ftp://ftp-<nombre>@<servidor>`.

## Prueba de aislamiento (T04)

Resultados registrados el 25/10/2026 — detalle y evidencia en [evidencias/ftp/README.md](../evidencias/ftp/README.md).

| # | Prueba | Resultado |
|---|---|---|
| 1 | 5 cuentas creadas: home `root:root 755`, `subida` `<usuario>:ftp-proyecto 700` | ✅ |
| 2 | vsftpd `active (running)`, puerto 21 en `*` | ✅ |
| 3 | Conf aplicada: anónimo NO / umask 022 / `chroot_local_user` / pasivos 40000–40100 | ✅ |
| 4 | Login anónimo | ✅ rechazado `530 Login incorrect` |
| 5 | Login `ftp-frander` + `put` en `subida/` | ✅ archivo queda `644 ftp-frander:ftp-proyecto` |
| 6 | SSH con cuenta FTP | ✅ rechazado (`Permission denied`, shell nologin) |
| 7 | Vista de `ftp-andrews` desde su chroot | ✅ solo ve SU `subida/`; la de frander no existe para él |
| 8 | Contramedida protocolo crudo: `CWD ..`, `CWD ../../` | ✅ vuelve a `/`; `CWD /home` → `550` — el chroot **no tiene escape** |
