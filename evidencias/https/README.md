# Evidencias C02 / T02

Ejecutadas el 24/10/2026 por Daniel en las copias de Ubuntu/Mint de Axel. Revisión de Frander pendiente. Registro: [T02-C02](../../pruebas/registros/T02-C02-2026-10-24.md). Configuración `f2520a6`; repetición con el mismo despliegue en `9f1ac00`.

| Archivo | Qué demuestra |
|---|---|
| [Servidor](C02-T02-servidor-2026-10-24.txt) | Versiones, VirtualHost, SAN/vigencia, correspondencia de clave pública, permisos y hashes conservados de Axel |
| [Confianza de Mint](C02-T02-confianza-mint-2026-10-24.txt) | Misma huella de CA pública e instalación en el cliente |
| [Prueba desde Mint](C02-T02-mint-2026-10-24.txt) | DNS normal, redirección, confianza TLS, sitio/login, backend/BD inaccesibles y archivos 403 |
| [Login autenticado](C02-T02-login-2026-10-24.txt) | Sesión HTTPS y escritorio 200, sin publicar cookies o contraseña |
| [Mint tras reinicio](C02-T02-mint-reinicio-2026-10-24.txt) | Repetición de DNS/TLS/aislamiento con el servidor reiniciado |
| [Login tras reinicio](C02-T02-login-reinicio-2026-10-24.txt) | Autenticación conservada después de recuperar los servicios |
| [Comprobación final de Mint](C02-T02-final-mint-2026-10-24.txt) | Alias www con TLS válido, entrada técnica ya en borrador y ausencia de bloqueos observados en ese arranque |
| [Panel real en Firefox](C02-T02-panel-mint-2026-10-24.png) | Dominio con conexión confiable, escritorio WordPress 7.1.3 y usuario técnico |
| [Entrada técnica en Firefox](../docker/C03-T03-entrada-mint-2026-10-24.png) | Página e imagen por el nombre real, después de recrear y reiniciar |

Las capturas son de la VM Mint mediante VirtualBox, sin reconstrucción gráfica. Las salidas se capturaron de comandos ejecutados en las VMs. La salida de T02 diferencia el panel anónimo 302 del panel autenticado 200. Las claves privadas y credenciales permanecen fuera de Git. [Índice general](../indice.md).
