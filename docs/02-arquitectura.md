# Arquitectura propuesta

Estado: diseño inicial, sin despliegue verificado. Ver [diagrama fuente](diagramas/infraestructura.mmd) y [inventario](inventario.md).

## Capas

| Capa | Componentes | Responsabilidad |
|---|---|---|
| Cliente | Mint | Consultar DNS, navegar HTTPS y probar FTP/roles. |
| Host servidor | Ubuntu, BIND9, Apache, vsftpd, Cron | Resolver el dominio, terminar TLS, aislar archivos y programar respaldo. |
| Docker | WordPress y MariaDB | Ejecutar la plataforma y su base con versiones explícitas. |
| Datos | Dos volúmenes con nombre | Conservar archivos WordPress y datos MariaDB. |
| Recuperación | SQL, archivos y configuración protegidos | Recuperar el sitio y mantener copia fuera de la VM. |

## Valores propuestos

Dominio `cooperativa.internal`; Ubuntu `192.168.50.1`; Mint `192.168.50.2`; backend `127.0.0.1:8082`. Confirmar red, interfaces y puerto antes de implementarlos. Mantenerlos consistentes en DNS, certificado, Apache y WordPress.

Dos adaptadores en Ubuntu: NAT para descargas y red interna para Mint. El acceso a Internet de Mint y el reenvío se decidirán y documentarán en el inventario. Cada equipo físico tendrá su propia pareja de VMs: redes internas VirtualBox de distintos hosts no se conectan automáticamente.

## Aislamiento

Apache recibe 80/443 y redirige HTTP a HTTPS. El contenedor WordPress solo publica su puerto en localhost. La BD no publica puertos al host y WordPress la busca como `bd:3306`. La red `aplicacion` es un bridge de Docker; no se declara `internal: true` para permitir descargas controladas de WordPress. No confundirla con la red interna de VirtualBox.

FTP usará directorios propios, separados del núcleo y la configuración de WordPress. La BD nativa o configuraciones del laboratorio anterior no forman parte de esta VM nueva.

## Persistencia y versiones

`datos_bd` conserva `/var/lib/mysql`; `archivos_wordpress` conserva `/var/www/html`. Los volúmenes no son respaldos. Registrar tags, digests y versiones reales de WordPress, PHP, MariaDB, tema y plugin. Controlar actualizaciones: una imagen etiquetada y un volumen persistente pueden contener versiones del núcleo distintas después de actualizar desde el panel.

La imagen oficial gestiona el protocolo reenviado si Apache establece `X-Forwarded-Proto` adecuadamente. Verificar HTTPS, URL del sitio, inicio de sesión, imágenes y enlaces. Certificado propio con SAN del dominio y CA local confiada en Mint; claves privadas fuera de Git.

## Decisiones por cerrar

- Versión exacta de Ubuntu y recursos suficientes para las dos VMs.
- Plan de puertos FTP pasivos y acceso permitido en firewall.
- Emisión/confianza del certificado y restricciones de los servicios.
- Destino externo de respaldo y mecanismo de copia.
- Tags/digests efectivos tras comprobar las imágenes candidatas.
