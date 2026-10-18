# Trabajo del equipo

## Ciclo de una tarea

1. Identificar el requisito y el resultado observable.
2. Crear una rama corta, por ejemplo `docs/inventario` o `infra/dns`.
3. Cambiar los archivos fuente y el procedimiento en el mismo trabajo.
4. Ejecutar las pruebas apropiadas en la VM y registrar el resultado real.
5. Agregar evidencia con identificador, fecha, máquina y commit de la configuración.
6. Pedir revisión a un compañero y corregir los pasos que no pueda reproducir.

No marcar probado si solo se revisó el archivo. Distinguir `pendiente`, `implementado`, `probado`, `documentado` y `reproducido`.

## Responsabilidades iniciales por asignar

| Integrante | Área principal | Revisor |
|---|---|---|
| Por asignar 1 | Ubuntu, red y BIND9 | Por asignar 2 |
| Por asignar 2 | Compose, WordPress y HTTPS | Por asignar 3 |
| Por asignar 3 | FTP, permisos y seguridad | Por asignar 4 |
| Por asignar 4 | Contenido, identidad y licencias | Por asignar 5 |
| Por asignar 5 | Respaldo, restauración y pruebas | Por asignar 1 |

Todos deben poder operar y defender el conjunto. Las cuentas de los integrantes se añadirán cuando el grupo indique sus usuarios de GitHub.

## Documentación y archivos

- Redactar pasos con [la plantilla](docs/plantilla-paso.md), indicando Ubuntu, Mint, SQL o contenido de archivo.
- Conservar un solo archivo fuente por configuración. Referenciarlo desde la guía.
- Registrar cambios del panel WordPress: Git no captura la base de datos automáticamente.
- Revisar imágenes y salidas antes de subirlas: no incluir contraseñas, claves, hashes de acceso ni información personal innecesaria.
- No subir PDFs docentes, VMs, respaldos o recursos de terceros sin autorización/licencia de redistribución. Registrar las referencias.
- Las pruebas que eliminan datos se ejecutan en un destino aislado y explícito.

## Entregas

Usar commits descriptivos, por ejemplo `docs: registrar red real del servidor` o `test: documentar denegación FTP entre usuarios`. Antes de integrar, comprobar enlaces, comandos, diferencias de configuración y evidencia. Mantener actualizados la matriz de requisitos y el estado del README.
