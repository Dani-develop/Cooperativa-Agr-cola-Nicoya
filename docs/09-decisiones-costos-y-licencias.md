# Decisiones, costos y licencias

Estado: arquitectura inicial acordada por el equipo; detalles técnicos pendientes de validar. E06/T12.

| Decisión | Razón | Compromiso y validación pendiente |
|---|---|---|
| WordPress autogestionado | Plataforma asignada y adecuada para publicación distribuida | El grupo mantiene actualizaciones, permisos y respaldo. |
| VM dedicada | Conservar laboratorios y evitar servicios heredados | Requiere recursos y preparar otra instalación Ubuntu. |
| Apache como proxy en host | Reutiliza lo aprendido y concentra HTTPS | Compose no despliega el host; documentar BIND9, Apache, FTP y Cron. |
| Dos servicios con volúmenes separados | Aislar aplicación y datos y conservar estado | Persistencia no protege de pérdida del volumen/VM. |
| FTP con TLS y directorios privados | Cumplir FTP con aislamiento y proteger credenciales | Probar cliente, certificado, puertos pasivos y permisos. |
| Galería como plugin inicial | Utilidad agrícola comprobable sin correo externo | Verificar licencia, versión y recuperación de sus medios. |
| Cron y recuperación integral | Responder a la pérdida de información del caso | Medir pérdida máxima tolerada y duración de recuperación. |

## Comparación por desarrollar

Comparar con una alternativa comercial de sitio alojado y otra CMS libre. WordPress está asignado; la comparación justifica la adecuación al caso, no simula una elección libre de plataforma. Registrar fecha y fuente de cualquier precio. No comprar planes para hacer la comparación.

| Alternativa | Licencia/libertades | Costo de licencia/servicio | Operación y soporte | Adaptación al caso | Fuente y fecha |
|---|---|---|---|---|---|
| WordPress autogestionado | GPLv2 o posterior | Por completar con fuente | A cargo del grupo/cooperativa | Publicación por roles | Ver referencias |
| Comercial por seleccionar | Pendiente | Pendiente | Pendiente | Pendiente | Pendiente |
| CMS libre por seleccionar | Pendiente | Pendiente | Pendiente | Pendiente | Pendiente |

Software libre no equivale a costo total cero. Incluir equipo, energía, tiempo, respaldo, capacitación y soporte. GitHub es una herramienta de documentación; no es un componente necesario para servir el portal.

## Inventario de licencias

Registrar Ubuntu/paquetes, Docker Engine/Compose, WordPress, MariaDB, tema, plugin y recursos gráficos. Las imágenes incluyen múltiples componentes; citar la licencia del proyecto y las fuentes correspondientes, sin reducir toda la distribución a una sola licencia.

| Componente/recurso | Versión real | Licencia | Fuente oficial | Restricciones/atribución |
|---|---|---|---|---|
| Pendiente | | | | |

No se aplica aquí una licencia a obras de terceros ni a documentos del profesor. La licencia del material propio se acordará con el grupo antes de añadir un archivo LICENSE.
