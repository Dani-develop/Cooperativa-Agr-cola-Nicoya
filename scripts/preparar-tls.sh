#!/usr/bin/env bash
# C02: ejecutar en Ubuntu con sudo, desde cualquier directorio.
set -euo pipefail
if [[ ${EUID} -ne 0 ]]; then
    printf '%s\n' 'Ejecutar con sudo bash scripts/preparar-tls.sh' >&2
    exit 2
fi
fuente=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
privado=/etc/ssl/private/cooperativa
ca=/usr/local/share/ca-certificates/cooperativa-nicoya-ca.crt
certificado=/etc/ssl/certs/cooperativa-nicoya.crt
if [[ -e "$privado/ca.key" || -e "$ca" || -e "$privado/servidor.key" || -e "$certificado" ]]; then
    printf '%s\n' 'Ya hay material TLS. No se reemplaza: comprobar la instalación existente.' >&2
    exit 2
fi
umask 077
install -d -o root -g root -m 700 "$privado"
openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:3072 -out "$privado/ca.key"
openssl req -new -x509 -sha256 -days 3650 -key "$privado/ca.key" \
    -config "$fuente/config/tls/ca.cnf" -out "$ca"
openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:3072 -out "$privado/servidor.key"
openssl req -new -sha256 -key "$privado/servidor.key" \
    -config "$fuente/config/tls/servidor.cnf" -out "$privado/servidor.csr"
openssl x509 -req -sha256 -days 365 -in "$privado/servidor.csr" \
    -CA "$ca" -CAkey "$privado/ca.key" -CAcreateserial \
    -extfile "$fuente/config/tls/servidor.cnf" -extensions servidor -out "$certificado"
chmod 600 "$privado/ca.key" "$privado/servidor.key"
chmod 644 "$ca" "$certificado"
openssl verify -CAfile "$ca" "$certificado"
openssl x509 -in "$certificado" -noout -subject -issuer -dates -ext subjectAltName
update-ca-certificates
printf '%s\n' 'TLS generado. Falta activar Apache e instalar la CA pública en Mint.'
