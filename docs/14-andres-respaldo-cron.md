# Andrés: respaldo de la base de datos con Cron

Responsable: Andrés. Revisor humano: por asignar. Rama: `feature/c05-cron-andres`, creada desde el trabajo de Daniel (`9674c2b`).

## Alcance y estado

Requisito C05 / prueba T05. Este documento cubre el volcado lógico de la base de WordPress, el script de respaldo con validación y retención, su ejecución real por Cron (probada el 03/11/2026), la copia fuera del servidor hacia Mint con `rsync` y la restauración de la base en un contenedor aislado en Mint (07/11/2026), y dos scripts de Mint que automatizan la restauración de prueba y la copia periódica con Cron (pasos 10 y 11). Los scripts se probaron a mano el 13/11/2026 en una Mint reconstruida con Tailscale; el Cron de Mint se indicó como completado, sin log archivado. **Siguen pendientes** la copia y restauración de los archivos de WordPress (`wp-content`), la restauración visible por HTTPS, la reducción del ACL y la revisión de un compañero. La restauración se probó solo para la base de datos. Por eso C05 no está aprobado. Política y contrato completo en [respaldo y restauración](06-respaldo-y-restauracion.md).

## Decisiones y limitaciones

- **Volcado lógico con `sudo` limitado.** La cuenta de trabajo (`ftp-andrews`, grupo `ftp-proyecto`) no pertenece al grupo `docker`: ese grupo equivale a root. El administrador instaló un script de root, [dump-bd.sh](../config/cron/dump-bd.sh), y una regla de `sudo` que permite ejecutar solo ese script. Ejecuta `mariadb-dump --single-transaction --routines --triggers --events` dentro del contenedor `bd` con las credenciales del propio contenedor; no lee `.env`.
- **Copia de archivos como respaldo secundario.** Además se copia la carpeta de datos del volumen `datos_bd` (`mysql/` y `cooperativa_wp/`). Es una copia en caliente, equivalente a la que quedaría tras un corte de luz: InnoDB suele recuperarse solo, pero no está garantizado y las tablas Aria de `mysql/` son más frágiles. El volcado es el respaldo principal; la copia de archivos solo se acepta si la restauración aislada la valida.
- **Rutas distintas a las planificadas.** El destino es `/var/backups/cooperativa`, no el `BACKUP_DIR=/srv/respaldos-cooperativa` de [.env.example](../.env.example). Se conservan las 7 copias más recientes de cada tipo; las 4 semanales siguen sin implementar.
- **Hora del servidor: UTC.** Costa Rica es UTC-6, por lo que las 03:00 locales se programan a las `09:00` UTC.
- **ACL amplia.** `ftp-andrews` tiene `rwx` sobre la carpeta de datos de la BD y para respaldar solo hace falta `r-x`. Con el volcado en su lugar conviene reducirlo: con escritura, un error o una cuenta comprometida podría dañar la base viva.
- **Copia fuera del servidor por *pull*.** Las copias del servidor están en el disco de la VM y no protegen ante su pérdida, por eso Mint las trae con `rsync` sobre SSH. Mint inicia la conexión con una clave dedicada que en el servidor solo puede ejecutar `rrsync -ro` (lectura) sobre `/var/backups/cooperativa`: si Mint se compromete, no puede escribir ni borrar en el servidor. No se usa `--delete`, así que borrar copias en el servidor por retención no las borra en Mint (la retención de Mint está sin definir).
- **El servidor debe estar encendido a la hora del respaldo.** Cron ejecuta la tarea solo si la máquina está encendida a las 09:00 UTC (03:00 en Costa Rica) y no recupera ejecuciones perdidas. Se observó (13/11/2026) que faltan los días en que el servidor estuvo apagado. Una opción para corregirlo, no implementada: pasar el Cron del servidor a una ejecución por hora con una comprobación en `backup.sh` que omita la pasada si ya existe un volcado válido del día, como ya hace la Mint.
- **Mint por Tailscale.** La Mint llega al servidor por Tailscale (`100.102.83.103`) y no por la red interna de VirtualBox (`192.168.50.1`). La IP se pasa a los scripts con la variable `SERVIDOR`.
- **Solo la base de datos.** Los archivos de WordPress (`wp-content`: subidas, temas, plugins) viven en el volumen `archivos_wordpress` y no se respaldan todavía. Restaurar solo el SQL no recupera imágenes ni plugins (ver [diagnóstico](07-operacion-y-diagnostico.md)).

