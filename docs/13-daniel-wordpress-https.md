# Daniel Contenedores WordPress MariaDB y HTTPS

Responsable: Daniel (`Dani-develop`). Revisor humano previsto: Frander (`FranderCT`). Rama: `feature/c02-c03-wordpress-daniel`, creada desde `feature/c01-dns-axel` en `c265221`.

## Alcance y estado

Se continúa la pareja de VMs exportada por Axel en `ova.zip`. El trabajo comprende C02/T02, C03/T03 y la documentación de su integración. C06 continúa pendiente hasta una reproducción independiente. No incluye personalización, cinco contenidos, plugin, roles, FTP ni respaldo con Cron.

El procedimiento continúa las VMs de Axel, importadas como `cooperativa-server-daniel` y `cooperativa-mint-daniel`. Los nombres internos siguen siendo `cooperativa-server` y `cooperativa-mint`. Consultar los resultados efectivos en [pruebas y resultados](08-pruebas-y-resultados.md); la revisión de Frander y la reproducción independiente se registran por separado.

## Flujo de trabajo

1. Partir de la configuración de Axel y conservar BIND9, DHCP y su red interna.
2. Mantener las fuentes en `compose.yaml` y `config/`, y el procedimiento en este documento y la guía general.
3. Aplicar en Ubuntu, validar desde Mint y registrar tanto resultados positivos como denegaciones.
4. Añadir evidencias reales y el commit exacto de configuración bajo prueba.
5. Actualizar la matriz, el inventario y el índice de evidencias según lo observado.
6. Subir la rama y dejar la revisión de Frander pendiente; no integrar a `main` ni presentar una revisión automática como humana.

## Valores de esta instalación

| Elemento | Punto de partida |
|---|---|
| Red interna | `cooperativa-net` |
| Ubuntu | `cooperativa-server`, `192.168.50.1/24`, NAT + red interna |
| Mint | `cooperativa-mint`, `192.168.50.100/24` por DHCP, DNS `192.168.50.1` |
| Administración heredada | Usuario `axel`; credenciales fuera de Git |
| SSH del host Windows | `127.0.0.1:2224` servidor; `127.0.0.1:2225` cliente |
| Dominio | `cooperativa.internal` y alias `www.cooperativa.internal` |
| Backend | `127.0.0.1:8082:80` |
| Despliegue | `/srv/cooperativa` en Ubuntu |

Las versiones y recursos observados están en el [inventario](inventario.md). Las IP de los contenedores no se fijan: WordPress encuentra MariaDB por el servicio `bd`.

## Preparación del host Windows

El archivo suministrado contiene un OVA con **dos sistemas**, Mint y Ubuntu. Deben importarse ambos y conservarse sus adaptadores y direcciones MAC: Netplan del servidor identifica la interfaz NAT por MAC. No importar sobre las VMs de los laboratorios ni editar el ZIP original.

Antes de importar: comprobar espacio libre, que `2224` y `2225` no estén ocupados y que no exista otra pareja encendida con `192.168.50.1` en `cooperativa-net`. La reserva de espacio debe incluir extracción, discos dinámicos, imágenes Docker y crecimiento. La OVA final será exportada por Daniel cuando termine el traspaso, según lo solicitado.

Ejemplo en PowerShell, una vez extraído el OVA del ZIP original:

```powershell
& 'C:\Program Files\Oracle\VirtualBox\VBoxManage.exe' import 'RUTA\Cooperativa-Agricola-Nicoya.ova' --options keepallmacs,importtovdi --vsys 0 --vmname cooperativa-mint-daniel --basefolder 'RUTA\VMs-Daniel' --vsys 1 --vmname cooperativa-server-daniel --basefolder 'RUTA\VMs-Daniel'
```

Revisar `showvminfo` antes de arrancar. Conservar 4096 MB por VM y las MAC originales. Se autorizó probar 1 CPU en la copia del servidor ante bloqueos del kernel; la OVA de Axel conserva 2 CPU. Este ajuste es del entorno virtual y no cambia BIND9/DHCP/Netplan. Ver la incidencia y el estado final en [operación](07-operacion-y-diagnostico.md).

## Preparación de Ubuntu

### 1. Comprobar lo heredado

Terminal Ubuntu:

```bash
hostname
cat /etc/os-release
uname -r
ip -4 -br address
ip route
sudo ss -lntup
df -h
sudo named-checkconf
sudo named-checkzone cooperativa.internal /etc/bind/db.cooperativa.internal
dig @192.168.50.1 cooperativa.internal A +short
sudo sha256sum /etc/bind/named.conf.options /etc/bind/named.conf.local /etc/bind/db.cooperativa.internal /etc/netplan/00-installer-config.yaml /etc/dhcp/dhcpd.conf /etc/default/isc-dhcp-server
```

