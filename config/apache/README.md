# Apache y HTTPS

Responsable de C02/T02: Daniel. Fuente única: [cooperativa.conf](cooperativa.conf). El estado observado y la revisión se registran en [T02](../../pruebas/casos.md#t02).

## Aplicación en Ubuntu

Primero generar el certificado y la CA con [las fuentes TLS](../tls/README.md). Desde la raíz del repositorio de Ubuntu:

```bash
sudo install -m 644 config/apache/cooperativa.conf /etc/apache2/sites-available/cooperativa.conf
sudo a2enmod ssl proxy proxy_http headers
sudo a2ensite cooperativa.conf
sudo apache2ctl configtest
sudo systemctl reload apache2
```

Recargar solo si `configtest` finaliza correctamente. El archivo nuevo recibe 80/443 y envía al backend `127.0.0.1:8082`. HTTP se redirige al dominio HTTPS. `ProxyRequests Off` evita un proxy abierto; `ProxyPreserveHost On` conserva el dominio; Apache sustituye `X-Forwarded-Proto` por `https` para que WordPress detecte TLS. Se deniegan `wp-config.php`, `.env` y `.git` por HTTP.

No reemplaza archivos de BIND9, DHCP ni Netplan. La configuración heredada de Axel se conserva. Las claves permanecen en `/etc/ssl/private/cooperativa`, con propietario root y modo 600.

## Aceptación

apache2ctl configtest; certificado SAN/vigencia/confianza; sitio y panel HTTPS desde Mint; backend inaccesible desde Mint.

Si se aplica sobre un sitio existente, guardar antes una copia de su configuración. Para revertir únicamente este sitio: `sudo a2dissite cooperativa.conf`, restaurar la configuración anterior si existía, ejecutar `sudo apache2ctl configtest` y recargar. No borrar los volúmenes Docker ni la CA durante una corrección de Apache.

Procedimiento completo y consideraciones: [guía de Daniel](../../docs/13-daniel-wordpress-https.md).
