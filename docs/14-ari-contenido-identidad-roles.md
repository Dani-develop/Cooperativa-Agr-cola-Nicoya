# Ari: identidad, contenido, plugin y roles de WordPress

Estado: **ejecutado en el panel el 27 y 28/10/2026; probado en parte**. Cubre E01-E05. Parte de la infraestructura de Daniel ([guía 13](13-daniel-wordpress-https.md)): WordPress 7.1.3, HTTPS y acceso por `https://cooperativa.internal`. Resultados en [T07](../pruebas/registros/T07-E01-2026-10-28.md), [T08](../pruebas/registros/T08-E02-2026-10-28.md), [T09](../pruebas/registros/T09-E03-2026-10-28.md), [T10](../pruebas/registros/T10-E04-2026-10-28.md) y [T11](../pruebas/registros/T11-E05-2026-10-28.md).

## Identificación

- Requisitos: E01 identidad visual, E02 menú, E03 contenido, E04 plugin y E05 roles.
- Máquina: VM Mint con Firefox; todo el trabajo se hace en el panel `https://cooperativa.internal/wp-admin`.
- Usuario: `ari_admin` (Administrador de WordPress). Las contraseñas se guardan fuera de Git y no se muestran en capturas.
- Prerrequisitos: sitio instalado por [guía 13](13-daniel-wordpress-https.md), DNS y confianza TLS funcionando en Mint.
- Qué no versiona Git: tema, plantilla, páginas, entradas, menú, formularios y usuarios viven en la BD y en el volumen de archivos de WordPress. Se recuperan con el respaldo de [C05](06-respaldo-y-restauracion.md), no con un `git checkout`.

## Ejecución

### 1. Tema y plantilla (E01)

1. Apariencia > Temas > Añadir: instalar **Astra**.
2. Plugins > Añadir: instalar y activar **Starter Templates**.
3. En Apariencia > Starter Templates elegir "Classic Starter Templates" y el constructor **Block Editor**.
4. Elegir una plantilla (búsqueda `local business`). El asistente instala Spectra Blocks, SureForms, SureRank y SureCookie; el ciclo observado duró 1,37 minutos.
5. Editar las páginas que crea la plantilla (Inicio, Nuestros Productos, Quiénes somos, Contacto, Gallery).

### 2. Logo y colores (E01)

1. Generar el logo y guardarlo con su origen en [medios](../contenido/medios/README.md).
2. Apariencia > Personalizar: aplicar el logo en Identidad del sitio, ajustar la página Inicio (título, subtítulo, portada y tarjetas) y definir los colores. Valor observado: fondo del sitio `#E0D7C7`, con paleta global de verdes y negro.
3. Comprobar la página en escritorio y en un ancho reducido.

### 3. Menú y página de inicio (E02)

1. Apariencia > Menús: crear "Menú Principal" en la ubicación Primary Menu con Inicio, Contacto, Nuestros Productos y Quiénes somos; guardar.
2. Ajustes > Lectura: "Una página estática", con Inicio como página de inicio.
3. Recorrer cada enlace desde Mint y quitar cualquier destino de plantilla (por ejemplo, el mapa de Contacto).

### 4. Entradas y páginas (E03)

1. Entradas > Añadir: redactar noticias de campo con fuentes y publicar las revisadas.
2. Registrar cada pieza en el [inventario](../contenido/inventario.csv) y guardar su texto como Markdown en `contenido/paginas/` o `contenido/entradas/`.

### 5. Plugin de formulario (E04)

1. Plugins > Añadir: instalar **WPForms Lite** y crear el formulario "Contacto y Pedidos Agrícolas" (nombre, correo, comentario o mensaje).
2. En la página Contacto insertar el bloque WPForms con ese formulario.
3. Instalar **Database Addon for WPForms (WPFormsDB)**, porque WPForms Lite no almacena las respuestas.
4. Enviar un mensaje desde el sitio público y comprobar que aparece en WPFormsDB.

### 6. Usuarios y roles (E05)

1. Usuarios > Añadir: `admin_oficina` con rol Editor y `campo_nicoya` con rol Autor. Generar contraseñas privadas y no copiarlas a capturas.
2. Crear un segundo Autor y entradas propiedad de cada Autor.
3. Ejecutar el procedimiento de denegación del [registro T11](../pruebas/registros/T11-E05-2026-10-28.md).