Guardar los hashes como línea base y compararlos al terminar. El resultado esperado es zona válida, serial `2026102201`, dirección `192.168.50.1` y puertos 80/443/8082 disponibles antes de instalar Apache. No cambiar el DNS de Ubuntu para compensar un error del cliente.

### 2. Instalar herramientas y Docker

Se utilizó Ubuntu 26.04 `resolute` y el repositorio oficial de Docker. Los comandos siguientes son Bash en Ubuntu, como administrador (`sudo -i`). No ejecutarlos en Windows ni repetirlos sobre una instalación ajena sin inspeccionarla.

```bash
apt-get update
apt-get install -y --no-upgrade ca-certificates curl git openssl apache2
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc
. /etc/os-release
arquitectura=$(dpkg --print-architecture)
suite=${UBUNTU_CODENAME:-$VERSION_CODENAME}
cat > /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $suite
Components: stable
Architectures: $arquitectura
Signed-By: /etc/apt/keyrings/docker.asc
EOF
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
systemctl enable --now docker apache2
docker version --format '{{.Server.Version}}'
docker compose version
apache2 -v
```

No se ejecutó una actualización general de los paquetes de Axel ni se añadió su usuario al grupo Docker. La administración de Docker usa `sudo`; pertenecer a ese grupo concede amplios privilegios sobre el servidor.

### 3. Clonar la rama y crear secretos locales

En la misma sesión root, solo para un destino nuevo:

```bash
test ! -e /srv/cooperativa
install -d -o axel -g axel -m 700 /srv/cooperativa
sudo -u axel git clone --branch feature/c02-c03-wordpress-daniel https://github.com/Dani-develop/Cooperativa-Agr-cola-Nicoya.git /srv/cooperativa
cd /srv/cooperativa
umask 077
python3 - <<'PY'
from pathlib import Path
import secrets
assert not Path('.env').exists(), 'No reemplazar un .env existente'
text = Path('.env.example').read_text()
for name in ('DB_ROOT_PASSWORD', 'DB_PASSWORD'):
    text = text.replace(name + '=\n', name + '=' + secrets.token_hex(24) + '\n')
Path('.env').write_text(text)
Path('.env').chmod(0o600)
PY
chown axel:axel .env
docker compose config --quiet
```

El directorio de despliegue tendrá modo 700 y `.env` modo 600. Conservar el contenido administrativo y credenciales fuera de las capturas. No usar la cuenta root de MariaDB en WordPress.

`700` permite al propietario leer, escribir y entrar en la carpeta; impide el acceso a otros usuarios ordinarios. `600` permite al propietario leer y escribir el archivo, sin permisos para grupo/otros. Root puede administrarlos. Son permisos de acceso, no cifrado; `.gitignore` impide añadirlos por accidente pero no revoca una publicación previa.

### 4. Descargar y arrancar los dos servicios

Apagar Mint mientras se preparan imágenes para reducir carga. En Ubuntu root, dentro de `/srv/cooperativa`:

```bash
# Solo si /etc/docker/daemon.json no tiene configuración previa ajena.
install -m 644 config/docker/daemon.json /etc/docker/daemon.json
dockerd --validate --config-file=/etc/docker/daemon.json
systemctl restart docker
docker compose --parallel 1 pull --quiet
docker compose up -d --wait --wait-timeout 240
docker compose ps
docker compose images
```

Esperado: `bd` y `wordpress` saludables. La base inicializa `cooperativa_wp` y su usuario privado; WordPress crea su propio esquema al instalarse. No requiere `init.sql` ni tablas de estudiantes de los laboratorios. `up --build` no cambia este despliegue: se usan imágenes oficiales fijadas por digest, sin Dockerfile local.

Para diagnosticar: `docker compose logs --tail 50 bd wordpress`. Una imagen dañada se corrige de forma dirigida; no eliminar los volúmenes para arreglar un ejecutable o un puerto ocupado.

## TLS y Apache

Fuentes: [`config/tls/`](../config/tls/README.md), [`config/apache/cooperativa.conf`](../config/apache/cooperativa.conf). La CA y las claves se generan en Ubuntu con `sudo bash scripts/preparar-tls.sh`. Antes de activar el sitio se comprueba la sintaxis con `sudo apache2ctl configtest`.

### 5. Emitir el certificado y activar el proxy

En Ubuntu root:

```bash
cd /srv/cooperativa
bash scripts/preparar-tls.sh
install -m 644 config/apache/cooperativa.conf /etc/apache2/sites-available/cooperativa.conf
a2enmod ssl proxy proxy_http headers
a2ensite cooperativa.conf
apache2ctl configtest
systemctl reload apache2
openssl x509 -in /etc/ssl/certs/cooperativa-nicoya.crt -noout -subject -issuer -dates -ext subjectAltName
openssl x509 -in /usr/local/share/ca-certificates/cooperativa-nicoya-ca.crt -noout -fingerprint -sha256
```

