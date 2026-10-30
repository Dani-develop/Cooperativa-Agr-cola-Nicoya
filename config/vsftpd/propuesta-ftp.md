# Propuesta FTP — Proyecto EIF4310 · Escenario 1 (Cooperativa Agrícola Nicoya)

Responsable FTP: Frander  ·  Grupo: frander, axel, daniel, ari, andrews

## 1. División del grupo y puntos de contacto

| Integrante | Área | Relación con FTP |
|---|---|---|
| Daniel | Contenedores Docker (WordPress + MariaDB) | FTP corre en el **host**, NO en contenedor (decisión documentada en §3) |
| Axel | Red + DNS/BIND9 | Zona DNS del proyecto: los clientes acceden por `ftp.proyecto.internal`. Enviarle registros A/CNAME de `ftp` |
| **Frander** | **Usuarios FTP (esta propuesta)** | — |
| Ari | WordPress (tema, roles, contenido) | Opcional: publicar carpeta `uploads` por FTP (§6) |
| Andrew | Respaldos de BD + Cron | Los dumps de `mysqldump` van a `/srv/respaldos` → descargables por FTP (§5) |

## 2. Objetivo del requisito

> "Servidor FTP con una cuenta de usuario por integrante del grupo, con
> permisos que impidan que un usuario borre o modifique archivos de otro."

## 3. Decisiones de diseño (para la documentación y la defensa)

**D1 — FTP en el host, no en contenedor.**
vsftpd es un servicio del sistema estable; en contenedor complicaría los puertos
pasivos y duplicaría configuración. FTP no es parte de la plataforma web: es
infraestructura de operación → pertenece al host.

**D2 — Cuentas del sistema (no virtuales).** Un `adduser` por integrante;
vsftpd las usa con `local_enable=YES`. Simples, auditables con `id <usuario>`
y suficientes para 5 usuarios.

**D3 — Aislamiento por chroot (garantía estructural).**
`chroot_local_user=YES` encierra a cada usuario en `/home/<usuario>`;
**ni siquiera puede ver** las carpetas de los demás. Cumplir "impedir
modificar/borrar" por diseños es más fuerte que por permisos.

**D4 — Patrón de home seguro (probado en la Sesión 8).**
- `/home/<usuario>` → **root:root 755**: el chroot NO es escribible
  (evita el bug del kernel 2.6.19 y por eso NO se necesita `allow_writeable_chroot`).
- `/home/<usuario>/subida` → `<usuario>:ftp-proyecto 700`: único lugar escribible.

**D5 — `local_umask=022`.** Todo lo subido queda 644/755: otros usuarios,
aun si vieran un archivo (no lo ven, D3), no podrían editarlo.

## 4. Instalación paso a paso (en el servidor)

```bash
# 1) Servidor FTP
sudo apt-get update && sudo apt-get install vsftpd
sudo cp /etc/vsftpd.conf /etc/vsftpd.conf.bak

# 2) Estructura + cuentas (pedirá asignar 5 contraseñas)
sudo bash crear-usuarios-ftp.sh

# 3) Configuración
sudo cp vsftpd.conf /etc/vsftpd.conf
sudo systemctl restart vsftpd
sudo systemctl enable vsftpd
sudo systemctl status vsftpd          # debe decir active (running)
```

Resultado por usuario:
```
/home/frander/          root:root   755   ← chroot (no escribible)
    └── subida/         frander     700   ← único punto de escritura
/home/axel/ ...
/home/daniel/ ... /home/ari/ ... /home/andrews/ ...
```

## 5. Integración con respaldos (Andrew) — OPCIONAL, vale la pena

Si Andrew escribe los dumps en `/srv/respaldos` (root:root 755), cada
integrante puede *leer* los respaldos dentro de su chroot con un bind-mount:

```bash
# por cada usuario u (ejemplo frander)
sudo mkdir -p /home/frander/respaldos
sudo mount --bind /srv/respaldos /home/frander/respaldos
sudo chmod 755 /home/frander/respaldos
# permanente: una línea mount --bind en /etc/fstab con bind,ro
```
Cada integrante descarga el respaldo fresco por FTP sin poder borrarlo
(no tiene escritura ahí) → refuerza también el requisito "prueba de
restauración documentada" del grupo.

