# Matriz de requisitos y evaluación

Fuente principal: enunciado del Proyecto de Curso, requisitos comunes y escenario 1. Cada fila debe enlazar configuración, procedimiento y evidencia cuando exista.

| ID | Obligación | Aceptación | Prueba | Estado | Responsable |
|---|---|---|---|---|---|
| C01 | Zona DNS propia en BIND9 | Zona válida, A/SOA autoritativos y resolución normal desde Mint sin hosts ni resolve | [T01](../pruebas/casos.md#t01) | Aprobado | Axel |
| C02 | VirtualHost HTTPS sobre WordPress en Docker | Dominio correcto, confianza TLS, redirección HTTP y sitio/panel operativos; backend aislado | [T02](../pruebas/registros/T02-C02-2026-10-24.md) | Probado y documentado; revisión pendiente | Daniel |
| C03 | Dos servicios Docker con volúmenes y versiones específicas | BD saludable, imágenes identificadas y contenido/imagen persistentes al recrear contenedores | [T03](../pruebas/registros/T03-C03-2026-10-24.md) | Probado y documentado; revisión pendiente | Daniel |
| C04 | FTP por integrante o rol con aislamiento | Cuenta A administra lo propio y no modifica ni borra un archivo de B | [T04](../pruebas/casos.md#t04) | Pendiente | Por asignar |
| C05 | Respaldo de BD automático con Cron y restauración | Ejecución real de Cron y recuperación de datos en destino aislado | [T05](../pruebas/casos.md#t05) | Pendiente | Por asignar |
| C06 | Documentación técnica reproducible y diagramas | Otro integrante completa una instalación limpia desde la guía | [T06](../pruebas/casos.md#t06) | Pendiente | Por asignar |
| E01 | Tema con logo y colores propios | Identidad aplicada, legible y comprobada en varios tamaños de pantalla | [T07](../pruebas/registros/T07-E01-2026-10-28.md) | Casi completo: Astra 4.14.2, logo y paleta propios en tres tamaños; en móvil el logo tapa el titular y Nuestros Productos no apila columnas; revisión pendiente | Ari |
| E02 | Menú con al menos cuatro secciones | Enlaces reales a contenido publicado, sin destinos de ejemplo | [T08](../pruebas/registros/T08-E02-2026-10-28.md) | Probado: cuatro secciones recorridas como visitante, cinco páginas publicadas; revisión pendiente | Ari |
| E03 | Cinco entradas o páginas agrícolas genuinas como mínimo | Inventario publicado con contenido revisado, autoría y fuentes | [T09](../pruebas/registros/T09-E03-2026-10-28.md) | Implementado: seis entradas y seis páginas con textos y fuentes; revisión pendiente | Ari |
| E04 | Plugin relevante instalado y configurado | Función útil demostrada desde el sitio, con versión y licencia registradas | [T10](../pruebas/registros/T10-E04-2026-10-28.md) | Probado con observaciones (envío público, confirmación y entrada guardada); licencias pendientes | Ari |
| E05 | Dos roles distintos y límites demostrados | Autor publica lo propio; no edita lo ajeno ni administra plugins; Editor opera contenido | [T11](../pruebas/registros/T11-E05-2026-10-28.md) | Probado: dos Autores, Editor y Administrador con límites demostrados; revisión pendiente | Ari |
| E06 | Justificación de software libre para toda la solución | Comparación contextual de alternativas, licencias, soporte y costo total | [T12](../pruebas/registros/T12-E06-2026-11-07.md) | Documentado el 07/11/2026; revisión pendiente | Daniel (sorteo 07/11/2026) |

Estados: pendiente, implementado, probado, documentado, reproducido. Un requisito cerrado necesita fecha, revisor y enlace al registro de prueba; no se cierra por tener una carpeta o una captura sin contexto.

C02/C03 tienen ejecución técnica del 24/10/2026 en la rama de Daniel. Frander (`FranderCT`) es el revisor previsto y todavía no ha emitido aprobación. C06 recibe esta documentación, pero permanece pendiente de reproducción independiente.

E01-E05 se configuraron en el panel el 27 y 28/10/2026 en la rama `feature/Ari`, desde la de Daniel. Los registros T07-T11 son parciales y enumeran la evidencia que falta; ninguno está aprobado ni revisado.

## Rúbrica del enunciado

Los siguientes pesos son puntos porcentuales de la nota final del curso y suman 25.

| Criterio | Peso | Evidencia prevista |
|---|---:|---|
| Justificación frente a alternativas | 3 | Decisiones, licencias, costos y fuentes. |
| Requisitos comunes y del escenario | 7 | Las 12 filas de esta matriz. |
| Pruebas reales | 3 | Restauración, denegaciones, persistencia y recuperación. |
| Documentación técnica | 2 | Guía, diagramas y reproducción. |
| Demo en vivo | 5 | Recorrido comprobado desde Mint. |
| Explicación de decisiones y compromisos | 3 | Registro de decisiones y ensayo. |
| Preguntas | 2 | Dominio de los cinco integrantes. |

## Diferencia con el programa

La rúbrica 9.2 del programa utiliza 60% funcionamiento, 20% documentación y 20% defensa dentro del proyecto. El enunciado usa el reparto anterior. **Pendiente consultar al profesor cuál regirá**; no sumarlos ni convertirlos en una sola rúbrica. Cubriremos ambos conjuntos de criterios.

El bonus de alta disponibilidad es opcional; no sustituye requisitos obligatorios ni tiene un puntaje detallado en el documento suministrado.
