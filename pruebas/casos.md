# Casos de prueba

T01 conserva la aprobación de Axel. T02/T03 tienen resultados técnicos de Daniel del 24/10/2026, pendientes de revisión de Frander. Los demás casos siguen pendientes; T13 solo tiene una comprobación parcial de las capas ya instaladas. Registrar máquina, fecha, commit, entrada, salida observada, veredicto y revisor usando la [plantilla](registros/plantilla.md). Los criterios siguientes se distinguen de sus registros reales.

<a id="t01"></a>

## T01: DNS real

Requisito: C01.

Procedimiento: Validar configuración y zona. Consultar A y SOA al servidor desde Mint y resolver normalmente. Comprobar DNS del cliente y ausencia de entrada del dominio en hosts.

Esperado: Respuesta autoritativa y resolución normal con la dirección acordada.

Estado: aprobado, heredado sin modificar el registro. [T01 de Axel](registros/T01-C01-2026-10-21.md) y [evidencias DNS](../evidencias/dns/README.md).

<a id="t02"></a>

## T02: HTTPS y acceso al backend

Requisito: C02.

Procedimiento: Probar redirección HTTP, identidad/confianza TLS y sitio/panel por dominio desde Mint. Intentar alcanzar el puerto backend desde Mint.

Esperado: HTTPS correcto y backend directo inaccesible desde el cliente.

Estado: probado/documentado, revisión de Frander pendiente. [Registro T02](registros/T02-C02-2026-10-24.md), [evidencias](../evidencias/https/README.md). Repetición automatizada: `bash pruebas/t02-desde-mint.sh`, con CA confiada en Mint. Iniciar sesión también para comprobar el panel autenticado.

<a id="t03"></a>

## T03: Persistencia y versiones

Requisito: C03.

Procedimiento: Registrar imágenes/digests y datos visibles, crear entrada e imagen identificables, recrear servicios sin eliminar volúmenes y repetir lectura.

Esperado: BD saludable, datos y archivos conservados; versiones registradas.

Estado: probado/documentado, revisión de Frander pendiente. [Registro T03](registros/T03-C03-2026-10-24.md), [evidencias](../evidencias/docker/README.md). Procedimiento completo en [guía de Daniel](../docs/13-daniel-wordpress-https.md#9-ejecutar-t03-en-ubuntu).

<a id="t04"></a>

## T04: Aislamiento FTP

Requisito: C04.

Procedimiento: Con A realizar operaciones propias. Con B crear un archivo. Intentar modificar/borrar el archivo de B como A, incluyendo ruta directa.

Esperado: Operaciones propias permitidas; ajenas denegadas y original conservado.

Estado: pendiente. Registro y evidencia: por incorporar.

<a id="t05"></a>

## T05: Cron y restauración

Requisito: C05.

Procedimiento: Esperar ejecución real de Cron, inspeccionar resultado y restaurar BD/archivos en destino aislado. Comprobar entrada, imagen, plugin y roles.

Esperado: Copia generada automáticamente y recuperación integral comprobada, con duración medida.

Estado: pendiente. Registro y evidencia: por incorporar.

<a id="t06"></a>

## T06: Reproducción independiente

Requisito: C06.

Procedimiento: Otro integrante parte de una VM limpia, registra commit, sigue todas las capas de la guía y documenta ayuda/pasos faltantes.

Esperado: Instalación operativa reproducida y guía corregida.

Estado: pendiente. Registro y evidencia: por incorporar.

<a id="t07"></a>

## T07: Identidad visual

Requisito: E01.

Procedimiento: Comprobar tema, logo y colores propios en escritorio y ancho reducido; registrar versión y fuentes.

Esperado: Personalización visible y legible.

Estado: pendiente. Registro y evidencia: por incorporar.

<a id="t08"></a>

## T08: Navegación

Requisito: E02.

Procedimiento: Recorrer todos los enlaces de al menos cuatro secciones desde Mint y registrar destinos.

Esperado: Destinos correctos y contenido publicado, sin enlaces de ejemplo.

Estado: pendiente. Registro y evidencia: por incorporar.

<a id="t09"></a>

## T09: Contenido genuino

Requisito: E03.

Procedimiento: Contar y revisar cinco o más páginas/entradas agrícolas publicadas, cotejando inventario, fuentes y autoría.

Esperado: Cantidad mínima y contenido útil relacionado con el caso.

Estado: pendiente. Registro y evidencia: por incorporar.

<a id="t10"></a>

## T10: Plugin funcional

Requisito: E04.

Procedimiento: Instalar/configurar el plugin seleccionado y usar su función desde el sitio; registrar versión/licencia.

Esperado: Función útil visible y comprobada, no solo plugin activo.

Estado: pendiente. Registro y evidencia: por incorporar.

<a id="t11"></a>

## T11: Roles WordPress

Requisito: E05.

Procedimiento: En sesiones separadas, Autor A publica lo propio e intenta editar una entrada de Autor B y administrar plugins/usuarios. Editor prueba gestión de contenido.

Esperado: Cada operación coincide con la matriz de capacidades; el Editor sí edita contenido ajeno.

Estado: pendiente. Registro y evidencia: por incorporar.

<a id="t12"></a>

## T12: Justificación y fuentes

Requisito: E06.

Procedimiento: Revisar componentes, licencias y comparación con alternativa comercial y CMS libre; relacionar costos y soporte con el caso.

Esperado: Decisiones justificadas con fuentes y costos totales, sin confundir libre con costo cero.

Estado: pendiente. Registro y evidencia: por incorporar.

<a id="t13"></a>

## T13: Recuperación tras reinicio

Requisito: C02, C03 y operación.

Procedimiento: Con respaldo previo, reiniciar la VM dedicada en ventana acordada y comprobar DNS, HTTPS, Docker, datos, FTP y programación.

Esperado: Servicios y contenido recuperados según lo documentado.

Estado integral: pendiente. El [registro T03](registros/T03-C03-2026-10-24.md) comprueba reinicio de DNS/Apache/Docker y persistencia; todavía faltan FTP, Cron, respaldo previo y aceptación integral.
