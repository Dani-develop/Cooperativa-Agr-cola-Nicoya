# Pruebas y resultados

T01 conserva el registro de Axel. Daniel ejecutó T02/T03 y una comprobación parcial de reinicio el 24/10/2026; Frander todavía debe revisar esos resultados. Los demás casos siguen pendientes. No se trasladan resultados de los laboratorios como evidencia del proyecto.

Los procedimientos están en [casos de prueba](../pruebas/casos.md) y los archivos en [registros](../pruebas/registros/README.md). El índice de capturas está en [evidencias](../evidencias/indice.md).

| Prueba | Resultado | Fecha/equipo | Commit de configuración | Registro | Revisor |
|---|---|---|---|---|---|
| T01 | Aprobado, heredado | 2026-10-21 / Ubuntu + Mint | `83de95a` | [DNS](../pruebas/registros/T01-C01-2026-10-21.md) | Daniel |
| T02 | Pruebas técnicas satisfactorias; revisión pendiente | 2026-10-24 / Ubuntu + Mint | `f2520a6`; repetición `9f1ac00` | [HTTPS](../pruebas/registros/T02-C02-2026-10-24.md) | Frander, pendiente |
| T03 | Persistencia y versiones comprobadas; revisión pendiente | 2026-10-24 / Ubuntu + Mint | `f2520a6`; lectura adicional `9f1ac00` | [Persistencia](../pruebas/registros/T03-C03-2026-10-24.md) | Frander, pendiente |
| T04 | Pendiente | | | | |
| T05 | Pendiente | | | | |
| T06 | Pendiente | | | | |
| T07 | Pendiente | | | | |
| T08 | Pendiente | | | | |
| T09 | Pendiente | | | | |
| T10 | Pendiente | | | | |
| T11 | Pendiente | | | | |
| T12 | Pendiente | | | | |
| T13 | Parcial: DNS/HTTPS/Docker/datos; integral pendiente | 2026-10-24 / Ubuntu + Mint | `9f1ac00` | [Reinicio técnico en T03](../pruebas/registros/T03-C03-2026-10-24.md) | Frander, pendiente |

## Formato del registro

Copiar [plantilla de resultado](../pruebas/registros/plantilla.md). Registrar entrada, operación, resultado esperado, resultado observado, salida original y veredicto. Si falló, conservar la incidencia y agregar la repetición tras corregirla.

Nunca generar capturas de una prueba no ejecutada ni reemplazar la salida observada con un ejemplo. La aceptación de cada requisito debe enlazar el registro que la demuestra.
