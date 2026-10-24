# Contenedores de Daniel

Fuentes únicas: [compose.yaml](../../compose.yaml) y [.env.example](../../.env.example). Requisitos C03/T03 y conexión con C02/T02.

Solo hay dos servicios permanentes: `wordpress` y `bd`. WordPress publica `127.0.0.1:8082`; MariaDB no publica puertos al host. Apache del host recibe HTTP/HTTPS. Se conservan los nombres del diseño original y los dos volúmenes `datos_bd` y `archivos_wordpress`.

Las variables de `.env` deben completarse localmente, con dos contraseñas diferentes. Permisos: directorio de despliegue 700 y `.env` 600, pertenecientes al administrador. `docker compose config -q` valida sin imprimir secretos. El usuario de WordPress en la BD es `cooperativa_web`, distinto de root.

`WORDPRESS_CONFIG_EXTRA` fija las dos URLs HTTPS y exige HTTPS en el panel. La imagen oficial interpreta `X-Forwarded-Proto`, que Apache sustituye por su valor real. `DISALLOW_FILE_EDIT` deshabilita el editor de código del panel; permite que Arii instale el tema/plugin de su área.

WordPress recibe archivos y BD persistentes. `docker compose down` conserva los volúmenes; `down -v` los elimina y no forma parte de la operación ordinaria. La prueba T03 debe comparar una entrada, una imagen, sus identificadores y su hash antes y después de recrear servicios. Versiones y digests se registran cuando se descarguen y prueben en la VM; la configuración por sí sola no acredita C03.

Procedimiento, consideraciones y reversión: [guía de Daniel](../../docs/13-daniel-wordpress-https.md). Estado observado: ver [resultados](../../docs/08-pruebas-y-resultados.md).
