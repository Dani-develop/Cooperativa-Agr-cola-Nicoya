# Scripts

Ejecutar en Bash dentro de Ubuntu; no en PowerShell del host Windows.

| Script | Estado | Comportamiento actual |
|---|---|---|
| preflight.sh | Disponible para inventario | Solo lectura; muestra herramientas, red y puertos sin leer credenciales. |
| preparar-tls.sh | Implementado y probado C02 | Emite CA/certificado solo si no existe material previo; no reemplaza claves. Requiere root. |
| bootstrap-wordpress.sh | Implementado y probado C02/C03 | Inicializa solo un WordPress nuevo con cuenta técnica; código 2 si ya existe, conservando datos. |
| backup.sh | Pendiente | Finaliza con código 2; no crea ni elimina respaldos. |
| restore.sh | Pendiente | Finaliza con código 2; no restaura ni sobrescribe. |
| verify.sh | Pendiente | Finaliza con código 2; no declara aprobada la infraestructura. |

Uso y permisos en [guía de Daniel](../docs/13-daniel-wordpress-https.md). Las pruebas están en T02/T03 del 24/10/2026. Los tres scripts pendientes (`backup`, `restore`, `verify`) mantienen salida 2 y no acreditan sus requisitos. Ejecutar los comandos Docker como administrador; no confundir el usuario Linux `axel`, el administrador WordPress `daniel_admin` y el usuario SQL `cooperativa_web`.
