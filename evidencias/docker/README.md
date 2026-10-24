# Evidencias C03 / T03

Persistencia probada el 24/10/2026 por Daniel. Revisión humana de Frander pendiente. Registro: [T03-C03](../../pruebas/registros/T03-C03-2026-10-24.md). Configuración `f2520a6`; verificador de lectura añadido en `9f1ac00` sin cambiar Compose/Apache/TLS.

| Archivo | Qué demuestra |
|---|---|
| [Línea base de Axel](C03-T03-linea-base-axel-2026-10-23.txt) | Hashes antes de instalar Docker/Apache; comparar con el registro final |
| [Estado técnico JSON](C03-T03-estado-2026-10-24.json) | IDs, URLs y hashes del objeto de prueba; no contiene secretos |
| [Antes de recrear](C03-T03-antes-2026-10-24.txt) | Imágenes/digests, IDs de contenedores, volúmenes y primer `PERSISTENCIA_OK` |
| [Lectura anterior desde Mint](C03-T03-mint-antes-2026-10-24.txt) | Entrada/PNG 200 y hash de los bytes descargados |
| [Después de recrear](C03-T03-despues-2026-10-24.txt) | Contenedores nuevos, mismos volúmenes/datos y mismo hash |
| [Lectura posterior desde Mint](C03-T03-mint-despues-2026-10-24.txt) | Entrada e imagen siguen utilizables por HTTPS |
| [Servidor reiniciado](C03-T03-reinicio-servidor-2026-10-24.txt) | Arranque automático, datos conservados y archivos de Axel sin cambios |
| [Mint tras reinicio](C03-T03-mint-reinicio-2026-10-24.txt) | Repetición de lectura con idéntico PNG |
| [Reinstalación denegada](C03-T03-no-reinstalar-2026-10-24.txt) | Bootstrap devuelve 2 sobre el sitio existente |
| [Cierre técnico](C03-T03-cierre-2026-10-24.txt) | Entrada en borrador y sesiones técnicas invalidadas al terminar |
| [Página real en Firefox](C03-T03-entrada-mint-2026-10-24.png) | Entrada e imagen visibles con el dominio y la conexión confiable |

El objeto técnico es la entrada 4 y el adjunto 5; no acredita los cinco contenidos agrícolas de E03. La entrada queda en borrador para el siguiente integrante, conservando el PNG. Los dos volúmenes permanecen en la VM; no se publican como respaldos ni se eliminan. [Índice general](../indice.md).
