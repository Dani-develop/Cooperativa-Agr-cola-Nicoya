# Referencias

## Documentos académicos proporcionados

- Universidad Nacional, Campus Nicoya. (2026). *Proyecto de Curso EIF431O: Infraestructura de servidor para un caso real*. Páginas 1-2: requisitos comunes y escenario 1; página 4: rúbrica.
- Universidad Nacional, Campus Nicoya. (2026). *Programa EIF431O: Administración de servidores basados en software libre*. Objetivos/contenidos, disposiciones generales, cronograma y rúbrica 9.2.

Los originales se mantienen fuera del repositorio. Ajustar las referencias a los datos editoriales y APA 7 que indique el curso; no inventar autor o fecha que no consten.

## Fuentes técnicas oficiales

Consultadas al preparar el plan, 18/10/2026; volver a comprobar al fijar la implementación.

- [Requisitos WordPress](https://wordpress.org/about/requirements/).
- [Roles y capacidades](https://wordpress.org/documentation/article/roles-and-capabilities/).
- [HTTPS y proxy inverso](https://developer.wordpress.org/advanced-administration/security/https/).
- [Licencia WordPress](https://wordpress.org/about/license/).
- [Imagen oficial WordPress](https://hub.docker.com/_/wordpress).
- [Registro oficial de tags WordPress](https://github.com/docker-library/official-images/blob/master/library/wordpress).
- [Registro oficial de tags MariaDB](https://github.com/docker-library/official-images/blob/master/library/mariadb).
- [FTP y FTPS en Ubuntu](https://documentation.ubuntu.com/server/how-to/networking/ftp/index.html).
- [mariadb-dump](https://mariadb.com/docs/server/clients-and-utilities/backup-restore-and-import-clients/mariadb-dump).
- [Restauración MariaDB](https://mariadb.com/docs/server/mariadb-quickstart-guides/mariadb-restore-guide).
- [FooGallery: candidato del directorio oficial](https://wordpress.org/plugins/foogallery/).

Agregar documentación BIND9/Apache y fuentes agrícolas específicas cuando se seleccionen y se usen. Cada precio, imagen y recomendación técnica del contenido debe tener su fuente/autoría.

## Fuentes utilizadas por Daniel, 23-24/10/2026

- [Instalar Docker Engine en Ubuntu](https://docs.docker.com/engine/install/ubuntu/): repositorio oficial, clave y plugin Compose para la versión observada.
- [Apache mod_proxy](https://httpd.apache.org/docs/2.4/mod/mod_proxy.html) y [mod_ssl](https://httpd.apache.org/docs/2.4/mod/mod_ssl.html): proxy inverso y terminación TLS.
- [WordPress wp_install](https://developer.wordpress.org/reference/functions/wp_install/), [wp_upload_bits](https://developer.wordpress.org/reference/functions/wp_upload_bits/) y [wp_insert_attachment](https://developer.wordpress.org/reference/functions/wp_insert_attachment/): instalación técnica y objetos de prueba de persistencia.
- [Firefox Certificates policy](https://firefox-admin-docs.mozilla.org/reference/policies/certificates/): `Certificates.Install` con ruta completa para Linux. `ImportEnterpriseRoots` se limita a Windows/macOS; no se usa para esta VM.
- [Oracle VirtualBox 7.2: Troubleshooting](https://docs.oracle.com/en/virtualization/virtualbox/7.2/user/Troubleshooting.html): compatibilidad/rendimiento con el hipervisor de Windows. Se usa como contexto del diagnóstico, sin atribuirle una causa raíz comprobada ni cambiar la seguridad del host.

Las referencias por digest de las imágenes oficiales están en [.env.example](../.env.example); las versiones realmente ejecutadas y sus resultados se registran en T02/T03. La configuración de las versiones de 2026 debe volver a comprobarse para una instalación futura.
