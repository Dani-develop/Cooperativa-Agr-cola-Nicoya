# Apache y HTTPS

Estado: pendiente de implementación y validación. C02/T02.

## Archivos por incorporar

VirtualHost HTTP con redirección, HTTPS con ServerName, certificado propio y proxy a localhost. Establecer X-Forwarded-Proto y conservar Host. No subir clave privada.

## Aceptación

apache2ctl configtest; certificado SAN/vigencia/confianza; sitio y panel HTTPS desde Mint; backend inaccesible desde Mint.

Registrar en la guía las rutas reales, permisos, copia previa, validación antes de recargar y procedimiento de reversión. No se deben activar ejemplos incompletos.
