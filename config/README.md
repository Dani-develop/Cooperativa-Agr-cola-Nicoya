# Fuentes de configuración del host

Las subcarpetas contienen fuentes públicas por área. No contienen claves privadas. Cada guía indica ruta de destino, propietario, permisos, validación y recarga. Los resultados reales se enlazan desde las pruebas; tener el archivo fuente no acredita su aceptación.

- [BIND9](bind9/README.md): C01.
- [Apache](apache/README.md): C02.
- [TLS](tls/README.md) y [política de Firefox](firefox/policies.json): confianza HTTPS de C02.
- [Docker](docker/README.md): C03 y conexión con C02.
- [vsftpd](vsftpd/README.md): C04.
- [Cron](cron/README.md): C05.

Compose mantiene por separado la configuración de los contenedores en la raíz del repo. Evitar dos copias divergentes de una misma configuración.
