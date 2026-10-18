# FTP y permisos

Estado: pendiente. C04/T04 exige aislamiento efectivo, no solo cinco inicios de sesión.

## Diseño

Usar vsftpd en Ubuntu con FTP sobre TLS, una cuenta por integrante y directorios privados bajo una ruta acordada en el inventario. La raíz del chroot tendrá propietario/permisos apropiados y una subcarpeta de trabajo escribible por su usuario; no resolver errores con permisos globales `777`.

Los cinco usuarios podrán manejar lo propio y no modificar ni borrar lo ajeno. No tendrán escritura en núcleo, plugins, configuración o respaldos de WordPress. Las cuentas FTP y las cuentas del CMS son independientes. SFTP por sí solo no demuestra el servidor FTP exigido.

## Pendiente implementar y registrar

- Paquete/versión y archivo de configuración efectivo.
- Usuarios, propietario/grupo y permisos; sin contraseñas en Git.
- Chroot, rechazo de acceso anónimo y restricciones de cuenta.
- Certificado, TLS y rango de puertos pasivos permitido en la red del laboratorio.
- Cliente compatible en Mint y comprobación de cifrado.
- Procedimiento de entrega de medios: revisión y publicación desde WordPress.

## Prueba de aislamiento

Con A: subir, leer, modificar y borrar su archivo. Con B: crear un archivo propio. Con A: intentar acceder por ruta directa al de B y modificarlo/borrarlo; debe denegarse y conservarse el original. Repetir con otra pareja. Guardar respuesta del servidor y permisos reales. No basta con que la carpeta no aparezca listada.

Las configuraciones fuente se desarrollarán en [config/vsftpd](../config/vsftpd/README.md).
