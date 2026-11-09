# WordPress: contenido, identidad y roles

Estado al 08/11/2026: **implementado y probado; falta revisión humana**. Requisitos E01-E05; contenido fuente en [contenido](../contenido/README.md). Procedimiento ejecutado en la [guía 14](14-ari-contenido-identidad-roles.md) y resultados en T07-T11 ([índice de evidencias](../evidencias/indice.md)). Las secciones siguientes conservan el plan original; la tabla de abajo indica lo observado al 08/11/2026.

## Plan y observado

| Requisito | Plan | Observado | Registro |
|---|---|---|---|
| E01 | Logo propio y paleta legible | Astra 4.14.2 con plantilla de Starter Templates, logo propio y fondo `#E0D7C7`; casi completo: en móvil el logo se solapa con el título en Inicio y Contacto | [T07](../pruebas/registros/T07-E01-2026-10-28.md) |
| E02 | Menú de cinco secciones propuestas | Menú de cuatro secciones: Inicio, Nuestros Productos, Quiénes somos e Información para asociados, más el botón Contáctenos (`/contact/`) | [T08](../pruebas/registros/T08-E02-2026-10-28.md) |
| E03 | Cinco páginas y dos noticias de autores distintos | Cinco páginas (Inicio, Nuestros Productos, Quiénes somos, Contacto, Información para Asociados) y seis entradas de tres autores: `ari_admin`, `campo_nicoya` y `campo_liberia` | [T09](../pruebas/registros/T09-E03-2026-10-28.md) |
| E04 | Formulario de contacto con almacenamiento de respuestas (FooGallery descartado) | Formulario "Contacto y Pedidos Agrícolas" con WPForms Lite 2.0.3 y WPFormsDB 1.1.1; envío público comprobado (6 entradas guardadas). Observación: texto "Please enable JavaScript" visible | [T10](../pruebas/registros/T10-E04-2026-10-28.md) |
| E05 | Técnica, Editor, Autor A y Autor B | `ari_admin` y `daniel_admin` (Administrador), `admin_oficina` (Editor), `campo_nicoya` y `campo_liberia` (Autores); denegaciones y permisos comprobados | [T11](../pruebas/registros/T11-E05-2026-10-28.md) |

Decisión de plugin: se eligió un formulario porque el enunciado lo admite como ejemplo y se puede comprobar con la recepción de una consulta. La página Gallery de la plantilla ya no figura en la lista de páginas y nunca contó como E04.

## Identidad y navegación

Crear logo propio y paleta legible. Registrar el tema y su versión/licencia. El tema predeterminado sin personalización no cumple. Menú propuesto: Inicio, Productos, La cooperativa, Información para asociados y Contacto.

Publicar al menos cinco páginas/entradas agrícolas genuinas. Proponemos las cinco secciones anteriores y dos noticias de campo de autores distintos. Registrar título, tipo, autor, URL, estado y fuentes en [inventario editorial](../contenido/inventario.csv). No presentar datos ficticios del caso como hechos de una cooperativa real.

## Plugin

Plugin elegido: formulario de contacto (WPForms Lite) con almacenamiento de respuestas (Database for WPForms). La galería con FooGallery fue un candidato descartado. Licencias consultadas el 08/11/2026 en la [guía 14](14-ari-contenido-identidad-roles.md); la de Database for WPForms sigue sin verificar.

## Cuentas propuestas

| Cuenta funcional | Rol | Permitido | Denegado a probar |
|---|---|---|---|
| Técnica | Administrador | Configurar sitio, tema y plugins | Reservar para configuración, no para toda la demo. |
| Administración | Editor | Publicar/editar contenido, también ajeno | Administrar plugins y usuarios. |
| Campo A | Autor | Crear y publicar entradas propias | Editar entrada de Campo B e instalar plugins. |
| Campo B | Autor | Crear y publicar entradas propias | Editar entrada de Campo A y administrar usuarios. |

El Editor sí puede editar entradas ajenas; es el comportamiento correcto. El Autor trabaja con entradas y no tiene las capacidades del Editor sobre páginas. No es necesario inventar roles personalizados para cumplir los ejemplos del escenario.

## Procedimiento (ejecutado)

1. Inicializar por el dominio HTTPS definitivo y verificar URLs del sitio.
2. Registrar versión real, tema, personalización y configuración del plugin.
3. Crear cuentas con contraseñas privadas, asignar roles y publicar contenido.
4. Probar con sesiones separadas operaciones permitidas y accesos directos denegados.
5. Verificar menú, imágenes, plugin y lectura en dos tamaños de pantalla.
6. Guardar fuentes y cambios del panel para reproducción y respaldo.

Evidencia: T07-T11. Registrar resultados en [pruebas](08-pruebas-y-resultados.md), sin mostrar credenciales.
