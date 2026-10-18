# Guía de instalación paso a paso

**Borrador estructurado.** Los pasos finales y sus salidas se completan al ejecutarlos; todavía no existe una instalación verificada del proyecto. No ejecutar cambios en las VMs de laboratorios anteriores.

Cada bloque usará la [plantilla de paso](plantilla-paso.md) y cerrará con prueba y evidencia.

| Bloque | Trabajo | Condición para continuar |
|---|---|---|
| 0 | Inventario, recursos, equipo, dominio y versiones | Datos reales registrados y responsables definidos. |
| 1 | VM Ubuntu dedicada y Mint cliente | Arranque, interfaces y conectividad observadas. |
| 2 | Paquetes y herramientas | Versiones, servicios y puertos inventariados. |
| 3 | Zona BIND9 y DNS del cliente | C01/T01 aprobado sin hosts ni resolve. |
| 4 | Variables, Compose y volúmenes | Configuración efectiva válida y bd saludable. |
| 5 | Certificado y proxy Apache | C02/T02 aprobado por el dominio desde Mint. |
| 6 | Inicialización WordPress | URLs HTTPS y cuenta técnica, esquema propio de WP. |
| 7 | Tema, contenido, plugin y roles | E01-E05 y sus pruebas aprobados. |
| 8 | FTP y permisos | C04/T04 con operaciones propias y denegación cruzada. |
| 9 | Cron, respaldo y restauración | C05/T05 aprobado en destino aislado. |
| 10 | Reinicio y aceptación | Persistencia, servicios y accesos correctos tras reiniciar. |
| 11 | Reproducción independiente | C06/T06 aprobado por otro integrante. |

## Primer comando disponible

En la **terminal de la VM Ubuntu**, después de tener una copia del repositorio:

```bash
bash scripts/preflight.sh
```

No instala paquetes, no modifica red ni servicios y no muestra `.env`. Completar [inventario](inventario.md) con resultados observados. Una herramienta ausente significa que queda por preparar, no que haya que improvisar una instalación.

## Bloque Docker: preparación futura

Cuando estén confirmados los prerrequisitos, se documentará esta secuencia en Ubuntu:

```bash
cp .env.example .env
chmod 600 .env
```

Completar variables y generar contraseñas privadas antes de validar:

```bash
docker compose config -q
```

Esperado: salida 0. Evitar capturar `docker compose config` sin `-q`, porque puede imprimir contraseñas resueltas. Después de aprobar la configuración se incorporarán los pasos de descarga, arranque, logs y prueba.

## Consideraciones que deben acompañar los comandos

- Bash, SQL y contenido de archivos se mostrarán por separado; respetar indentación YAML y LF.
- Las variables de inicialización MariaDB se aplican al crear un directorio de datos nuevo. Cambiar `.env` no cambia usuarios/contraseñas de una BD ya inicializada.
- WordPress tiene esquema y configuración propios; no copiar el verificador PHP del examen ni sus tablas.
- `localhost` en un contenedor no es la BD de otro; usar `bd`.
- El procedimiento ordinario conservará volúmenes. Una prueba destructiva deberá identificar un entorno aislado y contar con respaldo probado.
- Registrar salidas reales y mensajes de error; no sustituirlas por el resultado esperado de esta guía.

## Registro de avance

| Bloque | Ejecutado por | Fecha | Commit de configuración | Prueba y evidencia | Revisor |
|---|---|---|---|---|---|
| Pendiente | | | | | |
