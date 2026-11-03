# Evidencias E01-E05 / T07-T11

Capturadas el 27 y 28/10/2026 por Ari en la VM Mint con Firefox, sobre `https://cooperativa.internal` (candado visible). Revisión humana pendiente. Infraestructura bajo prueba: `9674c2b`; el contenido del panel vive en la BD y no se versiona. Registros: [T07](../../pruebas/registros/T07-E01-2026-10-28.md), [T08](../../pruebas/registros/T08-E02-2026-10-28.md), [T09](../../pruebas/registros/T09-E03-2026-10-28.md), [T10](../../pruebas/registros/T10-E04-2026-10-28.md) y [T11](../../pruebas/registros/T11-E05-2026-10-28.md).

Capturas reales del panel, sin reconstrucción gráfica. Antes de publicarlas se ocultaron contraseñas, correos personales y una pestaña del navegador ajena al proyecto, como pide [CONTRIBUTING](../../CONTRIBUTING.md). Las originales sin editar permanecen con la autora.

## E01 / T07: identidad visual

| Archivo | Qué demuestra |
|---|---|
| [Tema Astra](E01-T07-tema-astra-instalado.png) | Astra instalado desde Añadir temas |
| [Starter Templates](E01-T07-plugin-starter-templates.png) | Plugin de plantillas encontrado e instalable |
| [Plantilla 1](E01-T07-plantilla-01-modo-constructor.png), [2](E01-T07-plantilla-02-block-editor.png), [3](E01-T07-plantilla-03-instalacion.png), [4](E01-T07-plantilla-04-sitio-listo.png) | Modo clásico, Block Editor, instalación de plugins requeridos y sitio listo |
| [Inicio en escritorio](E01-T07-inicio-escritorio.png) | Portada propia, menú y botón de contacto |
| [Colores](E01-T07-colores-personalizador.png) | Fondo `#E0D7C7` y paleta en el Personalizador |

## E02 / T08: menú

| Archivo | Qué demuestra |
|---|---|
| [Menú Principal](E02-T08-menu-principal-admin.png) | Cuatro secciones en la ubicación Primary Menu |
| [Página de inicio](E02-T08-pagina-inicio-estatica.png) | Inicio como página estática |

## E03 / T09: contenido

| Archivo | Qué demuestra |
|---|---|
| [Páginas](E03-T09-paginas-lista.png) | Cinco páginas publicadas el 27/10/2026 y una en borrador |
| [Entradas](E03-T09-entradas-lista.png) | Entradas publicadas y en borrador (5 de 7 filas visibles) |
| [Productos en edición](E03-T09-productos-edicion-en-curso.png) | Trabajo en curso con bloques vacíos; **no** acredita contenido terminado |

## E04 / T10: formulario

| Archivo | Qué demuestra |
|---|---|
| [Panel WPForms](E04-T10-wpforms-panel.png) | WPForms Lite 2.0.3 |
| [Formulario creado](E04-T10-formulario-creado.png) | "Contacto y Pedidos Agrícolas" |
| [Bloque en Contacto](E04-T10-formulario-en-contacto-editor.png) | Formulario insertado en la página (vista del editor) |
| [WPFormsDB](E04-T10-wpformsdb-activo.png) | Plugin de guardado de respuestas, activo |
| [Entrada 23:42](E04-T10-entrada-2026-10-28-2342.png), [lista](E04-T10-entradas-lista-2026-10-28.png), [entrada 23:49](E04-T10-entrada-2026-10-28-2349.png) | Dos mensajes de prueba guardados el 28/10/2026 |

## E05 / T11: roles

| Archivo | Qué demuestra |
|---|---|
| [Crear Editor](E05-T11-usuario-editor-crear.png) | Cuenta `admin_oficina` con rol Editor |
| [Crear Autor](E05-T11-usuario-autor-crear.png) | Cuenta `campo_nicoya` con rol Autor (incluye un primer intento con correo repetido) |
| [Usuarios](E05-T11-usuarios-lista.png) | Cuatro usuarios y sus roles |

## Evidencia que falta

| Requisito | Falta |
|---|---|
| E01 | Logo aplicado en el encabezado; misma página en dos tamaños de pantalla; Astra activo y versión; versiones de plugins de la plantilla |
| E02 | Recorrido de cada enlace con su URL; quitar el mapa de plantilla (Pune, India) de Contacto; destino de "Contáctenos" |
| E03 | Texto, URL y fuentes de cada pieza; captura pública de cinco piezas; las dos entradas no visibles; revisor |
| E04 | Formulario en la página pública y mensaje de confirmación; versión y licencia de WPFormsDB y de los plugins de la plantilla |
| E05 | Prueba de denegación con sesiones separadas (Autor y Editor); segundo Autor; entradas propiedad de un Autor |
| Medios | Origen, licencia y herramienta de generación de logo e imágenes ([medios](../../contenido/medios/README.md)) |

Sin registro de prueba, cualquier resultado esperado es criterio de aceptación. [Índice general](../indice.md).