## Valores de esta instalación

| Elemento | Valor |
|---|---|
| Máquina y usuario | Ubuntu `cooperativa-server`, usuario `ftp-andrews` |
| Volcado | `sudo /usr/local/sbin/dump-bd.sh` (fuente: [config/cron/dump-bd.sh](../config/cron/dump-bd.sh)) |
| Script de respaldo | `/var/scripts/backup-bd.sh` (fuente: [scripts/backup.sh](../scripts/backup.sh)) |
| Destino | `/var/backups/cooperativa/bd-AAAAMMDD-HHMMSS.sql.gz` y `.tar.gz`, cada uno con su `.sha256` |
| Registros | `/var/log/cooperativa-backup.log` (script) y `/var/log/cooperativa-cron.log` (salida de Cron) |
| Programación | `0 9 * * *` en el crontab de `ftp-andrews` (fuente: [cooperativa-backup.cron](../config/cron/cooperativa-backup.cron)) |
| Retención | 7 volcados y 7 copias de archivos |
| Tamaños observados | Volcado ≈ 1,2 MB; copia de archivos ≈ 10,5 MB; 11 GB libres de 23 GB |
| Copia externa | Mint `axel@cooperativa-mint` trae a `~/copia-cooperativa` por `rsync` + SSH al servidor por **Tailscale, `100.102.83.103`** (13/11/2026, tras reconstruir la Mint). Antes se usaron la red interna `192.168.50.1` y la IP `100.78.86.80`, que es de otro servidor desconectado y ya no se usa |
| Clave de respaldo | `~/.ssh/id_respaldos` en Mint (ed25519, sin frase); en el servidor, línea de `authorized_keys` con `restrict,command="/usr/bin/rrsync -ro /var/backups/cooperativa"` (la instala el administrador) |
| Restauración de prueba | Contenedor `bd-restauracion` (`mariadb:11.8.9`, sin puertos publicados) en Mint, base `cooperativa_wp` vacía; automatizada con [restaurar-prueba-mint.sh](../scripts/restaurar-prueba-mint.sh) |
| Copia periódica en Mint | [copiar-respaldos-mint.sh](../scripts/copiar-respaldos-mint.sh) con Cron `15 * * * *` ([mint-copia.cron](../config/cron/mint-copia.cron)); log `~/copia-cooperativa.log`; retención 30 por tipo |

## Pasos

### 1. Comprobar el permiso del administrador

Terminal Ubuntu, como `ftp-andrews`:

```bash
sudo -n -l
```

Esperado: únicamente `(root) NOPASSWD: /usr/local/sbin/dump-bd.sh`. Revisar que el script sea de root y que no sea escribible por `ftp-andrews`:

```bash
ls -l /usr/local/sbin/dump-bd.sh
```

### 2. Probar el volcado directo

```bash
sudo /usr/local/sbin/dump-bd.sh; echo "codigo: $?"
```

```bash
cd /var/backups/cooperativa && sha256sum -c $(ls -t bd-*.sql.gz.sha256 | head -1)
```

```bash
zcat $(ls -t /var/backups/cooperativa/bd-*.sql.gz | head -1) | tail -n 2
```

Esperado: código 0; una línea `OK .../bd-<fecha>.sql.gz`; hash correcto; el volcado termina en `-- Dump completed on ...`. Los archivos pertenecen a `root` con grupo `ftp-proyecto` y modo `640`: el grupo puede leerlos y no modificarlos.

