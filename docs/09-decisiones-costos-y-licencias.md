# Decisiones, costos y licencias

Estado: comparación e inventario completados el 07/11/2026 ([T12](../pruebas/registros/T12-E06-2026-11-07.md)); revisión humana pendiente. E06/T12.

| Decisión | Razón | Compromiso y validación pendiente |
|---|---|---|
| WordPress autogestionado | Plataforma asignada y adecuada para publicación distribuida | El grupo mantiene actualizaciones, permisos y respaldo. |
| VM dedicada | Conservar laboratorios y evitar servicios heredados | Requiere recursos y preparar otra instalación Ubuntu. |
| Apache como proxy en host | Reutiliza lo aprendido y concentra HTTPS | Compose no despliega el host; documentar BIND9, Apache, FTP y Cron. |
| Dos servicios con volúmenes separados | Aislar aplicación y datos y conservar estado | Persistencia no protege de pérdida del volumen/VM. |
| FTP con TLS y directorios privados | Cumplir FTP con aislamiento y proteger credenciales | Probar cliente, certificado, puertos pasivos y permisos. |
| Formulario de contacto (WPForms Lite + Database for WPForms) como plugin de E04; FooGallery descartado | Utilidad agrícola comprobable sin correo externo | Licencia de Database for WPForms sin verificar; comprobar versión y recuperación de las respuestas guardadas. |
| Cron y recuperación integral | Responder a la pérdida de información del caso | Medir pérdida máxima tolerada y duración de recuperación. |

## Comparación

WordPress está asignado; la comparación justifica la adecuación al caso, no simula una elección libre de plataforma. Precios consultados el 07/11/2026; no se compró ningún plan.

| Alternativa | Licencia/libertades | Costo de licencia/servicio | Operación y soporte | Adaptación al caso | Fuente y fecha |
|---|---|---|---|---|---|
| WordPress autogestionado | GPLv2 o posterior | Sin costo de licencia | A cargo del grupo; documentación oficial y foros de comunidad | Publicación por roles nativos | [Licencia](https://wordpress.org/about/license/), [documentación](https://wordpress.org/support/) |
| Wix (comercial alojado) | Propietaria | Light $17,77, Core $29,77 y Business $39,77 por mes ("Price includes GST"); dominio gratis el primer año | Incluido en el plan; centro de ayuda y contratación de profesionales | Rápido de iniciar, poco control sobre la infraestructura y los datos | [Planes de Wix](https://www.wix.com/plans), 07/11/2026; ExpertMarket 2026 como contraste |
| Drupal (CMS libre) | GPLv2 o posterior | Sin costo de licencia | A cargo del grupo | Roles muy granulares, con más complejidad de la necesaria | [Licensing FAQ](https://www.drupal.org/licensing/faq) |

Software libre no equivale a costo total cero. Incluir equipo, energía, tiempo, respaldo, capacitación y soporte. GitHub es una herramienta de documentación; no es un componente necesario para servir el portal.

## Inventario de licencias

Versiones y licencias verificadas en `cooperativa-server` el 07/11/2026. Las imágenes incluyen múltiples componentes; se cita la licencia del proyecto principal.

| Componente/recurso | Versión real | Licencia | Fuente oficial | Restricciones/atribución |
|---|---|---|---|---|
| WordPress | 7.1.4 (imagen fijada 7.1.3), PHP 8.3.36 | GPLv2 o posterior | `license.txt`; WordPress.org | Ninguna adicional |
| MariaDB | 11.8.9 | GPLv2 | [COPYING](https://github.com/MariaDB/server/blob/11.8/COPYING) | |
| Apache HTTP Server | 2.4.66 host; 2.4.69 contenedor | Apache License 2.0 | copyright del paquete | |
| Docker Engine y Compose | 29.9.2; 5.6.1 | Apache License 2.0 | [moby](https://github.com/moby/moby/blob/master/LICENSE), [compose](https://github.com/docker/compose/blob/main/LICENSE) | |
| BIND9 | 9.20.24 | MPL 2.0 | copyright del paquete | |
| vsftpd | 3.0.5 | GPLv2 con excepción SSL | copyright del paquete | |
| Astra | 4.14.2 | GPLv2 o posterior | cabecera de `style.css` | |
| WPForms Lite; Database for WPForms | 2.0.3; 1.1.1 | GPLv2 o posterior | cabecera del plugin | |
| Starter Templates, Spectra Blocks, SureForms, SureRank, SureCookie | 4.7.9; 1.0.12; 2.13.0; 1.10.3; 1.7.0 | GPLv2 o posterior | cabecera o `readme.txt` | |
| Akismet (sin activar) | 5.7.2 | GPLv2 o posterior | cabecera del plugin | |
| Imágenes y logo del sitio | Generadas con DALL·E 3 (declaración de Ari, 03/11/2026) | Términos de uso por verificar | | Presentar como imágenes generadas con IA |

No se aplica aquí una licencia a obras de terceros ni a documentos del profesor. La licencia del material propio se acordará con el grupo antes de añadir un archivo LICENSE.
