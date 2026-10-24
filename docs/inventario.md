# Inventario real del proyecto

Observado al continuar las VMs de Axel, 23-24/10/2026. Daniel conserva las redes, las MAC y los archivos de BIND9/DHCP/Netplan. Evidencia de versiones, servicios y hashes en [HTTPS](../evidencias/https/README.md) y [Docker](../evidencias/docker/README.md).

| Dato | Propuesto | Observado | Fecha/evidencia |
|---|---|---|---|
| Cinco integrantes | Confirmados como grupo | Nombres por asignar | |
| Equipo principal y responsable | Por asignar | Daniel: copias importadas en Windows, Ryzen 5 5500 y 16 GB RAM | 24/10/2026 |
| Equipo de reproducción | Otro integrante | Pendiente | |
| Ubuntu y kernel | Misma base compatible con el curso | Ubuntu 26.04 LTS; 7.0.0-38-generic | 23-24/10/2026 |
| VirtualBox y Mint | Herramientas del grupo | VirtualBox 7.2.12r174389; Mint 22.3 Zena, kernel 6.14.0-37-generic | 23-24/10/2026 |
| RAM, CPU y disco VM | A dimensionar | 4096 MB cada VM; discos dinámicos 25 GB servidor y ~20 GB Mint; heredadas 2 CPU cada una, prueba autorizada con 1 CPU en ambas copias | [Incidencia](07-operacion-y-diagnostico.md#incidencias) |
| Interfaz NAT Ubuntu | Identificar | enp0s3, 10.0.2.15/24, gateway 10.0.2.2 | 23/10/2026 |
| Interfaz interna Ubuntu | Identificar | enp0s8, cooperativa-net | 23/10/2026 |
| IP Ubuntu | 192.168.50.1 | 192.168.50.1/24 estática, heredada | 23-24/10/2026 |
| IP Mint | 192.168.50.2 | 192.168.50.100/24 por DHCP, enp0s3 | 23-24/10/2026 |
| Gateway/DNS efectivo de Mint | Diseñar | NAT enp0s8: 10.0.3.2, métrica 101; interna: gateway/DNS 192.168.50.1, métrica 20100 | No se cambió la red de Axel |
| Dominio | cooperativa.internal | cooperativa.internal y www.cooperativa.internal; zona serial 2026102201 | 23-24/10/2026 |
| Puerto backend | 127.0.0.1:8082 | WordPress 127.0.0.1:8082 → 80; BD sin publicación al host | T02/T03 |
| Versiones Docker/Compose | Verificar | Engine 29.9.2; Compose 5.6.1 | T02/T03 |
| WordPress/PHP imagen | wordpress:7.1.3-php8.3-apache | Núcleo 7.1.3, PHP 8.3.36; digest en .env.example y T03 | 24/10/2026 |
| MariaDB imagen | mariadb:11.8.9 | 11.8.9-MariaDB-ubu2404; digest en .env.example y T03 | 24/10/2026 |
| Apache/BIND9/vsftpd/Cron | En el host | Apache host 2.4.66 Ubuntu; Apache contenedor 2.4.69 Debian; BIND 9.20.24 heredado. FTP/Cron de proyecto pendientes | 24/10/2026 |
| Ruta del repositorio en Ubuntu | Acordar | /srv/cooperativa, rama feature/c02-c03-wordpress-daniel | 24/10/2026 |
| Destino de respaldo | /srv/respaldos-cooperativa | Pendiente | |
| Destino externo | Otro equipo | Pendiente | |
| Cuentas FTP y WordPress | Ver guías | daniel_admin, administrador técnico WP. FTP y roles editoriales pendientes | Credencial privada en credenciales/admin.env |

No registrar contraseñas, claves privadas ni contenido de `.env` en este archivo.

En VirtualBox las copias se llaman `cooperativa-server-daniel` y `cooperativa-mint-daniel`, en `C:\Users\josed\Desktop\Cooperativa\VMs-Daniel`. Los hostnames internos siguen siendo los de Axel. SSH por loopback Windows: 2224 servidor y 2225 Mint. No encender otra pareja con las mismas IP/MAC en `cooperativa-net`.

MAC conservadas: servidor NAT `080027BDA723`, interna `080027651E1F`; Mint interna `080027856483`, NAT `08002730E41D`. La OVA de origen y sus configuraciones permanecen conservadas en `ova.zip` fuera del repositorio.
