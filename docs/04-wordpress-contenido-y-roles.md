# WordPress: contenido, identidad y roles

Estado: planificación. Requisitos E01-E05; contenido fuente en [contenido](../contenido/README.md).

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
