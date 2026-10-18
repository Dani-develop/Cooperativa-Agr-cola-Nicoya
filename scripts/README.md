# Scripts

Ejecutar en Bash dentro de Ubuntu; no en PowerShell del host Windows.

| Script | Estado | Comportamiento actual |
|---|---|---|
| preflight.sh | Disponible para inventario | Solo lectura; muestra herramientas, red y puertos sin leer credenciales. |
| bootstrap-wordpress.sh | Pendiente | Finaliza con código 2; no instala ni modifica. |
| backup.sh | Pendiente | Finaliza con código 2; no crea ni elimina respaldos. |
| restore.sh | Pendiente | Finaliza con código 2; no restaura ni sobrescribe. |
| verify.sh | Pendiente | Finaliza con código 2; no declara aprobada la infraestructura. |

Se implementarán en la fase correspondiente, con prerrequisitos y ejemplos en la guía. Los cuatro scripts pendientes fallan de forma explícita para que nadie confunda estructura con funcionalidad probada.
