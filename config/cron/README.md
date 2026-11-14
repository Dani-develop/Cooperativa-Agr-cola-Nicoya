# Cron de respaldo

Estado: volcado, script y programación probados el 03/11/2026 en `cooperativa-server`; el volcado se restauró en un contenedor aislado en Mint el 07/11/2026 (solo la BD). C05/T05. Procedimiento y resultados en la [guía de respaldo](../../docs/14-andres-respaldo-cron.md) y el [registro T05](../../pruebas/registros/T05-C05-2026-11-03.md).

## Archivos

| Archivo | Destino en Ubuntu | Función |
|---|---|---|
| [cooperativa-backup.cron](cooperativa-backup.cron) | crontab de `ftp-andrews` | Ejecuta el respaldo todos los días a las 09:00 UTC (03:00 en Costa Rica) y guarda la salida en `/var/log/cooperativa-cron.log`. |
| [dump-bd.sh](dump-bd.sh) | `/usr/local/sbin/dump-bd.sh`, propiedad de root | Volcado lógico `mariadb-dump --single-transaction` de `cooperativa_wp`. Lo instaló el administrador y se ejecuta con `sudo`. |
| [../../scripts/backup.sh](../../scripts/backup.sh) | `/var/scripts/backup-bd.sh` | Llama al volcado, copia la carpeta de datos, valida, registra y aplica la retención de 7. |
| [mint-copia.cron](mint-copia.cron) | crontab de `axel` en la Mint del proyecto | Cada hora (minuto 15) ejecuta `~/copiar-respaldos-mint.sh` con `SERVIDOR=ftp-andrews@100.102.83.103`, que trae las copias del servidor, verifica el último volcado y conserva 30 de cada tipo. Fuente: [../../scripts/copiar-respaldos-mint.sh](../../scripts/copiar-respaldos-mint.sh). |

`dump-bd.sh` es la transcripción del script que el administrador dejó instalado; ante cualquier duda, prevalece la copia del servidor. Debe pertenecer a root y no ser escribible por `ftp-andrews`: con `sudo` se ejecuta como root.

## Permiso previo

El administrador dejó una regla de `sudo` limitada a ese script. Se comprueba con `sudo -n -l`, que debe mostrar únicamente:

```
(root) NOPASSWD: /usr/local/sbin/dump-bd.sh
```

No se agregó `ftp-andrews` al grupo `docker`: ese grupo equivale a root en el servidor.

## Instalación de la entrada

Sin un crontab previo, la entrada se instaló con:

```bash
echo '0 9 * * * /var/scripts/backup-bd.sh >> /var/log/cooperativa-cron.log 2>&1' | crontab -
```

`crontab -` reemplaza todo el crontab del usuario: si ya existen otras tareas, integrarlas antes. Para revertir, `crontab -r`.

## Aceptación

Ejecución disparada por Cron y registrada: comprobada el 03/11/2026 con un horario de prueba cada 2 minutos; el horario definitivo de las 09:00 UTC generó el volcado del 06/11. La Mint ejecuta su propia tarea (`mint-copia.cron`, con la IP de Tailscale en la variable `SERVIDOR`); la copia y la restauración se probaron a mano el 13/11/2026 y falta archivar el log de Cron de la Mint. El servidor solo respalda si está encendido a las 09:00 UTC: faltan los días 7, 8 y 10 a 13 de noviembre. Pendiente: restauración de los archivos de WordPress.
