# WordPress: contenido, identidad y roles

Estado: **implementado en el panel el 27 y 28/10/2026; probado solo en parte**. Requisitos E01-E05; contenido fuente en [contenido](../contenido/README.md). Procedimiento ejecutado en la [guía 14](14-ari-contenido-identidad-roles.md) y resultados en T07-T11 ([índice de evidencias](../evidencias/indice.md)). Las secciones siguientes conservan el plan original; la tabla de abajo indica lo observado.

## Plan y observado

| Requisito | Plan | Observado | Registro |
|---|---|---|---|
| E01 | Logo propio y paleta legible | Astra con plantilla de Starter Templates, logo propio y fondo `#E0D7C7` | [T07](../pruebas/registros/T07-E01-2026-10-28.md) |
| E02 | Menú de cinco secciones propuestas | Menú de cuatro: Inicio, Contacto, Nuestros Productos y Quiénes somos | [T08](../pruebas/registros/T08-E02-2026-10-28.md) |
| E03 | Cinco páginas y dos noticias de autores distintos | Cinco páginas y tres entradas publicadas, todas de un Administrador | [T09](../pruebas/registros/T09-E03-2026-10-28.md) |
| E04 | Galería (FooGallery como candidato) | Formulario con WPForms Lite 2.0.3 y WPFormsDB: "Contacto y Pedidos Agrícolas" | [T10](../pruebas/registros/T10-E04-2026-10-28.md) |
| E05 | Técnica, Editor, Autor A y Autor B | `ari_admin` y `daniel_admin` (Administrador), `admin_oficina` (Editor), `campo_nicoya` (Autor); falta Autor B | [T11](../pruebas/registros/T11-E05-2026-10-28.md) |

Decisión de plugin: se eligió un formulario porque el enunciado lo admite como ejemplo y se puede comprobar con la recepción de una consulta. La página Gallery existe, pero no cuenta como E04 mientras no se compruebe su función.

## Identidad y navegación

Crear logo propio y paleta legible. Registrar el tema y su versión/licencia. El tema predeterminado sin personalización no cumple. Menú propuesto: Inicio, Productos, La cooperativa, Información para asociados y Contacto.

Publicar al menos cinco páginas/entradas agrícolas genuinas. Proponemos las cinco secciones anteriores y dos noticias de campo de autores distintos. Registrar título, tipo, autor, URL, estado y fuentes en [inventario editorial](../contenido/inventario.csv). No presentar datos ficticios del caso como hechos de una cooperativa real.

## Plugin

Candidato: galería agrícola de productos y actividades, por ejemplo FooGallery gratuito. Antes de decidir, verificar licencia, versión, compatibilidad y función necesaria. Probar crear una galería y verla desde Mint; activarlo sin usarlo no cierra E04. Si se elige formulario, se debe comprobar recepción real de la consulta.

## Cuentas propuestas

| Cuenta funcional | Rol | Permitido | Denegado a probar |
|---|---|---|---|
| Técnica | Administrador | Configurar sitio, tema y plugins | Reservar para configuración, no para toda la demo. |
| Administración | Editor | Publicar/editar contenido, también ajeno | Administrar plugins y usuarios. |
| Campo A | Autor | Crear y publicar entradas propias | Editar entrada de Campo B e instalar plugins. |
| Campo B | Autor | Crear y publicar entradas propias | Editar entrada de Campo A y administrar usuarios. |

El Editor sí puede editar entradas ajenas; es el comportamiento correcto. El Autor trabaja con entradas y no tiene las capacidades del Editor sobre páginas. No es necesario inventar roles personalizados para cumplir los ejemplos del escenario.

## Procedimiento que se completará

1. Inicializar por el dominio HTTPS definitivo y verificar URLs del sitio.
2. Registrar versión real, tema, personalización y configuración del plugin.
3. Crear cuentas con contraseñas privadas, asignar roles y publicar contenido.
4. Probar con sesiones separadas operaciones permitidas y accesos directos denegados.
5. Verificar menú, imágenes, plugin y lectura en dos tamaños de pantalla.
6. Guardar fuentes y cambios del panel para reproducción y respaldo.

Evidencia: T07-T11. Registrar resultados en [pruebas](08-pruebas-y-resultados.md), sin mostrar credenciales.
