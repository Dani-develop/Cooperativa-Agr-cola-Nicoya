# Respaldo y restauración

Estado: diseño, sin script ni restauración aprobados. C05/T05.

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

El script [backup.sh](../scripts/backup.sh) está deshabilitado hasta implementar y comprobar este contrato.

## Cron

La entrada se mantendrá en [config/cron](../config/cron/README.md). Probar una ejecución disparada realmente por Cron a una hora cercana, con el entorno de Cron, antes de fijar el horario definitivo. Ejecutar a mano el script no prueba la programación. Guardar log, hora y archivo generado.

## Restauración aislada

1. Crear una entrada e imagen identificables y registrar estado previo.
2. Generar un respaldo, comprobar integridad básica y conservarlo protegido.
3. Preparar destino aislado, con volúmenes nuevos y datos de conexión inequívocos.
4. Restaurar BD, archivos y configuración con versiones compatibles.
5. Comprobar HTTPS, contenido, imagen, galería, menú y roles contra el estado previo.
6. Medir tiempo y registrar problemas/resultado. Mantener intacto el sitio principal.

Una red aislada puede mantener el dominio para evitar cambiar URLs. Si se cambia, usar una migración compatible con los datos serializados de WordPress. Un exportador de entradas no sustituye la copia completa.

El script [restore.sh](../scripts/restore.sh) requerirá destino explícito y salvaguardas antes de habilitarse. Registrar qué se recuperó realmente y cualquier límite; la mera presencia de un `.sql` no acredita restauración.
