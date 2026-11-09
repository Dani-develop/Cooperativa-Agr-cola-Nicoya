# Índice de evidencias

Estado: C01/T01 conserva la validación de Axel. C02/T02 y C03/T03 tienen pruebas y documentación de Daniel del 24/10/2026, con revisión humana de Frander pendiente. E01-E05 tienen registros y capturas de Ari del 27/10 al 08/11/2026, sin revisión humana; la evidencia que falta está en [WordPress](wordpress/README.md). Los demás requisitos permanecen pendientes.

Nombre sugerido: `C01-T01-dns-mint-2026-10-21.png`. Guardar capturas legibles o salidas en texto; incluir contexto suficiente y revisar datos privados antes de publicar. Los fallos pueden conservarse como diagnóstico si se distinguen del resultado final.

| ID | Qué acredita | Estado | Archivo | Fecha/equipo | Commit bajo prueba | Revisor |
|---|---|---|---|---|---|---|
| C01-T01 | Zona DNS propia en BIND9 | Aprobado | [Evidencias DNS](dns/README.md) | 2026-10-21 / cooperativa-server + cooperativa-mint | `83de95a` | Daniel |
| C02-T02 | VirtualHost HTTPS sobre WordPress en Docker | Probado/documentado; revisión pendiente | [HTTPS](https/README.md), [T02](../pruebas/registros/T02-C02-2026-10-24.md) | 2026-10-24 / cooperativa-server + cooperativa-mint | `f2520a6`, repetición `9f1ac00` | Frander, pendiente |
| C03-T03 | Dos servicios Docker con volúmenes y versiones específicas | Probado/documentado; revisión pendiente | [Docker](docker/README.md), [T03](../pruebas/registros/T03-C03-2026-10-24.md) | 2026-10-24 / cooperativa-server + cooperativa-mint | `f2520a6`, prueba adicional `9f1ac00` | Frander, pendiente |
| C04-T04 | FTP por integrante o rol con aislamiento | Pendiente | | | | |
| C05-T05 | Respaldo de BD automático con Cron y restauración | Pendiente | | | | |
| C06-T06 | Documentación técnica reproducible y diagramas | Pendiente | | | | |
| E01-T07 | Tema con logo y colores propios | Casi completo: logo y paleta propios en tres tamaños; en móvil el logo tapa el titular y Productos no apila columnas | [WordPress](wordpress/README.md), [T07](../pruebas/registros/T07-E01-2026-10-28.md) | 2026-10-27/28 / VM Mint | `9674c2b` | Pendiente |
| E02-T08 | Menú con al menos cuatro secciones | Probado: cuatro secciones recorridas como visitante | [WordPress](wordpress/README.md), [T08](../pruebas/registros/T08-E02-2026-10-28.md) | 2026-10-27/28 / VM Mint | `9674c2b` | Pendiente |
| E03-T09 | Cinco entradas o páginas agrícolas genuinas como mínimo | Implementado: seis entradas y cinco páginas con textos y fuentes; revisión pendiente | [WordPress](wordpress/README.md), [T09](../pruebas/registros/T09-E03-2026-10-28.md) | 2026-10-27/28 / VM Mint | `9674c2b` | Pendiente |
| E04-T10 | Plugin relevante instalado y configurado | Probado con observaciones | [WordPress](wordpress/README.md), [T10](../pruebas/registros/T10-E04-2026-10-28.md) | 2026-10-28 / VM Mint | `9674c2b` | Pendiente |
| E05-T11 | Dos roles distintos y límites demostrados | Probado: dos Autores, Editor y Administrador con límites demostrados | [WordPress](wordpress/README.md), [T11](../pruebas/registros/T11-E05-2026-10-28.md) | 2026-10-28 / VM Mint | `9674c2b` | Pendiente |
| E06-T12 | Justificación de software libre para toda la solución | Pendiente | | | | |

Carpetas: [DNS](dns/README.md), [HTTPS](https/README.md), [Docker](docker/README.md), [WordPress](wordpress/README.md), [FTP](ftp/README.md), [respaldos](respaldos/README.md) y [reproducción](reproduccion/README.md).

Los respaldos reales se conservan fuera de Git; aquí se publica solo evidencia revisada de su generación y restauración. No subir bases de datos, `.env`, claves o hashes de credenciales en capturas.
