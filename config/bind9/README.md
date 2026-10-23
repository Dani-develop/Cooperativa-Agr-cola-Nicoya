# BIND9 — C01 / T01

**Estado:** completado y validado.  
**Dominio:** `cooperativa.internal`.  
**Servidor DNS:** `192.168.50.1`.  
**Cliente de prueba:** `cooperativa-mint`.

## Archivos de configuración

- [`named.conf.local`](named.conf.local): declaración de la zona maestra `cooperativa.internal`.
- [`named.conf.options`](named.conf.options): configuración de escucha, ACL, recursión y forwarders.
- [`db.cooperativa.internal`](db.cooperativa.internal): archivo de zona con registros SOA, NS y A.

Los archivos fueron aplicados en el servidor en las siguientes rutas:

```text
/etc/bind/named.conf.local
/etc/bind/named.conf.options
/etc/bind/db.cooperativa.internal
```

## Configuración de red

BIND9 escucha en:

```text
127.0.0.1
192.168.50.1
```

Las consultas y la recursión están permitidas únicamente para:

```text
127.0.0.1
192.168.50.0/24
```

Se configuraron como forwarders:

```text
8.8.8.8
8.8.4.4
```

## Respaldo previo

Antes de modificar los archivos existentes se realizaron copias de seguridad:

```bash
sudo cp /etc/bind/named.conf.local /etc/bind/named.conf.local.bak
sudo cp /etc/bind/named.conf.options /etc/bind/named.conf.options.bak
```

## Copiar los archivos de configuración al servidor

Desde la raíz del repositorio, los tres archivos de configuración de BIND9 pueden copiarse a `/etc/bind/` mediante:

```bash
sudo cp config/bind9/named.conf.local /etc/bind/named.conf.local
sudo cp config/bind9/named.conf.options /etc/bind/named.conf.options
sudo cp config/bind9/db.cooperativa.internal /etc/bind/db.cooperativa.internal
```

Estos comandos permiten aplicar en el servidor la configuración almacenada en el repositorio.

## Validación

Después de copiar los archivos y antes de reiniciar el servicio, se verificó la sintaxis general:

```bash
sudo named-checkconf
```

También se validó específicamente la zona:

```bash
sudo named-checkzone cooperativa.internal /etc/bind/db.cooperativa.internal
```

El resultado fue:

```text
zone cooperativa.internal/IN: loaded serial 2026102201
OK
```

Posteriormente se aplicó la configuración mediante:

```bash
sudo systemctl restart named
sudo systemctl enable named
systemctl status named --no-pager
```

El servicio quedó en estado `active (running)`.

## Pruebas

Desde el servidor se verificaron respuestas autoritativas para los registros A y SOA.

Desde Linux Mint se comprobó:

- recepción de `192.168.50.1` como DNS mediante DHCP;
- resolución de `cooperativa.internal` hacia `192.168.50.1`;
- resolución de `www.cooperativa.internal`;
- resolución del registro SOA;
- ausencia de entradas de `cooperativa.internal` en `/etc/hosts`;
- resolución externa mediante los forwarders configurados.

Las evidencias se encuentran en [`../../evidencias/dns/`](../../evidencias/dns/).

## Reversión

En caso de necesitar revertir la configuración:

```bash
sudo cp /etc/bind/named.conf.local.bak /etc/bind/named.conf.local
sudo cp /etc/bind/named.conf.options.bak /etc/bind/named.conf.options
sudo named-checkconf
sudo systemctl restart named
```

El archivo de zona `db.cooperativa.internal` puede retirarse después de eliminar primero su declaración correspondiente de `named.conf.local`.
