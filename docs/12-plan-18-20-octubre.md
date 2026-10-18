# Propuesta de tareas iniciales: 18-20 de octubre de 2026

Estado: **por discutir y asignar**. Son los pasos iniciales de preparación, previos al despliegue. No se han ejecutado cambios en las VMs por crear este repositorio.

## 18 de octubre: acordar y registrar

- Revisar contexto, los 12 requisitos y la diferencia entre rúbricas.
- Asignar cinco responsables y revisores, con nombres y usuarios GitHub.
- Confirmar VM dedicada, dominio propuesto, recursos disponibles y equipo de reproducción.
- Completar qué se conoce y qué falta observar en el inventario.

Salida: acuerdos registrados y lista de pendientes concretos. No marcar servicios como operativos.

## 19 de octubre: preparar el entorno dedicado

- Acordar la versión de Ubuntu compatible con lo usado en el curso y registrar origen/versión.
- Crear y preparar la VM Ubuntu del proyecto y el cliente Mint sin modificar los laboratorios.
- Registrar adaptadores, interfaces e IPs reales; comprobar conectividad básica.
- Obtener una copia del repo y ejecutar el inventario de solo lectura.

Salida: entorno que arranca y red observada, con datos suficientes para diseñar DNS/puertos. Los comandos exactos de preparación se completarán y probarán juntos.

## 20 de octubre: cerrar prerrequisitos de infraestructura

- Confirmar dominio, direccionamiento, puerto backend y ruta de trabajo.
- Fijar versiones candidatas de las imágenes y el procedimiento de verificación.
- Acordar manejo privado de credenciales y destino de respaldos.
- Revisar que cada requisito tenga responsable, prueba y evidencia prevista.
- Preparar tareas de DNS, Compose y HTTPS para la siguiente fase.

Salida: inventario completo, decisiones básicas y plan de implementación revisado. Fecha objetivo de la siguiente fase: 21-24 de octubre.

## Definición de terminado de esta fase

- [ ] Cinco responsables y revisores asignados.
- [ ] Recursos y versiones del entorno registrados con observaciones reales.
- [ ] VM dedicada y Mint arrancan; red e interfaces identificadas.
- [ ] Dominio, red y puerto acordados y sin conflictos conocidos.
- [ ] Procedimientos de secretos y respaldo acordados.
- [ ] Equipo de reproducción identificado.
- [ ] Próximas tareas de C01, C02 y C03 definidas.

No hace falta instalar todo WordPress ni preparar el tema durante estos tres días. La prioridad es eliminar ambigüedades antes de cambiar servicios.