El script se niega a reemplazar material TLS existente. Conservar la CA en las VMs de continuidad. Solo una reproducción nueva genera otra CA. Las claves privadas tienen modo 600 y permanecen en `/etc/ssl/private/cooperativa`; la CA pública tiene 644 y puede copiarse al cliente. Si UFW ya está activo, permitir TCP 80/443 desde `192.168.50.0/24`; no habilitarlo ni abrir MariaDB sin revisar su política previa.

### 6. Inicializar WordPress una sola vez

En Ubuntu root, generar la cuenta técnica sin imprimir su contraseña:

```bash
cd /srv/cooperativa
install -d -o root -g root -m 700 credenciales
python3 - <<'PY'
from pathlib import Path
import secrets
p = Path('credenciales/admin.env')
assert not p.exists(), 'No reemplazar credenciales existentes'
p.write_text('WP_BOOT_ADMIN_USER=daniel_admin\nWP_BOOT_ADMIN_EMAIL=admin@cooperativa.internal\nWP_BOOT_ADMIN_PASSWORD=' + secrets.token_hex(24) + '\n')
p.chmod(0o600)
PY
set -a
. credenciales/admin.env
set +a
bash scripts/bootstrap-wordpress.sh
unset WP_BOOT_ADMIN_PASSWORD
```

Se crea el título técnico del sitio, URL HTTPS, zona horaria Costa Rica, enlaces permanentes y un administrador. El correo interno es de laboratorio, sin servicio SMTP configurado. Un aviso de envío de correo no demuestra un fallo de la instalación; comprobar el sitio y la autenticación. Si WordPress ya existe, el script debe detenerse y conservar usuarios/datos.

### 7. Confiar la CA en Mint

Arrancar Mint. Copiar **solo** `cooperativa-nicoya-ca.crt` desde Ubuntu, por SSH/SFTP mediante los puertos de administración del host. Copiar también [policies.json](../config/firefox/policies.json) a Mint. Comparar la huella SHA-256 de la CA en ambos extremos antes de confiarla.

Con OpenSSH disponible en Windows, desde la raíz de la copia del repositorio, PowerShell:

```powershell
scp -P 2224 axel@127.0.0.1:/usr/local/share/ca-certificates/cooperativa-nicoya-ca.crt "$env:TEMP\cooperativa-nicoya-ca.crt"
scp -P 2225 "$env:TEMP\cooperativa-nicoya-ca.crt" axel@127.0.0.1:/home/axel/cooperativa-nicoya-ca.crt
scp -P 2225 config/firefox/policies.json axel@127.0.0.1:/home/axel/cooperativa-policies.json
```

Confirmar las claves de host SSH de las VMs importadas; no deshabilitar la verificación. Introducir la contraseña administrativa de la VM cuando se solicite, sin guardarla en el comando. Luego, en Mint:

```bash
openssl x509 -in /home/axel/cooperativa-nicoya-ca.crt -noout -fingerprint -sha256
sudo install -m 644 /home/axel/cooperativa-nicoya-ca.crt /usr/local/share/ca-certificates/cooperativa-nicoya-ca.crt
sudo update-ca-certificates
# Integrar con políticas anteriores si existen; en esta VM no había este archivo.
sudo install -d -m 755 /etc/firefox/policies
sudo install -m 644 /home/axel/cooperativa-policies.json /etc/firefox/policies/policies.json
```

Cerrar y abrir Firefox. La política `Certificates.Install` apunta al certificado público local; comprobar `about:policies`. No instalar la clave de la CA en Mint y no aceptar una excepción de certificado como prueba de confianza.

El cliente instalará solo la CA pública, comprobará la huella recibida e importará su confianza también en Firefox. T02 debe navegar por el nombre normal, sin `curl -k`, sin `--resolve` y sin `/etc/hosts`. Las comprobaciones deben incluir HTTP hacia HTTPS, SAN, vigencia, cadena confiable, login al panel y bloqueo del acceso directo a `192.168.50.1:8082` desde Mint.

## WordPress y persistencia

Fuente: [`compose.yaml`](../compose.yaml). Se validó con `docker compose config -q`, descarga de versiones verificadas y `docker compose up -d --wait`. Se registraron Engine/Compose, estados, digests y versiones reales del núcleo/PHP/BD en T03. Solo se instaló la cuenta técnica administradora; las cuentas editoriales corresponden a Arii.

### 8. Ejecutar T02 desde Mint

Copiar o clonar esta rama en Mint y ejecutar:

```bash
bash pruebas/t02-desde-mint.sh
```

