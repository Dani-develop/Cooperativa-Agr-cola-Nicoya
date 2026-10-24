# Daniel Contenedores WordPress MariaDB y HTTPS

Responsable: Daniel (`Dani-develop`). Revisor humano previsto: Frander (`FranderCT`). Rama: `feature/c02-c03-wordpress-daniel`, creada desde `feature/c01-dns-axel` en `c265221`.

## Alcance y estado

Se continúa la pareja de VMs exportada por Axel en `ova.zip`. El trabajo comprende C02/T02, C03/T03 y la documentación de su integración. C06 continúa pendiente hasta una reproducción independiente. No incluye personalización, cinco contenidos, plugin, roles, FTP ni respaldo con Cron.

**Estado inicial: preparación local; importación y pruebas de las VMs pendientes.** No se considera probado lo que solo existe como configuración. Los resultados reales se incorporarán a `pruebas/registros/`, `evidencias/https/` y `evidencias/docker/`.

## Flujo de trabajo

1. Partir de la configuración de Axel y conservar BIND9, DHCP y su red interna.
2. Mantener las fuentes en `compose.yaml` y `config/`, y el procedimiento en este documento y la guía general.
3. Aplicar en Ubuntu, validar desde Mint y registrar tanto resultados positivos como denegaciones.
4. Añadir evidencias reales y el commit exacto de configuración bajo prueba.
5. Actualizar la matriz, el inventario y el índice de evidencias según lo observado.
6. Subir la rama y dejar la revisión de Frander pendiente; no integrar a `main` ni presentar una revisión automática como humana.

## Valores heredados y valores por observar

| Elemento | Punto de partida |
|---|---|
| Red interna | `cooperativa-net` |
| Ubuntu | `cooperativa-server`, `192.168.50.1/24`, NAT + red interna |
| Mint | `cooperativa-mint`, DHCP en red interna, DNS `192.168.50.1` |
| Administración heredada | Usuario `axel`; credenciales fuera de Git |
| SSH del host Windows | `127.0.0.1:2224` servidor; `127.0.0.1:2225` cliente |
| Dominio | `cooperativa.internal` y alias `www.cooperativa.internal` |
| Backend propuesto | `127.0.0.1:8082:80` |
| Despliegue propuesto | `/srv/cooperativa` en Ubuntu |

Las versiones, recursos y direcciones del cliente se volverán a comprobar después de importar. No asumir que el inventario de Axel acredita el estado de las VMs importadas.

## Preparación del host Windows

El archivo suministrado contiene un OVA con **dos sistemas**, Mint y Ubuntu. Deben importarse ambos y conservarse sus adaptadores y direcciones MAC: Netplan del servidor identifica la interfaz NAT por MAC. No importar sobre las VMs de los laboratorios ni editar el ZIP original.

Antes de importar: comprobar espacio libre, que `2224` y `2225` no estén ocupados y que no exista otra pareja encendida con `192.168.50.1` en `cooperativa-net`. La reserva de espacio debe incluir extracción, discos dinámicos, imágenes Docker y crecimiento. La OVA final será exportada por Daniel cuando termine el traspaso, según lo solicitado.

## Preparación de Ubuntu

Pendiente de completar con el procedimiento exacto aplicado y las versiones observadas. Se instalarán Docker Engine y Compose según su repositorio oficial para la versión real de Ubuntu, junto con Apache y OpenSSL. Antes: `hostname`, `cat /etc/os-release`, `ip -4 -br address`, `ip route`, `sudo ss -lntup`, `df -h`, `sudo named-checkconf` y `dig cooperativa.internal A`.

El directorio de despliegue tendrá modo 700 y `.env` modo 600. Conservar el contenido administrativo y credenciales fuera de las capturas. No usar la cuenta root de MariaDB en WordPress.

## TLS y Apache

Fuentes: [`config/tls/`](../config/tls/README.md), [`config/apache/cooperativa.conf`](../config/apache/cooperativa.conf). La CA y las claves se generan en Ubuntu con `sudo bash scripts/preparar-tls.sh`. Antes de activar el sitio se comprueba la sintaxis con `sudo apache2ctl configtest`.

El cliente instalará solo la CA pública, comprobará la huella recibida e importará su confianza también en Firefox. T02 debe navegar por el nombre normal, sin `curl -k`, sin `--resolve` y sin `/etc/hosts`. Las comprobaciones deben incluir HTTP hacia HTTPS, SAN, vigencia, cadena confiable, login al panel y bloqueo del acceso directo a `192.168.50.1:8082` desde Mint.

## WordPress y persistencia

Fuente: [`compose.yaml`](../compose.yaml). Inicio previsto: `docker compose config -q`, descarga de versiones verificadas y `docker compose up -d --wait`. Registrar `docker version`, `docker compose version`, estado, tags, digests y versiones reales del núcleo/PHP/BD. Instalar únicamente una cuenta técnica administradora; las cuentas editoriales corresponden a Arii.

T03 creará objetos técnicos identificables, comparará sus datos/hash y recreará los servicios **sin eliminar volúmenes**. Los objetos de prueba no se cuentan como contenido agrícola E03. La prueba de reinicio de la VM deberá volver a verificar DNS, HTTPS y ambos servicios; no cerrará la aceptación de FTP/Cron todavía no implementados.

## Operación y reversión

- Cambios en `.env` no alteran automáticamente las credenciales de una BD inicializada. No resolver errores borrando el volumen.
- Apache puede volver a su sitio/configuración anterior usando la copia previa y `configtest` antes de recargar; los archivos de BIND9 no se modifican.
- Para detener solo esta aplicación: `docker compose stop`, dentro de `/srv/cooperativa`.
- Para recrear: `docker compose up -d --force-recreate --wait`, conservando los volúmenes.
- No ejecutar `down -v`, `docker system prune --volumes` ni eliminar discos para corregir un error de puerto o TLS.
- El traspaso incluirá rutas de claves y credenciales comunicadas en privado, sin publicarlas en la rama ni incluirlas en evidencias.

## Pendientes de ejecución

- [ ] Importar y arrancar la pareja de VMs sin conflictos.
- [ ] Verificar que C01 se conserva y registrar el inventario real.
- [ ] Aplicar y verificar C02/T02.
- [ ] Aplicar y verificar C03/T03 y recuperación tras reinicio.
- [ ] Completar comandos exactos, resultados y evidencias de este documento.
- [ ] Subir la rama y dejar las VMs apagadas limpiamente para el traspaso.
- [ ] Revisión de Frander, sin atribuirle una aprobación todavía no emitida.
