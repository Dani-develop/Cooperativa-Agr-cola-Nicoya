# Cooperativa Agrícola Nicoya

Proyecto del curso **EIF431O - Administración de Servidores basados en Software Libre**, Universidad Nacional, Campus Nicoya. Escenario 1: WordPress.

Un portal agrícola administrado por las oficinas de campo y la administración de la cooperativa, con publicación por roles, transferencia de archivos aislada y recuperación mediante respaldos.

**Estado de esta rama al 24/10/2026:** continúa el trabajo de Axel (`feature/c01-dns-axel`, base `c265221`). C01 conserva su aprobación y sus archivos. Daniel incorpora C02/C03: WordPress y MariaDB en Docker, volúmenes persistentes y Apache HTTPS, con pruebas desde Mint. La revisión humana de Frander sigue pendiente. FTP, Cron/restauración, personalización, contenido, plugin, roles y reproducción independiente todavía no están aceptados.

## Empezar aquí

1. Leer [contexto y alcance](docs/00-contexto-y-alcance.md).
2. Revisar la [matriz de requisitos y rúbrica](docs/01-requisitos.md).
3. Consultar la [arquitectura propuesta](docs/02-arquitectura.md).
4. Discutir el [plan inicial del 18 al 20 de octubre](docs/12-plan-18-20-octubre.md).
5. Completar el [inventario real](docs/inventario.md) antes de desplegar.
6. Desarrollar y comprobar la [guía de instalación](docs/03-guia-instalacion.md) por bloques.
7. Para continuar las VMs de Axel con el trabajo de Daniel: [procedimiento y traspaso C02/C03](docs/13-daniel-wordpress-https.md), [resultados](docs/08-pruebas-y-resultados.md) y [evidencias](evidencias/indice.md).

La entrega está prevista para el **7 de noviembre de 2026**: infraestructura funcionando, documento técnico y presentación. Ver [entregables](entregables/README.md).

## Arquitectura

```mermaid
flowchart LR
    M[Cliente Mint] -->|DNS 53 TCP/UDP| D[BIND9 en Ubuntu]
    M -->|HTTPS 443| A[Apache en Ubuntu]
    A -->|localhost 8082| W[WordPress en Docker]
    W -->|bd:3306| B[MariaDB en Docker]
    W --- V1[Volumen de archivos]
    B --- V2[Volumen de base de datos]
    M -->|FTP con TLS| F[vsftpd: directorio por usuario]
    C[Cron en Ubuntu] --> R[Respaldo BD y archivos]
    R --> O[Copia protegida en otro equipo]
```

Dominio efectivo: `cooperativa.internal`. Ubuntu `192.168.50.1`, Mint `192.168.50.100` por DHCP y backend `127.0.0.1:8082`. Las copias se llaman `cooperativa-server-daniel` y `cooperativa-mint-daniel`; conservan la red interna y las MAC de Axel. El diagrama incluye FTP y respaldos como objetivo pendiente. Consultar el [inventario](docs/inventario.md) antes de encender otra pareja con las mismas direcciones.

## Qué contiene el repositorio

| Ruta | Propósito |
|---|---|
| [docs/](docs/README.md) | Procedimientos, requisitos, decisiones y defensa. |
| [config/](config/README.md) | Fuentes de configuración de BIND9, Apache, FTP y Cron. |
| [compose.yaml](compose.yaml) | Dos servicios probados, imágenes fijadas por digest y volúmenes con nombre. |
| [.env.example](.env.example) | Variables explicadas y credenciales vacías. |
| [scripts/](scripts/README.md) | Inventario, emisión TLS e inicialización técnica; respaldo/restauración pendientes. |
| [contenido/](contenido/README.md) | Textos, medios autorizados y registro editorial. |
| [pruebas/](pruebas/casos.md) | Pruebas permitidas/denegadas y criterios de aceptación. |
| [evidencias/](evidencias/indice.md) | Índice de evidencias por requisito, prueba y commit. |
| [entregables/](entregables/README.md) | Documento técnico y presentación para Aula Virtual. |

El inventario **de solo lectura** es `bash scripts/preflight.sh`, dentro de Ubuntu. `preparar-tls.sh` y `bootstrap-wordpress.sh` se implementaron para la instalación inicial; se niegan a reemplazar material TLS o un sitio ya existente. Los scripts de respaldo, restauración y verificación integral siguen deshabilitados con salida 2.

`compose.yaml` requiere variables y contraseñas locales. El sitio técnico conserva la apariencia y los ejemplos iniciales de WordPress; eso no acredita los requisitos editoriales E01-E05. No publicar `.env`, claves, cookies, la BD ni las VMs. No usar `down -v` en la pareja de continuidad.

## Forma de trabajo

- Cada cambio se vincula a un requisito C01-C06 o E01-E06.
- Cada paso registra máquina, comandos, resultado esperado, prueba y consideraciones; usar la [plantilla de paso](docs/plantilla-paso.md).
- Todos documentan su área y un compañero reproduce sus pasos. Consultar [cómo contribuir](CONTRIBUTING.md).
- Una tarea se considera verificada cuando tiene resultado y evidencia; instalar un paquete no basta.
- Las credenciales, claves privadas, dumps y VMs se conservan fuera de Git. Ver [.gitignore](.gitignore).

## Fases propuestas

| Fechas | Resultado |
|---|---|
| 18-20 octubre | Alcance, inventario, responsables y preparación del entorno. |
| 21-24 octubre | DNS, Docker y HTTPS funcionando desde Mint. |
| 25-28 octubre | Personalización, contenido, roles y FTP. |
| 29 octubre-1 noviembre | Cron, respaldo y restauración comprobados. |
| 2-4 noviembre | Reproducción desde cero por otro integrante. |
| 5-6 noviembre | Documento, presentación y ensayo. |
| 7 noviembre | Entrega y demo en vivo. |

El [registro de decisiones, costos y licencias](docs/09-decisiones-costos-y-licencias.md) distingue obligaciones del enunciado y mejoras propuestas. Las [referencias](docs/referencias.md) identifican las fuentes académicas y técnicas.
