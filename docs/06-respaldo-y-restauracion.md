# Respaldo y restauración

Estado: volcado lógico, script de respaldo y ejecución por Cron probados el 03/11/2026 ([procedimiento y resultado](14-andres-respaldo-cron.md)); la copia externa a Mint y la restauración de la BD en un contenedor aislado se probaron el 07/11/2026. Faltan los archivos de WordPress y la restauración completa por HTTPS; C05 no está aprobado. C05/T05.

## Política propuesta

Respaldo diario de madrugada, siete diarios y cuatro semanales, más copia antes de cambios relevantes. Ventana potencial de pérdida: hasta unas 24 horas; recuperación objetivo inicial: 60 minutos, por medir. Frecuencia y retención son propuestas para el caso, no requisitos específicos impuestos al escenario WordPress.

El mínimo obligatorio es BD automática con Cron y restauración documentada. Incluiremos archivos WordPress, medios, tema, plugins y configuración para recuperar el sitio completo. Habrá una copia protegida fuera de la VM: otra carpeta del mismo disco no protege ante pérdida del disco.

## Contrato del script de respaldo

- Rutas absolutas y credenciales locales restringidas, fuera de Git y sin preguntas interactivas.
- `mariadb-dump` y cliente compatibles; evaluar `--single-transaction` para tablas InnoDB.
- Coordinar BD y archivos mediante una ventana controlada sin publicaciones/cambios.
- Evitar ejecuciones simultáneas; escribir temporal y publicar solo una copia válida.
- Registrar fecha, resultado, tamaño y checksum sin secretos.
- Aplicar retención tras una copia exitosa; un error no debe borrar la última copia válida.
- Copiar al destino externo y registrar también ese resultado.

El script [backup.sh](../scripts/backup.sh) cumple la mayor parte: ejecuta el volcado `mariadb-dump --single-transaction` mediante el script de root [dump-bd.sh](../config/cron/dump-bd.sh), verifica su hash, bloquea ejecuciones simultáneas, escribe desde temporales, registra en un log sin secretos y aplica la retención de 7 copias solo tras una copia válida. Además copia en caliente la carpeta de datos de MariaDB como respaldo secundario. Todavía no coordina los archivos de WordPress ni copia al destino externo; ver las [decisiones y limitaciones](14-andres-respaldo-cron.md#decisiones-y-limitaciones).

## Cron

La entrada está en [config/cron](../config/cron/README.md). Se probó una ejecución disparada realmente por Cron con un horario corto antes de fijar el definitivo (`0 9 * * *`, 03:00 en Costa Rica porque el servidor usa UTC). Ejecutar a mano el script no prueba la programación. Log, hora y archivos generados en el [registro T05](../pruebas/registros/T05-C05-2026-11-03.md).

## Restauración aislada

1. Crear una entrada e imagen identificables y registrar estado previo.
2. Generar un respaldo, comprobar integridad básica y conservarlo protegido.
3. Preparar destino aislado, con volúmenes nuevos y datos de conexión inequívocos.
4. Restaurar BD, archivos y configuración con versiones compatibles.
5. Comprobar HTTPS, contenido, imagen, galería, menú y roles contra el estado previo.
6. Medir tiempo y registrar problemas/resultado. Mantener intacto el sitio principal.

Una red aislada puede mantener el dominio para evitar cambiar URLs. Si se cambia, usar una migración compatible con los datos serializados de WordPress. Un exportador de entradas no sustituye la copia completa.

El script [restore.sh](../scripts/restore.sh) requerirá destino explícito y salvaguardas antes de habilitarse. Registrar qué se recuperó realmente y cualquier límite; la mera presencia de un `.sql` no acredita restauración.