## Validación

- Resultado esperado: el criterio de cada caso en [casos de prueba](../pruebas/casos.md) T07-T11.
- Resultado observado: parcial en los cinco casos; el detalle y lo que falta está en cada registro.
- Prueba permitida y denegada: la prueba denegada de E05 **no se ha ejecutado**.
- Evidencia: [evidencias/wordpress](../evidencias/wordpress/README.md). Responsable: Ari. Revisor: por asignar.

## Consideraciones

- La plantilla deja plugins que no se eligieron: SureForms (con un formulario "Simple Contact Form" sin terminar), SureRank y SureCookie. Registrar sus versiones y licencias, o desactivar los que no se usen.
- No hay SMTP: un formulario no envía correo. La recepción se comprueba en WPFormsDB.
- WordPress mostró un aviso de actualización a 7.1.4. El despliegue está fijado por digest ([T03](../pruebas/registros/T03-C03-2026-10-24.md)); no actualizar desde el panel sin acordarlo con Daniel.
- El aviso de Action Scheduler con acciones vencidas apareció en el panel de WPFormsDB; no se investigó y puede interesar a Cron (C05).
- Las imágenes del sitio están en el volumen de archivos: confirmar que el respaldo los incluye ([contenido](../contenido/README.md)).
- Reversión: desactivar el plugin o el tema desde el panel conserva los datos; borrar una página o un usuario no se deshace sin respaldo.

### Estado al cierre (07/11/2026)

El servidor de la VM dejó de estar accesible el 07/11/2026 a la 01:51, por lo que las siguientes acciones quedan **sin hacer**:

- Reemplazar el logo de plantilla "GREEN GARDENER" del encabezado de Contacto y la imagen de portada móvil de plantilla por material propio.
- Capturar la vista de tablet (768 px).
- Repetir las denegaciones de roles mostrando la sesión activa (escritorio con "Howdy, usuario" antes de cada una), y listar un segundo Autor real.
- Repetir la edición del Editor sobre una entrada de `campo_nicoya`, ya que la entrada 2961 tiene autor `admin_oficina`.
- Pegar en WordPress los textos de `contenido/entradas/`.
- Verificar licencias de los plugins y de las imágenes generadas con IA.

## Licencias de los componentes (consulta del 08/11/2026)

Fuente: encabezado `readme.txt` de la versión estable publicada, servido por el espejo de jsDelivr para wordpress.org (`cdn.jsdelivr.net/wp/plugins/<slug>/trunk/readme.txt`). La versión estable puede ser **más nueva** que la instalada (captura del 03/11/2026), así que la licencia de la versión instalada debe confirmarse en Plugins > Instalados.

| Componente | Versión instalada | Estable consultada | Licencia declarada | Observación |
|---|---|---|---|---|
| WPForms Lite (`wpforms-lite`) | 2.0.3 | 2.0.3 | GPL v2.0 o posterior | Coincide con la instalada |
| Starter Templates (`astra-sites`) | 4.7.9 | 4.7.11 | GPLv2 o posterior | Hay actualización |
| SureForms (`sureforms`) | 2.13.0 | 2.13.1 | GPLv2 o posterior | Hay actualización |
| SureRank (`surerank`) | 1.10.3 | 1.10.3 | GPLv2 o posterior | Coincide |
| SureCookie (`surecookie`) | 1.7.0 | 1.8.0 | GPLv2 o posterior | Hay actualización |
| Spectra (`ultimate-addons-for-gutenberg`) | "Spectra Blocks" 1.0.12 en el panel | 2.20.6 | GPLv2 o posterior | La versión y el nombre no coinciden con el slug consultado; confirmar que sea el mismo plugin |
| Astra (tema) | 4.14.2 | no consultada | GPL v2 o posterior (style.css de v4.5.0) | Confirmar en la versión instalada |
| Database for WPForms | 1.1.1 | no consultada | **No verificada** | El readme no se pudo obtener |

Imágenes y logo generados con DALL·E 3: los términos de OpenAI **no se pudieron consultar** (la página rechazó la consulta). Los términos de uso vigentes en https://openai.com/policies/terms-of-use deben leerse por una persona antes de dar la licencia por verificada.
