# Contenido propuesto para el Canva (máx. 4 diapositivas de contexto, ≈ 3 min)

Basado solo en lo probado en el repo al 06/11/2026. Lo no probado no se afirma.

## Lámina 2 · El problema (ya está en el Canva, se mantiene)
- Información dispersa: WhatsApp y hojas de cálculo, sin sitio común.
- Riesgo de pérdida: ya perdieron información por una avería.
- Presupuesto limitado: casi sin dinero para licencias.

## Lámina 3 · Solución y diagrama
Insertar `Lamina3_arquitectura_16x9.png` (diagrama de la infraestructura: DNS, HTTPS, contenedores, FTP, respaldo pendiente).
Por qué software libre: GPLv2+ (WordPress), sin cuota recurrente (Wix ≈ 17–39 USD/mes anual), control de datos y respaldo. Libre ≠ costo cero: equipo, tiempo y soporte.

## Lámina 4 · Decisiones y trade-offs
- WordPress + MariaDB (libre). Ganamos: sin licencias y control de los datos. Perdimos: la comodidad de un servicio alojado; el mantenimiento es nuestro.
- Apache como proxy HTTPS. Ganamos: un solo punto TLS y backend solo en localhost. Perdimos: Compose no despliega todo; Apache queda aparte.
- CA local en lugar de CA pública. Ganamos: HTTPS sin costo, con SAN del dominio. Perdimos: confianza pública; hay que instalar la CA en cada cliente.

## Lámina 5 · Problemas reales y cómo los resolvimos
1. Bloqueos del kernel (soft lockup) en las VM → 1 CPU por copia y descargas Docker en serie.
2. WordPress con `exec format error` (binarios vacíos) → mismo digest descargado de nuevo, volúmenes intactos.
