# Contenedores de Daniel

Fuentes únicas: [compose.yaml](../../compose.yaml) y [.env.example](../../.env.example). Requisitos C03/T03 y conexión con C02/T02.

Solo hay dos servicios permanentes: `wordpress` y `bd`. WordPress publica `127.0.0.1:8082`; MariaDB no publica puertos al host. Apache del host recibe HTTP/HTTPS. Se conservan los nombres del diseño original y los dos volúmenes `datos_bd` y `archivos_wordpress`.

Las variables de `.env` deben completarse localmente, con dos contraseñas diferentes. Permisos: directorio de despliegue 700 y `.env` 600, pertenecientes al administrador. `docker compose config -q` valida sin imprimir secretos. El usuario de WordPress en la BD es `cooperativa_web`, distinto de root.

`WORDPRESS_CONFIG_EXTRA` fija las dos URLs HTTPS y exige HTTPS en el panel. La imagen oficial interpreta `X-Forwarded-Proto`, que Apache sustituye por su valor real. `DISALLOW_FILE_EDIT` deshabilita el editor de código del panel; permite que Arii instale el tema/plugin de su área.

WordPress recibe archivos y BD persistentes. `docker compose down` conserva los volúmenes; `down -v` los elimina y no forma parte de la operación ordinaria. La prueba T03 debe comparar una entrada, una imagen, sus identificadores y su hash antes y después de recrear servicios. Versiones y digests se registran cuando se descarguen y prueben en la VM; la configuración por sí sola no acredita C03.

Procedimiento, consideraciones y reversión: [guía de Daniel](../../docs/13-daniel-wordpress-https.md). Estado observado: ver [resultados](../../docs/08-pruebas-y-resultados.md).

## Descargar con carga limitada

En este host VirtualBox trabaja sobre el hipervisor de Windows y se observaron bloqueos del kernel durante la preparación. Para descargar se mantuvo solo Ubuntu encendido y se usó `sudo docker compose --parallel 1 pull --quiet`. Después se autorizó probar 1 CPU en ambas copias; las pruebas finales usan ese ajuste. BIND9, DHCP, Netplan, las MAC y la RAM de Axel se conservan. Ver [incidencia y recuperación](../../docs/07-operacion-y-diagnostico.md#incidencias).

[daemon.json](daemon.json) limita las descargas concurrentes de Docker. Si se instala sobre un daemon con configuración previa, integrar la clave y conservar sus otras opciones; no sobrescribir un archivo ajeno. En una instalación nueva como esta:

```bash
sudo install -m 644 config/docker/daemon.json /etc/docker/daemon.json
sudo dockerd --validate --config-file=/etc/docker/daemon.json
sudo systemctl restart docker
sudo docker compose --parallel 1 pull --quiet
```

Registrar la incidencia y su recuperación por separado de T03. Solo un resultado repetido de persistencia y arranque permite cerrar la prueba; una descarga terminada no basta.
