# Arquitectura del proyecto

Se continúa la infraestructura de Axel: Ubuntu, DHCP y BIND9. Daniel incorpora los dos contenedores y Apache con TLS. Los resultados se registran en [pruebas](08-pruebas-y-resultados.md). FTP, Cron, copia externa y personalización del sitio siguen planificados. El [diagrama fuente](diagramas/infraestructura.mmd) muestra el objetivo completo; el [inventario](inventario.md) distingue lo observado de lo pendiente.

## Capas

| Capa | Componentes | Responsabilidad |
|---|---|---|
| Cliente | Mint | Consultar DNS, navegar HTTPS y probar FTP/roles. |
| Host servidor | Ubuntu, BIND9, Apache, vsftpd, Cron | Resolver el dominio, terminar TLS, aislar archivos y programar respaldo. |
| Docker | WordPress y MariaDB | Ejecutar la plataforma y su base con versiones explícitas. |
| Datos | Dos volúmenes con nombre | Conservar archivos WordPress y datos MariaDB. |
| Recuperación | SQL, archivos y configuración protegidos | Recuperar el sitio y mantener copia fuera de la VM. |

## Valores observados

Dominio `cooperativa.internal`; Ubuntu `192.168.50.1`; Mint `192.168.50.100` por DHCP; backend `127.0.0.1:8082`. Mantener consistentes el dominio y puerto en DNS, certificado, Apache y WordPress. La IP del cliente puede renovarse dentro del rango DHCP de Axel.

Dos adaptadores en Ubuntu: NAT para descargas y red interna para Mint. Mint conserva su NAT independiente para Internet y recibe el DNS interno por DHCP. Los reenvíos SSH se limitan al loopback del host Windows. Cada equipo físico tendrá su propia pareja de VMs: redes internas VirtualBox de distintos hosts no se conectan automáticamente.

## Aislamiento

Apache recibe 80/443 y redirige HTTP a HTTPS. El contenedor WordPress solo publica su puerto en localhost. La BD no publica puertos al host y WordPress la busca como `bd:3306`. La red `aplicacion` es un bridge de Docker; no se declara `internal: true` para permitir descargas controladas de WordPress. No confundirla con la red interna de VirtualBox.

FTP usará directorios propios, separados del núcleo y la configuración de WordPress. La BD nativa o configuraciones del laboratorio anterior no forman parte de esta VM nueva.

## Persistencia y versiones

`datos_bd` conserva `/var/lib/mysql`; `archivos_wordpress` conserva `/var/www/html`. Los volúmenes no son respaldos. Registrar tags, digests y versiones reales de WordPress, PHP, MariaDB, tema y plugin. Controlar actualizaciones: una imagen etiquetada y un volumen persistente pueden contener versiones del núcleo distintas después de actualizar desde el panel.

La imagen oficial gestiona el protocolo reenviado si Apache establece `X-Forwarded-Proto` adecuadamente. Verificar HTTPS, URL del sitio, inicio de sesión, imágenes y enlaces. Certificado propio con SAN del dominio y CA local confiada en Mint; claves privadas fuera de Git.

## Decisiones por cerrar

- Plan de puertos FTP pasivos y acceso permitido en firewall.
- Destino externo de respaldo y mecanismo de copia.
- Revisión humana de C02/C03 y reproducción independiente del conjunto.
- Confirmar el comportamiento de las VMs en el equipo del siguiente integrante; registrar el ajuste de CPU de las copias de Daniel.