El script comprueba DNS normal, 301 a HTTPS, sitio y formulario 200, panel sin sesión 302, cadena/nombre válidos, puertos directos 8082/3306 inaccesibles y archivos administrativos 403. Después iniciar sesión en Firefox con la cuenta técnica y comprobar el escritorio. La prueba automatizada de acceso anónimo no sustituye ese inicio de sesión.

### 9. Ejecutar T03 en Ubuntu

Terminal root en `/srv/cooperativa`, con el sitio ya instalado:

```bash
docker compose exec -T --user www-data wordpress php /dev/stdin crear < pruebas/c03-persistencia.php > .t03-estado.json
cat .t03-estado.json
export COOP_T03_STATE="$(cat .t03-estado.json)"
docker compose ps -q
docker volume ls --filter label=com.docker.compose.project=cooperativa-nicoya
docker compose up -d --force-recreate --wait --wait-timeout 240
docker compose ps -q
docker compose exec -T --user www-data --env COOP_T03_STATE wordpress php /dev/stdin verificar < pruebas/c03-persistencia.php
```

Antes y después consultar desde Mint la URL de la entrada y de la imagen que devuelve el JSON. Comparar identificadores, contenido y SHA-256 del PNG descargado. Deben cambiar los IDs de los contenedores y conservarse los volúmenes, entrada e imagen. El JSON es estado técnico, está excluido de Git y no contiene credenciales. No repetir `crear` sin necesidad: genera otra entrada/adjunto.

Copiar el JSON a Mint mediante SFTP y ejecutar allí, desde una copia del repositorio:

```bash
python3 pruebas/t03-desde-mint.py /home/axel/t03-estado.json
```

El script comprueba el título y el enlace a la imagen, descarga el PNG por HTTPS con la CA del sistema y compara sus bytes con el SHA-256 del JSON. Repetirlo después de recrear y después de reiniciar, mientras la entrada todavía está publicada.

Después de capturar la evidencia, dejar la entrada técnica en borrador:

```bash
docker compose exec -T --user www-data --env COOP_T03_STATE wordpress php /dev/stdin borrador < pruebas/c03-persistencia.php
unset COOP_T03_STATE
```

Reiniciar Ubuntu de forma ordenada y repetir T02 y la lectura de T03. Es una verificación de las capas de Daniel y del DNS heredado; T13 integral sigue pendiente de FTP/Cron y del respaldo del siguiente integrante.

T03 creará objetos técnicos identificables, comparará sus datos/hash y recreará los servicios **sin eliminar volúmenes**. Los objetos de prueba no se cuentan como contenido agrícola E03. La prueba de reinicio de la VM deberá volver a verificar DNS, HTTPS y ambos servicios; no cerrará la aceptación de FTP/Cron todavía no implementados.

## Operación y reversión

- Cambios en `.env` no alteran automáticamente las credenciales de una BD inicializada. No resolver errores borrando el volumen.
- Apache puede volver a su sitio/configuración anterior usando la copia previa y `configtest` antes de recargar; los archivos de BIND9 no se modifican.
- Para detener solo esta aplicación: `docker compose stop`, dentro de `/srv/cooperativa`.
- Para recrear: `docker compose up -d --force-recreate --wait`, conservando los volúmenes.
- No ejecutar `down -v`, `docker system prune --volumes` ni eliminar discos para corregir un error de puerto o TLS.
- El traspaso incluirá rutas de claves y credenciales comunicadas en privado, sin publicarlas en la rama ni incluirlas en evidencias.

## Cierre y traspaso

Registrar los resultados reales en T02/T03, mantener pendiente la revisión de Frander y sincronizar esta rama. Antes de exportar, cerrar las dos VMs con `sudo poweroff`; no exportarlas con el sistema arrancado o con estado guardado. Exportar ambas juntas para el siguiente integrante y conservar la red interna y las MAC.

Resultados de esta ejecución: [T02](../pruebas/registros/T02-C02-2026-10-24.md), [T03](../pruebas/registros/T03-C03-2026-10-24.md). Se comprobaron recreación y reinicio; el objeto técnico quedó en borrador y se invalidaron las sesiones de login utilizadas en la prueba. La revisión humana y el trabajo de los siguientes integrantes permanecen pendientes.

La OVA de continuidad **contiene secretos** del laboratorio: claves TLS, `.env`, BD y cuenta técnica. Compartirla privadamente con el equipo; no adjuntarla a GitHub. En Ubuntu, el administrador consulta `sudo less /srv/cooperativa/credenciales/admin.env` sin grabar ni capturar la pantalla. El siguiente integrante debe recibir esa ubicación por un canal privado, arrancar ambas VMs, probar `https://cooperativa.internal` y continuar su área; no volver a ejecutar la inicialización ni borrar volúmenes.
