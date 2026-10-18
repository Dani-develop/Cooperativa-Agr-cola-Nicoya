# Contexto y alcance

## Problema del escenario

La Cooperativa Agrícola Nicoya coordina por WhatsApp y hojas de cálculo, no tiene sitio web ni un medio organizado para publicar información entre oficinas y ya sufrió pérdida de información por una avería. Su presupuesto para licencias es casi nulo.

## Resultado propuesto

Portal WordPress con identidad propia y contenido agrícola, publicación por Editor y Autores de campo, bandejas FTP privadas y respaldos automáticos cuya restauración esté comprobada. El repositorio explicará el diseño, la construcción y la operación.

## Alcance obligatorio

Zona BIND9, VirtualHost HTTPS sobre WordPress contenerizado, BD en otro contenedor, persistencia y versiones fijas, FTP aislado, Cron y restauración. Además: logo y colores, cuatro secciones de menú, cinco piezas de contenido genuino, plugin útil, dos roles y justificación del software libre. Ver la [matriz](01-requisitos.md).

## Mejoras propuestas

FTP con TLS, confianza TLS instalada en Mint, archivos de WordPress incluidos en el respaldo, copia fuera de la VM, prueba de reproducción por otro integrante y ensayo de reinicio. Son decisiones del grupo, no requisitos específicos adicionales atribuidos al profesor.

La alta disponibilidad queda fuera del alcance inicial y se evaluará después de cerrar los obligatorios. La guía recibida no exige contratar nube ni comprar dominio. Aclarar con el profesor si espera acceso público y cuánto durará la demo.

## Reutilización de conocimientos

Los laboratorios verificaron Docker, Compose, volúmenes y Apache delante de un contenedor. No prueban la futura zona DNS, los roles WordPress, el aislamiento FTP ni la restauración del proyecto. Se conservarán y se construirá una VM dedicada con inventario propio.

## Entrega

Fecha indicada: 07/11/2026. Cinco integrantes. Infraestructura, documento técnico y presentación; el programa indica entrega formal mediante Aula Virtual. GitHub apoya la documentación, no sustituye ese canal.
