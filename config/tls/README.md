# Certificados de C02

`ca.cnf` y `servidor.cnf` son fuentes públicas de OpenSSL. Las claves privadas y el certificado emitido se generan **en Ubuntu**, mediante `sudo bash scripts/preparar-tls.sh`. No se guardan en Git.

| Objeto | Ruta en Ubuntu | Propietario y modo |
|---|---|---|
| Clave de la CA | `/etc/ssl/private/cooperativa/ca.key` | root, 600 |
| Clave del servidor | `/etc/ssl/private/cooperativa/servidor.key` | root, 600 |
| CA pública | `/usr/local/share/ca-certificates/cooperativa-nicoya-ca.crt` | root, 644 |
| Certificado del servidor | `/etc/ssl/certs/cooperativa-nicoya.crt` | root, 644 |

La CA es exclusiva del laboratorio. Su certificado público se instala en Mint y Firefox; **nunca** se copia su clave al cliente. Una reproducción independiente genera su propia CA. La OVA de continuidad conserva la CA existente para mantener su confianza.

El script no reemplaza una CA ya generada ni cambia BIND9. Antes de activar Apache se comprueban la cadena, el SAN `cooperativa.internal`/`www.cooperativa.internal` y la correspondencia entre certificado y clave. Reproducción y pruebas: [guía C02 y C03](../../docs/13-daniel-wordpress-https.md).
