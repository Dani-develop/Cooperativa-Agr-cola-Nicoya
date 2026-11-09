# Pruebas y resultados

T01 conserva el registro de Axel. Daniel ejecutó T02/T03 y una comprobación parcial de reinicio el 24/10/2026; Frander todavía debe revisar esos resultados. Ari registró T07-T11 (contenido, identidad y roles de WordPress) el 28/10/2026, todos parciales y sin revisión. Los demás casos siguen pendientes. No se trasladan resultados de los laboratorios como evidencia del proyecto.

Los procedimientos están en [casos de prueba](../pruebas/casos.md) y los archivos en [registros](../pruebas/registros/README.md). El índice de capturas está en [evidencias](../evidencias/indice.md).

| Prueba | Resultado | Fecha/equipo | Commit de configuración | Registro | Revisor |
|---|---|---|---|---|---|
| T01 | Aprobado, heredado | 2026-10-21 / Ubuntu + Mint | `83de95a` | [DNS](../pruebas/registros/T01-C01-2026-10-21.md) | Daniel |
| T02 | Pruebas técnicas satisfactorias; revisión pendiente | 2026-10-24 / Ubuntu + Mint | `f2520a6`; repetición `9f1ac00` | [HTTPS](../pruebas/registros/T02-C02-2026-10-24.md) | Frander, pendiente |
| T03 | Persistencia y versiones comprobadas; revisión pendiente | 2026-10-24 / Ubuntu + Mint | `f2520a6`; lectura adicional `9f1ac00` | [Persistencia](../pruebas/registros/T03-C03-2026-10-24.md) | Frander, pendiente |
| T04 | Pendiente | | | | |
| T05 | Pendiente | | | | |
| T06 | Pendiente | | | | |
| T07 | Casi completo: Astra 4.14.2, logo y paleta propios en tres tamaños; en móvil el logo tapa el titular y Productos no apila columnas | 2026-10-27/28 / VM Mint | `9674c2b` (el panel no se versiona) | [Identidad](../pruebas/registros/T07-E01-2026-10-28.md) | Por asignar |
| T08 | Probado: cuatro secciones recorridas como visitante; cinco páginas publicadas | 2026-10-27/28 / VM Mint | `9674c2b` (el panel no se versiona) | [Menú](../pruebas/registros/T08-E02-2026-10-28.md) | Por asignar |
| T09 | Implementado: cinco páginas y seis entradas publicadas con textos y fuentes; falta URL por pieza y revisor | 2026-10-27/28 / VM Mint | `9674c2b` (el panel no se versiona) | [Contenido](../pruebas/registros/T09-E03-2026-10-28.md) | Por asignar |
| T10 | Probado con observaciones: envío público, confirmación y entrada guardada el 07/11/2026; faltan licencias | 2026-10-28 / VM Mint | `9674c2b` (el panel no se versiona) | [Plugin](../pruebas/registros/T10-E04-2026-10-28.md) | Por asignar |
| T11 | Probado: dos Autores, Editor y Administrador con límites demostrados | 2026-10-28 / VM Mint | `9674c2b` (el panel no se versiona) | [Roles](../pruebas/registros/T11-E05-2026-10-28.md) | Por asignar |
| T12 | Cumplido en el documento técnico; revisión pendiente | 2026-11-07 / cooperativa-server | `9674c2b` | [Justificación](../pruebas/registros/T12-E06-2026-11-07.md) | Daniel (sorteo 07/11/2026) |
| T13 | Parcial: DNS/HTTPS/Docker/datos; integral pendiente | 2026-10-24 / Ubuntu + Mint | `9f1ac00` | [Reinicio técnico en T03](../pruebas/registros/T03-C03-2026-10-24.md) | Frander, pendiente |

## Formato del registro

Copiar [plantilla de resultado](../pruebas/registros/plantilla.md). Registrar entrada, operación, resultado esperado, resultado observado, salida original y veredicto. Si falló, conservar la incidencia y agregar la repetición tras corregirla.

Nunca generar capturas de una prueba no ejecutada ni reemplazar la salida observada con un ejemplo. La aceptación de cada requisito debe enlazar el registro que la demuestra.