## 6. Conexión de los clientes (demo)

Gestor de archivos de Mint (Ctrl+L en Nemo):
- Con IP:      `ftp://ftp-frander@<IP-del-servidor>`
- Con DNS (cuando Axel tenga la zona): `ftp://ftp-frander@ftp.proyecto.internal`

Terminal: `ftp <servidor>` → credenciales → `ls`, `put archivo`, `bye`.

## 7. Matriz de pruebas (evidencias a capturar)

| # | Prueba | Resultado esperado |
|---|--------|--------------------|
| 1 | Login de cada uno de los 5 usuarios | Entra y ve su `subida/` |
| 2 | frander sube archivo a su carpeta | `put` OK, dueño frander 644 |
| 3 | frander intenta listar/ver carpeta de daniel | No la ve (chroot) |
| 4 | Intento de borrar/archivo de otro usuario | Imposible: ni lo ve |
| 5 | `anonymous` / `ftp` sin cuenta | Rechazado (530 Login incorrect) |
| 6 | ssh frander@servidor | Rechazado (shell nologin) |
| 7 | Descargar un respaldo BD vía FTP (opcional §5) | Lectura OK, sin escritura |
| 8 | `systemctl status vsftpd` y `journalctl -u vsftpd -n 50` | Servicio sano / diagnóstico |

## 8. Para la documentación técnica del grupo

- Diagrama: `[Cliente Mint] → ftp://usuario@ftp.proyecto.internal → [host: vsftpd] ⇄ [Docker: wordpress + mariadb]`
- Tabla usuarios→rol→permisos (los 5 integrantes, rol "integrante").
- `vsftpd.conf` comentado (este directorio)   decision D1 en el texto.
- Capturas de la matriz de §7.
- Mejora futura declarada: FTPS (`ssl_enable=YES`, certificado propio) — FTP
  actual envía credenciales en texto plano; documentarlo demuestra criterio.

## 9. Registro de aplicación y verificación (25/10/2026 — cooperativa-server)

Más allá del diseño: los usuarios FTP son cuentas DEDICADAS `ftp-<nombre>`
(`ftp-frander`, `ftp-axel`, `ftp-daniel`, `ftp-ari`, `ftp-andrews`), separadas
de las cuentas personales del sistema para no exponer la cuenta de
administración. Contraseñas de laboratorio: `<clave-de-laboratorio>` (cambiar para producción).

Nota de instalación en Ubuntu: `/etc/pam.d/vsftpd` incluye `pam_shells.so`,
que rechaza el shell `/usr/sbin/nologin`. Solución aplicada (canónica en
Debian/Ubuntu): agregar `/usr/sbin/nologin` a `/etc/shells`. Así las cuentas
pasan PAM y siguen bloqueadas para SSH (confirmado: `Permission denied`).

| # | Prueba | Resultado |
|---|--------|-----------|
| 1 | 5 usuarios creados, home `root:root 755`, `subida` `<usuario>:ftp-proyecto 700` | ✅ |
| 2 | vsftpd active (running), puerto 21 escuchando en `*` | ✅ |
| 3 | conf aplicada: anonymous NO / umask 022 / chroot LOCAL_USER / pasv 40000-40100 | ✅ |
| 4 | Login anónimo | ❌ rechazado `530` (curl exit 67) — correcto |
| 5 | Login `ftp-frander` + subida a `subida/` | ✅ archivo quedó `644 ftp-frander:ftp-proyecto` |
| 6 | SSH con cuenta FTP | ❌ `Permission denied` — correcto |
| 7 | Vista de `ftp-andrews` | Solo ve SU `subida/` — no existe la de frander |
| 8 | Contramedida (protocolo crudo): `CWD ..`, `CWD ../../` | ✅ vuelve a `/`; `CWD /home` → `550` — **chroot no tiene escape** |

Scripts usados (reproducibles): `aplicar-ftp.sh` (todo en uno) y
`crear-usuarios-ftp.sh` (solo usuarios), ambos en este directorio.
