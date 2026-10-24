#!/usr/bin/env python3
"""T03: verificar por HTTPS la entrada y el PNG del estado creado en Ubuntu."""
import datetime
import hashlib
import json
import pathlib
import sys
import urllib.request

estado = json.loads(pathlib.Path(sys.argv[1]).read_text())
print('Fecha UTC:', datetime.datetime.now(datetime.timezone.utc).isoformat())
with urllib.request.urlopen(estado['url'], timeout=30) as respuesta:
    html = respuesta.read().decode('utf-8')
    assert respuesta.status == 200
    assert estado['title'] in html, 'La entrada esperada no aparece'
    assert estado['image_url'] in html, 'La entrada no enlaza su imagen'
    print('entrada_http=200 url=' + respuesta.url)
with urllib.request.urlopen(estado['image_url'], timeout=30) as respuesta:
    datos = respuesta.read()
    assert respuesta.status == 200
    assert respuesta.headers.get_content_type() == 'image/png'
    huella = hashlib.sha256(datos).hexdigest()
    assert huella == estado['file_sha256'], 'PNG diferente al anterior'
    print('imagen_http=200 sha256=' + huella + ' bytes=' + str(len(datos)))
print('T03_LECTURA_HTTPS_OK (sin excepcion TLS ni resolucion forzada)')
