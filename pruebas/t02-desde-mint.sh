#!/usr/bin/env bash
# C02: ejecutar en Mint con su DNS normal y la CA pública ya confiada.
set -euo pipefail
printf 'Fecha Costa Rica: '; TZ=America/Costa_Rica date --iso-8601=seconds
hostname
getent hosts cooperativa.internal
dig +short cooperativa.internal A
if grep -q 'cooperativa.internal' /etc/hosts; then
    echo 'FALLO: revisar entrada del dominio en hosts'; exit 1
fi
tmp=$(mktemp -d)
trap 'rm -rf -- "$tmp"' EXIT
curl -sS --max-time 20 -I http://cooperativa.internal/ > "$tmp/redirect"
cat "$tmp/redirect"
grep -q '^HTTP/1.1 301' "$tmp/redirect"
grep -qi '^Location: https://cooperativa.internal/' "$tmp/redirect"
curl --fail -sS --max-time 30 -o "$tmp/inicio" \
    -w 'inicio_http=%{http_code} tls_verify=%{ssl_verify_result}\n' https://cooperativa.internal/
grep -o 'Cooperativa Agricola Nicoya' "$tmp/inicio" | head -1
curl --fail -sS --max-time 30 -o "$tmp/login" \
    -w 'login_http=%{http_code}\n' https://cooperativa.internal/wp-login.php
grep -o 'id="loginform"' "$tmp/login"
curl -sS --max-time 20 -I https://cooperativa.internal/wp-admin/ > "$tmp/panel"
cat "$tmp/panel"
grep -q '^HTTP/1.1 302' "$tmp/panel"
grep -qi '^Location: https://cooperativa.internal/wp-login.php' "$tmp/panel"
openssl s_client -connect cooperativa.internal:443 -servername cooperativa.internal \
    -verify_hostname cooperativa.internal -verify_return_error </dev/null > "$tmp/tls" 2>&1
grep -E 'subject=|issuer=|Verification:|Verify return code|Protocol|Cipher' "$tmp/tls"
for puerto in 8082 3306; do
    if curl -sS --connect-timeout 3 --max-time 5 "http://192.168.50.1:$puerto/" >/dev/null; then
        echo "FALLO: puerto directo $puerto accesible"; exit 1
    fi
    echo "CORRECTO: puerto directo $puerto inaccesible desde Mint"
done
for ruta in wp-config.php .env .git/config; do
    codigo=$(curl -sS --max-time 15 -o /dev/null -w '%{http_code}' "https://cooperativa.internal/$ruta")
    echo "$ruta http=$codigo"
    test "$codigo" = 403
done
echo 'T02_RED_TLS_AISLAMIENTO_OK (login autenticado se verifica por separado)'
