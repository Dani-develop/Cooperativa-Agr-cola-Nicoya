# Reproducción desde cero

Estado: pendiente. C06/T06. Un integrante distinto de quien construyó el entorno seguirá la guía en otra computadora con una pareja de VMs propia.

La [guía de Daniel](13-daniel-wordpress-https.md) ya detalla Docker, Apache/TLS, inicialización y pruebas; el punto de partida de su ejecución fue la OVA de Axel. Importar y continuar esa OVA no acredita una instalación limpia. Las capas de FTP, respaldo y personalización deberán completar sus procedimientos antes de aceptar T06 integral.

## Prerrequisitos a fijar

VirtualBox, versión de Ubuntu y Mint, recursos mínimos medidos, acceso a imágenes/paquetes, Git, credenciales privadas nuevas y recursos del contenido. No utilizar una VM ya configurada como prueba de reproducción.

## Recorrido

1. Registrar equipo y punto de partida limpio.
2. Obtener el repositorio y anotar commit exacto.
3. Seguir [instalación](03-guia-instalacion.md) desde VM/red hasta sitio completo.
4. Generar secretos propios fuera de Git y emitir certificado local.
5. Reconstruir contenido/configuración desde las fuentes o usar un respaldo privado autorizado, indicando cuál método se probó.
6. Ejecutar T01-T13 aplicables y enlazar evidencias.
7. Registrar pasos omitidos, tiempo y ayuda que fue necesaria.
8. Corregir la guía y repetir los pasos que fallaron.

Una imagen/OVA de contingencia no prueba que la guía reproduzca la instalación. Compose solo reconstruye los contenedores: los servicios del host también deben tener instrucciones y archivos.

## Acta

| Campo | Valor observado |
|---|---|
| Integrante y fecha | Pendiente |
| Equipo y VMs | Pendiente |
| Commit reproducido | Pendiente |
| Duración | Pendiente |
| Ayuda externa requerida | Pendiente |
| Pruebas aprobadas/fallidas | Pendiente |
| Correcciones incorporadas | Pendiente |
