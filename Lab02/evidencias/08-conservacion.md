# 08. Conservación: exportar antes de perder

### 1. Menciona tres formas en que la evidencia del perfilador o de la bitácora puede perderse sin que nadie la borre deliberadamente.

1. Al reiniciar MongoDB, los eventos que se encuentran en la memoria de `getLog` se pierden.
2. Cuando `system.profile` alcanza su límite de 1 MB, los registros más antiguos comienzan a sobrescribirse automáticamente.
3. Si el perfilador está desactivado o tiene un filtro, algunas operaciones no se registran y esa información ya no se puede recuperar después.

### 2. ¿Por qué el tamaño de 1 MB de `system.profile` es un problema de conservación y no solo de espacio?

Porque al llegar al límite de 1 MB, MongoDB comienza a reemplazar los registros más antiguos por los nuevos. Esto significa que una operación importante podría desaparecer sin que nadie la elimine manualmente. Por eso es necesario exportar la información periódicamente y no depender únicamente de lo que se conserva en `system.profile`.

### 3. ¿Por qué `getLog` sirve para interpretar pero no para conservar?

Porque permite consultar los eventos recientes del servidor y revisar información como conexiones, autenticaciones y errores. Sin embargo, solamente mantiene los últimos 1024 eventos en memoria y se vacía cuando MongoDB se reinicia. Por eso sirve para investigar lo que está ocurriendo, pero no como respaldo permanente de la bitácora.