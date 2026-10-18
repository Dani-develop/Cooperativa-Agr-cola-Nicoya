# Operación y diagnóstico

Estado: comandos de diagnóstico para completar con salidas reales del proyecto. Terminal Ubuntu, dentro de la carpeta del repositorio salvo que se indique otra cosa.

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
docker compose ps
docker compose logs --tail 50 bd wordpress
docker compose exec wordpress getent hosts bd
sudo apache2ctl configtest
sudo apache2ctl -S
sudo ss -tlnp
```

Revisar la salida antes de publicarla. No guardar `.env`, inspecciones que incluyan contraseñas ni dumps en los registros públicos.

## Reinicio y actualizaciones

Documentar arranque de servicios y política de reinicio de contenedores. Antes de cambios, producir respaldo verificado y registrar versiones reales. Probar la actualización y su reversión en copia aislada; no actualizar tema/plugins justo antes de la presentación. Registrar diferencia entre tag/digest de imagen y núcleo realmente presente en el volumen.

## Incidencias

| Fecha | Síntoma | Evidencia | Causa comprobada | Corrección | Reprueba |
|---|---|---|---|---|---|
| Pendiente | | | | | |
