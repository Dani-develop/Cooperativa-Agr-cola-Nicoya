# Operación y diagnóstico

C02/C03 de Daniel tienen pruebas del 24/10/2026; FTP, Cron y restauración siguen pendientes. Terminal Ubuntu, en `/srv/cooperativa` salvo que se indique Mint. Usar `sudo` para Docker.

| Síntoma | Primero comprobar | Evitar |
|---|---|---|
| Nombre no resuelve | DNS efectivo en Mint, zona BIND9, consulta A/SOA al servidor | Usar hosts o resolve como prueba final de C01. |
| Error TLS | Nombre/SAN, vigencia, CA confiada y VHost | Considerar `curl -k` prueba de confianza. |
| 502 o conexión rechazada | Apache, puerto local y contenedor WordPress | Cambiar contraseñas sin revisar logs. |
| Error BD | bd saludable, nombre de servicio, base/usuario configurados y logs | Usar localhost o borrar volúmenes para probar suerte. |
| Bucles HTTPS | Dominio/URL y protocolo reenviado por Apache | Agregar cambios sin identificar redirecciones. |
| Imagen o plugin desaparece | Volumen de WordPress y respaldo de archivos | Restaurar solo SQL y asumir recuperación total. |
| FTP autentica pero no transfiere | Permisos, chroot, TLS y puertos pasivos | Abrir todos los permisos o todos los puertos. |
| Cron no produce copia | Servicio, rutas absolutas, entorno, permisos y log | Dar por probada la tarea porque funciona manualmente. |

```bash
sudo docker compose ps
sudo docker compose logs --tail 50 bd wordpress
sudo docker compose exec wordpress getent hosts bd
sudo apache2ctl configtest
sudo apache2ctl -S
sudo ss -tlnp
```

Revisar la salida antes de publicarla. No guardar `.env`, inspecciones que incluyan contraseñas ni dumps en los registros públicos.

## Reinicio y actualizaciones

Documentar arranque de servicios y política de reinicio de contenedores. Antes de cambios, producir respaldo verificado y registrar versiones reales. Probar la actualización y su reversión en copia aislada; no actualizar tema/plugins justo antes de la presentación. Registrar diferencia entre tag/digest de imagen y núcleo realmente presente en el volumen.

Docker y Apache están habilitados al arranque; los dos servicios usan `restart: unless-stopped`. Tras reiniciar esperar los estados `healthy` antes de navegar: se observó un 503 transitorio mientras Docker arrancaba, seguido de recuperación automática sin ejecutar `up` manualmente. Un contenedor detenido deliberadamente con `stop` no se reiniciará solo bajo esa política: iniciar con `sudo docker compose start` o `up -d --wait`.

Para recrear sin borrar datos: `sudo docker compose up -d --force-recreate --wait`. No ejecutar `down -v`, `docker system prune --volumes` ni eliminar discos. El volumen conserva datos, pero no sustituye el respaldo pendiente de C05.

Credenciales: `.env` (600, administrador Linux) y `credenciales/admin.env` (600, root). Consultar con `sudo less` dentro de Ubuntu, sin grabar la pantalla; no pegar la salida en GitHub. Las claves TLS están en `/etc/ssl/private/cooperativa`. La CA pública instalada en Mint puede compartirse después de verificar su huella; nunca copiar la clave privada de la CA al cliente.

## Incidencias

| Fecha | Síntoma | Evidencia | Causa comprobada | Corrección | Reprueba |
|---|---|---|---|---|---|
| 23-24/10/2026 | Kernel Ubuntu con `soft lockup`, SSH intermitente; Mint también se atascó al arrancar | Consola y logs locales de las copias; registros T02/T03 | El bloqueo del kernel se observó; VirtualBox usaba NEM sobre el hipervisor de Windows. No se demostró una única causa raíz | Prueba autorizada con 1 CPU en cada copia, conservando RAM, MAC, red y archivos de Axel. Descargas seriales | T02/T03 y reinicio técnico satisfactorios con 1 CPU; comprobar en cada host |
| 24/10/2026 | WordPress `exec format error` | Inspección de `/bin/sh` y `/bin/bash`: tamaño 0 en la imagen extraída | Archivos vacíos, observados después de bloqueos/apagados forzados | Retirar solo contenedor e imagen WordPress y descargar otra vez el mismo digest; conservar volúmenes | PHP 8.3.36 ejecutó; WordPress saludable y T03 satisfactorio |
| 24/10/2026 | `sendmail: not found` al inicializar WP | Salida de inicialización local | No hay servicio de correo en la imagen | Se comprobó la instalación y login; no se añadió SMTP fuera del alcance | Login 200 y panel autenticado |

No se desactivó Hyper-V/VBS ni se cambió el arranque de Windows, Node o WSL. El ajuste de CPU afecta únicamente las copias importadas de Daniel. La OVA de origen mantiene 2 CPU. Para revertir en un host donde se haya probado su estabilidad: apagar la copia y usar `VBoxManage modifyvm NOMBRE --cpus 2`; no cambiar CPUs con la VM encendida ni presentarlo como una solución universal.

La guía de Oracle documenta problemas de rendimiento al combinar VirtualBox e Hyper-V, pero esa referencia no prueba por sí sola la causa de estos bloqueos. Ver [fuentes](referencias.md). El criterio de continuidad aquí es el resultado de las pruebas y del reinicio con la configuración registrada, no una promesa de estabilidad indefinida.