### 3. Crear el script de respaldo

Pegar el contenido de [scripts/backup.sh](../scripts/backup.sh) entre las dos líneas siguientes (no contiene tildes, para que no se dañe al pegar por SSH):

```bash
cat > /var/scripts/backup-bd.sh <<'EOF'
<contenido de scripts/backup.sh>
EOF
```

```bash
chmod 750 /var/scripts/backup-bd.sh
```

```bash
bash -n /var/scripts/backup-bd.sh && echo SINTAXIS_OK
```

El script:

- usa un bloqueo (`flock`) contra ejecuciones simultáneas;
- ejecuta el volcado con `sudo -n`, con la entrada desde `/dev/null` y la salida a un archivo (ver la [incidencia](#incidencia-volcado-bloqueado)) y con un límite de 10 minutos;
- verifica el hash del volcado y solo entonces lo da por válido;
- copia la carpeta de datos con `tar`, valida el archivo (`gzip -t` y `tar -t`), lo publica desde un temporal y guarda su SHA-256;
- registra cada paso y el código final en el log, sin credenciales;
- aplica la retención de 7 por tipo únicamente después de una copia válida.

### 4. Ejecutarlo a mano

```bash
/var/scripts/backup-bd.sh; echo "codigo: $?"
```

```bash
tail -n 8 /var/log/cooperativa-backup.log; ls -la /var/backups/cooperativa
```

Esperado: código 0; en el log, `INICIO volcado logico`, `OK ... .sql.gz`, `OK hash verificado`, la copia de archivos y `FIN codigo 0`; un `.sql.gz` y un `.tar.gz` nuevos con sus hashes y ningún `.tmp` suelto.

### 5. Probar Cron con un horario corto

Con el servidor sin crontab para este usuario (`crontab -l` lo confirma), programar la tarea cada 2 minutos. Es solo para la prueba:

```bash
echo '*/2 * * * * /var/scripts/backup-bd.sh >> /var/log/cooperativa-cron.log 2>&1' | crontab -
```

Esperar unos 6 minutos sin ejecutar nada a mano y comprobar:

```bash
date; tail -n 12 /var/log/cooperativa-backup.log; echo ---; cat /var/log/cooperativa-cron.log
```

Esperado: ejecuciones completas en minutos pares que no lanzó nadie, y `cooperativa-cron.log` vacío.

### 6. Comprobar la retención

Con la tarea cada 2 minutos, tras unos 16 minutos se superan las 7 copias:

```bash
ls /var/backups/cooperativa/bd-*.sql.gz | wc -l; ls /var/backups/cooperativa/bd-*.tar.gz | wc -l; grep RETENCION /var/log/cooperativa-backup.log | tail -n 4
```

Esperado: `7` y `7`, con líneas `RETENCION eliminado ...`. El log anota la eliminación aunque `rm` pudiera fallar: comprobar también con `ls`.

### 7. Dejar el horario definitivo

```bash
echo '0 9 * * * /var/scripts/backup-bd.sh >> /var/log/cooperativa-cron.log 2>&1' | crontab -
```

```bash
crontab -l
```

### 8. Copia fuera del servidor (desde cero en una Mint)

Se hace en la Mint, con el usuario que guardará las copias (`axel`). El servidor debe ser alcanzable por SSH. Desde el 13/11/2026 se usa **Tailscale** (IP del servidor: `100.102.83.103`), porque la Mint se reconstruyó y el servidor ya no comparte la red interna de VirtualBox con ella. En la red interna anterior la IP era `192.168.50.1`; los comandos de abajo usan la de Tailscale.

Antes, en la Mint: quitar de la consola de administración de Tailscale la entrada de la Mint anterior (si no, la nueva se llama `cooperativa-mint-1`), instalar Tailscale con el instalador oficial, entrar con la misma cuenta que el servidor y comprobar que lo ve:

```bash
curl -fsSL https://tailscale.com/install.sh | sh
```

```bash
sudo tailscale up --hostname=cooperativa-mint
```

```bash
tailscale status
```

```bash
timeout 5 bash -c 'cat < /dev/null > /dev/tcp/100.102.83.103/22' && echo PUERTO_22_ABIERTO || echo PUERTO_22_CERRADO
```

Instalar lo necesario y comprobar las herramientas:

```bash
sudo apt install -y rsync openssh-client git openssl cron docker.io
```

```bash
for c in rsync ssh git openssl flock zcat gzip docker; do command -v $c >/dev/null && echo "ok $c" || echo "FALTA $c"; done
```

Crear la clave (una por Mint, para poder revocarlas por separado):

```bash
ssh-keygen -t ed25519 -f ~/.ssh/id_respaldos -C "respaldos-cooperativa-mint-nueva" -N ""
```

```bash
cat ~/.ssh/id_respaldos.pub
```

La clave queda sin frase para que Cron pueda usarla sin intervención; por eso se limita lo que puede hacer en el servidor. La cuenta `ftp-andrews` tiene el directorio personal en poder de root y no se puede escribir en él, así que `ssh-copy-id` falla con `mkdir: Permission denied`. Quien tenga `sudo` en el servidor la instala **añadiendo** esta línea al final de `/home/ftp-andrews/.ssh/authorized_keys`, con la clave pública copiada de arriba (sin tocar las demás; conviene antes `sudo cp -a` del archivo como copia de seguridad, y editarlo con `sudo nano` o añadir con `sudo tee -a`):

```text
restrict,command="/usr/bin/rrsync -ro /var/backups/cooperativa" ssh-ed25519 AAAA... respaldos-cooperativa-mint-nueva
```

Cada clave debe quedar en **una sola línea**. Se comprueba en el servidor con `sudo awk '{print NR, length($0), $NF}' /home/ftp-andrews/.ssh/authorized_keys` (una fila por clave) y comparando el final de la clave con el de `cat ~/.ssh/id_respaldos.pub` en la Mint. No usar `ssh-copy-id`: falla y no conserva la restricción. Las líneas de Mints que ya no existen pueden borrarse del archivo.

Con `rrsync -ro` la clave solo puede leer con `rsync` dentro de `/var/backups/cooperativa`: no abre una terminal ni escribe. Comprobar en la Mint que se pueden listar las copias y que no hay shell:

```bash
rsync -e "ssh -i $HOME/.ssh/id_respaldos" --list-only ftp-andrews@100.102.83.103:/
```

Traer las copias. La ruta remota es `/` porque `rrsync` ya fija la raíz; no se usa `--delete` y se excluye el archivo de bloqueo:

```bash
mkdir -p ~/copia-cooperativa
```

```bash
rsync -av --exclude=.lock -e "ssh -i $HOME/.ssh/id_respaldos" ftp-andrews@100.102.83.103:/ ~/copia-cooperativa/
```

```bash
ls -lh ~/copia-cooperativa
```

Para verificar los hashes sin comodines (se pierden al pegar el comando por algunos canales), usar el nombre completo:

```bash
cd ~/copia-cooperativa && sha256sum -c bd-AAAAMMDD-HHMMSS.sql.gz.sha256
```

La primera vez, `ssh` pregunta si se confía en la huella del servidor: compararla antes de aceptar con la que muestra `ssh-keygen -lf /etc/ssh/ssh_host_ed25519_key.pub` en el servidor. Si el puerto 22 se rechaza (`Connection refused`), reintentar pasado un momento y comprobar que se usa la IP correcta para esa Mint.

Para que la Mint traiga las copias sola, con verificación y retención, ver el [paso 11](#11-copia-periódica-en-mint-con-cron).

### 9. Restauración aislada de la BD en Mint

El motor de MariaDB es el mismo del servidor (imagen `mariadb:11.8.9`) para evitar diferencias de versión. Docker no está instalado en la Mint de partida: se instala el paquete `docker.io` y se usa `sudo docker` (la cuenta no está en el grupo `docker`). Se necesita Docker porque la restauración debe ejecutarse en un MariaDB real, no solo "abrir" el archivo; el contenedor se crea sin puertos publicados y no toca el sitio.

```bash
sudo apt install -y docker.io
```

```bash
CLAVE=$(openssl rand -base64 18); VOLCADO=~/copia-cooperativa/bd-AAAAMMDD-HHMMSS.sql.gz
```

```bash
sudo docker run -d --name bd-restauracion -e MARIADB_ROOT_PASSWORD="$CLAVE" -e MARIADB_DATABASE=cooperativa_wp mariadb:11.8.9
```

Esperar a que acepte conexiones (el volcado no incluye `CREATE DATABASE` ni usuarios, por eso la base se crea al iniciar):

```bash
until sudo docker exec bd-restauracion healthcheck.sh --connect --innodb_initialized; do sleep 3; done; echo LISTA
```

Si el contenedor se detiene (`sudo docker ps -a` lo muestra `Exited (1)`) y los registros terminan en `Unable to start server.`, el arranque temporal tardó demasiado en una VM lenta: `sudo docker rm -f bd-restauracion` y repetir (ver observado).

Cargar el volcado midiendo el tiempo y comprobar:

```bash
time zcat "$VOLCADO" | sudo docker exec -i bd-restauracion sh -c 'exec mariadb -uroot -p"$MARIADB_ROOT_PASSWORD" cooperativa_wp'
```

```bash
sudo docker exec bd-restauracion sh -c 'exec mariadb -uroot -p"$MARIADB_ROOT_PASSWORD" cooperativa_wp -e "SHOW TABLES" | wc -l'
```

```bash
sudo docker exec bd-restauracion sh -c 'exec mariadb -uroot -p"$MARIADB_ROOT_PASSWORD" cooperativa_wp -e "SELECT option_name, option_value FROM wp_options WHERE option_name IN (\"blogname\",\"home\",\"siteurl\")"'
```

```bash
sudo docker exec bd-restauracion sh -c 'exec mariadb -uroot -p"$MARIADB_ROOT_PASSWORD" cooperativa_wp -e "SELECT COUNT(*) FROM wp_users"'
```

Al terminar, retirar el contenedor de prueba y la variable de la clave:

```bash
sudo docker rm -f bd-restauracion; unset CLAVE
```

Restaurar sobre el sitio real (servidor de reemplazo) sería otro procedimiento: levantar la pila con `docker compose up -d` desde un `.env` propio, que crea la base y el usuario `cooperativa_web` sobre un volumen vacío, y cargar el volcado ahí. Eso no se ha probado.

### 10. Restauración de prueba con un script

[scripts/restaurar-prueba-mint.sh](../scripts/restaurar-prueba-mint.sh) ejecuta el paso 9 completo y se detiene si algo falla. No está en el servidor: se instala en la Mint.

Instalar los dos scripts de Mint (este y el del paso 11) desde la rama publicada del repositorio, copiándolos al directorio personal:

```bash
git clone --branch feature/c05-cron-andres --depth 1 https://github.com/Dani-develop/Cooperativa-Agr-cola-Nicoya.git ~/repo-cooperativa
```

```bash
cp ~/repo-cooperativa/scripts/copiar-respaldos-mint.sh ~/repo-cooperativa/scripts/restaurar-prueba-mint.sh ~/
```

```bash
chmod 750 ~/copiar-respaldos-mint.sh ~/restaurar-prueba-mint.sh
```

```bash
bash -n ~/copiar-respaldos-mint.sh && bash -n ~/restaurar-prueba-mint.sh && echo SINTAXIS_OK
```

Si el repositorio no estuviera accesible, se puede crear cada archivo con `cat > ~/script.sh <<'EOF'`, pegando el contenido y cerrando con una línea `EOF`; los scripts no tienen tildes ni asteriscos porque se pierden al pegar por SSH. Ejecutarlo:

```bash
~/restaurar-prueba-mint.sh
```

Opciones: `--traer` (hace antes el `rsync` del paso 8), `--conservar` (no borra el contenedor al final) y, como argumento, la ruta de un volcado concreto en vez del más reciente.

Lo que hace, en orden:

1. Elige el volcado más reciente (o el indicado) y exige su `.sha256`: verifica el hash y hace `gzip -t`. Si algo no coincide, termina sin cargar nada.
2. Crea `bd-restauracion` con una clave aleatoria que no se imprime ni se guarda. Si el contenedor se detiene durante el arranque (el caso de `Unable to start server.`), lo elimina y lo repite hasta 3 veces, esperando hasta 120 s en cada intento.
3. Carga el volcado, mide el tiempo y revisa el código de salida de `zcat` y de `mariadb`.
4. Cuenta las tablas y lee `blogname`, `siteurl` y el número de usuarios de WordPress. Termina con código distinto de 0 si no hay tablas, no hay usuarios o `siteurl` está vacío.
5. Elimina el contenedor (salvo `--conservar`) y registra todo en `~/restauracion-prueba.log`.

Límites: solo cubre la BD. Usa `docker` si el usuario puede, o `sudo docker`; por eso no sirve para Cron sin permiso de Docker (el `sudo` pediría contraseña). Dar a `axel` el grupo `docker` en la Mint de pruebas permitiría programarlo, a costa de darle permisos de root en esa VM; no se ha hecho.

### 11. Copia periódica en Mint con Cron

[scripts/copiar-respaldos-mint.sh](../scripts/copiar-respaldos-mint.sh) hace lo del paso 8 de forma desatendida. Se instala junto con el del paso 10 (`~/copiar-respaldos-mint.sh`). La IP del servidor sale de la variable `SERVIDOR`, que por defecto vale `ftp-andrews@192.168.50.1` (la red interna anterior): con Tailscale hay que indicarla, tanto a mano como en la línea de Cron, porque Cron no hereda variables de la terminal. Cada ejecución:

1. Toma un bloqueo (`flock`); si hay otra copia en curso, se omite y lo anota.
2. Ejecuta `rsync` con la clave restringida, `BatchMode` y 15 s de espera de conexión, sin `--delete`.
3. Comprueba el `.sha256` del volcado más reciente. Si falla, sale con error y **no** aplica la retención.
4. Conserva los 30 volcados y las 30 copias de archivos más recientes (con sus `.sha256`); los nombres ordenan por fecha. La lógica se comprobó en local con 35 juegos de archivos vacíos: quedaron 30 de cada tipo y se eliminaron los 5 más antiguos.
5. Escribe cada paso en `~/copia-cooperativa.log`.

Probarlo a mano:

```bash
SERVIDOR=ftp-andrews@100.102.83.103 ~/copiar-respaldos-mint.sh; echo "codigo: $?"; cat ~/copia-cooperativa.log
```

Probar Cron con un horario corto. Revisar antes con `crontab -l` que no haya otras tareas que se pisen; esta línea añade la prueba al crontab existente:

```bash
(crontab -l 2>/dev/null; echo '*/2 * * * * SERVIDOR=ftp-andrews@100.102.83.103 "$HOME/copiar-respaldos-mint.sh"') | crontab -
```

Esperar unos 5 minutos sin ejecutar nada a mano y revisar `tail -n 12 ~/copia-cooperativa.log`: bloques `INICIO` ... `FIN codigo 0` en minutos pares. Después, el horario definitivo (cada hora, al minuto 15), que reemplaza todo el crontab de ese usuario:

```bash
echo '15 * * * * SERVIDOR=ftp-andrews@100.102.83.103 "$HOME/copiar-respaldos-mint.sh"' | crontab -
```

Se programa cada hora y no una vez al día porque Cron no recupera una ejecución perdida si la VM está apagada a la hora fijada, y `rsync` solo copia lo nuevo. La fuente de la línea es [mint-copia.cron](../config/cron/mint-copia.cron). La hora de la Mint es la local de Costa Rica; el servidor genera la copia a las 03:00 y la primera pasada por hora posterior la trae.

## Validación

- Resultado esperado: el respaldo se genera solo por Cron, con volcado válido y hash correcto, y la retención mantiene 7 copias de cada tipo.
- Resultado observado, 03/11/2026 (UTC):
  - Volcado directo a las 20:15: código 0, 1 168 306 bytes, hash correcto, 27 sentencias `CREATE TABLE` y cierre `-- Dump completed on 2026-11-03 20:15:35`.
  - Script integrado, a mano, a las 20:56: código 0, volcado de 1 s y copia de archivos de 7 s.
  - Cron cada 2 minutos: ejecuciones completas a las 21:00:01 y 21:02:02, ambas con `FIN codigo 0`, y `cooperativa-cron.log` vacío.
  - Retención: a las 21:17 había 7 volcados y 7 copias de archivos; el log registra las eliminaciones de las 21:14 y las 21:16.
  - Horario definitivo `0 9 * * *`: el volcado `bd-20261106-090002.sql.gz` (1,2 MB, 03:00 hora de Costa Rica del 06/11) lo generó esa ejecución nocturna y se usó en la restauración.
  - Copia externa, 07/11/2026: `rsync` con la clave restringida trajo los volcados a `~/copia-cooperativa` en la Mint del proyecto.
  - Restauración aislada en Mint, 07/11/2026: la carga del volcado tardó **22,9 s** (`real`) en el contenedor `bd-restauracion`; `SHOW TABLES` dio 28 líneas (27 tablas y la cabecera); `blogname` = «Cooperativa Agricola Nicoya», `home` y `siteurl` = `https://cooperativa.internal`; `wp_users` tiene 4 filas. El primer arranque del contenedor falló con `Unable to start server.` en la VM lenta y funcionó al repetirlo con una espera mayor.
  - Servidor apagado, comprobado el 13/11/2026: el log solo tiene ejecuciones de los días 6 y 9 (todas con `FIN codigo 0`), el servidor arrancó el 14/11 a las 01:18 UTC y no hay copias de los días 7, 8 y 10 a 13. Con una sola hora fija, un servidor apagado a las 09:00 UTC significa un día sin respaldo.
  - Mint reconstruida con Tailscale, 13/11/2026 (la anterior se borró): paso 8 completo con la IP `100.102.83.103`; `copiar-respaldos-mint.sh` a mano terminó con código 0 y verificó `bd-20261109-090005.sql.gz` (primera copia de todo el historial: unos 4 min 27 s); `restaurar-prueba-mint.sh` terminó con `FIN codigo 0`: hash verificado, **32,3 s** de carga, 27 tablas, `blogname` «Cooperativa Agricola Nicoya», `siteurl` `https://cooperativa.internal` y 5 usuarios de WordPress (el volcado del día 6 tenía 4). El primer intento del contenedor falló con `Unable to start server.` y el reintento automático del script lo resolvió.
  - Cron de Mint: Andrés indicó haber completado los pasos de Cron (prueba cada 2 minutos y luego cada hora), **pero no se aportó el log ni `crontab -l`**: no hay evidencia archivada de esas ejecuciones.
- Evidencia: [salida transcrita del volcado, la incidencia y Cron](../evidencias/respaldos/C05-T05-cron-volcado-2026-11-03.txt), [de la primera copia de archivos](../evidencias/respaldos/C05-T05-script-manual-2026-10-30.txt), [de la restauración manual en Mint](../evidencias/respaldos/C05-T05-restauracion-mint-2026-11-07.txt) y [de la Mint reconstruida, la copia y la restauración con script](../evidencias/respaldos/C05-T05-mint-nueva-2026-11-13.txt). Registro: [T05](../pruebas/registros/T05-C05-2026-11-03.md). Commit de configuración bajo prueba: `8d2b303` para los scripts de Mint; el resto, pendiente del commit que incluye este documento.
- Responsable: Andrés. Revisor: por asignar.

La base de datos se recupera desde una copia fuera del servidor en un contenedor aislado, con el script y desde una Mint reconstruida. No se ha probado recuperar el sitio completo: faltan los archivos de WordPress, la configuración HTTPS y la copia de archivos de la BD.

## Incidencia: volcado bloqueado

La primera integración ejecutaba `salida=$(sudo -n "$DUMP")`. A las 20:25 el volcado empezó y no terminó; dejó dos temporales de 0 bytes y el bloqueo ocupado, por lo que el intento de las 20:45 se negó a correr. Con el volcado directo (salida en la terminal) todo funcionaba. Dos pruebas con `timeout`:

- **A:** entrada desde `/dev/null` y salida a un archivo, como en Cron: terminó bien.
- **B:** salida capturada con `$(...)` y entrada en la terminal: se colgó; `mariadb-dump` seguía vivo a los 38 s.

La causa exacta de por qué se bloquea la salida capturada no se determinó. El script usa ahora las condiciones de la prueba A, cierra el descriptor del bloqueo para los procesos hijos (`9>&-`) y limita el volcado a 10 minutos. La repetición manual y las ejecuciones de Cron posteriores terminaron en segundos. Tras la incidencia se eliminaron los temporales de 0 bytes.

## Consideraciones

- El script solo lee el origen y escribe en `/var/backups/cooperativa` y en los logs. Para revertir: `crontab -r`, eliminar `/var/scripts/backup-bd.sh` y la carpeta de copias.
- Una restauración de la copia de archivos debe hacerse como root para conservar el propietario original (uid 999, usuario `mysql` del contenedor) y siempre en un destino aislado, nunca sobre el volumen vivo.
- Los archivos de respaldo contienen datos de la BD, incluidos hashes de contraseñas: no subirlos a Git ni compartirlos. `.gitignore` ya excluye `*.sql.gz` y `*.tar.gz`.
- La regla de `sudo` y `dump-bd.sh` los gestiona el administrador. Si `dump-bd.sh` pudiera editarse con la cuenta de trabajo, la regla daría acceso de root.

## Pendiente

1. Respaldar `wp-content` (medir su tamaño y dar permiso de lectura a la cuenta de respaldo) y restaurarlo junto a la BD. `wp-config.php` se regenera desde `.env` y no hace falta copiarlo.
2. Restauración completa visible por HTTPS (Apache, certificado, WordPress, BD y DNS) en un servidor de reemplazo.
3. Restaurar la copia de archivos de la BD (`.tar.gz`) para decidir si se conserva como respaldo secundario.
4. Archivar el log de Cron de la Mint (`~/copia-cooperativa.log` con ejecuciones lanzadas por Cron y `crontab -l`); quitar la tarea de clase de la primera Mint si existe y las claves de Mints que ya no existen de `authorized_keys`. Decidir si se programa también la prueba de restauración (requiere permiso de Docker para `axel`).
5. Decidir si el Cron del servidor pasa a una ejecución por hora con comprobación diaria, para no perder días en que el servidor esté apagado a las 09:00 UTC.
5. Reducir el ACL de `ftp-andrews` sobre la carpeta de datos a lectura.
6. Guardar fuera del repositorio una copia de `.env` y del material TLS, o regenerar el TLS con `scripts/preparar-tls.sh` y reinstalar la CA en los clientes.
7. Revisión de un compañero.
