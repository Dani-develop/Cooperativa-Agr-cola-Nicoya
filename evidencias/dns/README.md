# Evidencias: DNS

**Estado:** completado.  
**Referencia:** C01 / T01.  
**Fecha de ejecución:** 2026-10-21.  
**Servidor:** `cooperativa-server`.  
**Cliente:** `cooperativa-mint`.  
**Dominio:** `cooperativa.internal`.

## Evidencias

- [`C01_T01_01_red-servidor-configurada.png`](C01_T01_01_red-servidor-configurada.png): configuración de la interfaz interna `192.168.50.1/24`, rutas y conectividad del servidor.
- [`C01_T01_02_dhcp-comunicacion-mint-servidor.png`](C01_T01_02_dhcp-comunicacion-mint-servidor.png): asignación DHCP `192.168.50.100/24` al cliente Mint y comunicación exitosa con `192.168.50.1`.
- [`C01_T01_03_validacion-zona-bind9.png`](C01_T01_03_validacion-zona-bind9.png): validación de la configuración mediante `named-checkconf` y `named-checkzone`, con resultado `OK`.
- [`C01_T01_04_resolucion-autoritativa-bind9.png`](C01_T01_04_resolucion-autoritativa-bind9.png): resolución autoritativa de los registros A, SOA y `www` de `cooperativa.internal` desde BIND9.
- [`C01_T01_05_resolucion-dns-desde-mint.png`](C01_T01_05_resolucion-dns-desde-mint.png): resolución normal desde Linux Mint utilizando `192.168.50.1` como DNS recibido por DHCP, sin entradas para `cooperativa.internal` en `/etc/hosts`.
- [`C01_T01_06_validacion-visual-firefox.png`](C01_T01_06_validacion-visual-firefox.png): validación visual desde Firefox en Linux Mint accediendo a `http://cooperativa.internal:8080`, confirmando que una aplicación cliente puede resolver el dominio configurado y acceder al servicio publicado en `192.168.50.1`.
