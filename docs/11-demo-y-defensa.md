# Demo y defensa

Estado: guion por ensayar. Ajustar duración cuando el profesor la indique. Todos los integrantes deben poder explicar y operar el proyecto.

## Recorrido propuesto

1. Problema de la cooperativa y diagrama del diseño.
2. DNS real y acceso HTTPS desde Mint; contenido, menú y galería.
3. Autor publica lo propio e intenta una operación ajena denegada; Editor administra contenido permitido.
4. FTP: archivo propio y modificación/borrado ajeno denegados.
5. Contenedores, versiones, volúmenes y ausencia de publicación de 3306.
6. Ejecución de Cron y recuperación en entorno aislado preparado.
7. Decisiones, costos, limitaciones y reproducción con la guía.

## Preguntas a preparar

- ¿Cómo responde cada componente al problema del caso?
- ¿Qué diferencia un volumen de un respaldo y qué perderíamos restaurando solo SQL?
- ¿Cómo sabemos que respondió BIND9 y no una entrada en hosts?
- ¿Por qué Apache en el host y qué exige HTTPS detrás de un proxy?
- ¿Cómo se conserva el estado de WordPress y cómo se verifica su versión real?
- ¿Qué capacidades tiene Editor que Autor no debe tener?
- ¿Qué impide borrar archivos de otro usuario FTP?
- ¿Cómo se prueba Cron sin depender de la terminal del administrador?
- ¿Qué ocurre tras reiniciar Ubuntu o perder la VM?
- ¿Qué costos existen aunque no se paguen licencias?

## Preparación

Imágenes Docker y medios disponibles localmente; servicios comprobados antes de exponer; credenciales distribuidas de forma privada; copia probada en otro equipo. La demo no debe depender de instalar plugins o descargar paquetes ese día. Rotar quién explica cada capa durante los ensayos.

| Ensayo | Fecha | Participantes | Fallos | Correcciones y repetición |
|---|---|---|---|---|
| Pendiente | | | | |
