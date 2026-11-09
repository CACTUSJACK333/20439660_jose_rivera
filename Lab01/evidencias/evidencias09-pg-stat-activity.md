# Actividad 9 — Preguntas de análisis

### 1. ¿Qué columna permite relacionar una sesión con sus líneas de bitácora?

La columna `pid` permite relacionar una sesión con sus líneas de bitácora, porque contiene el identificador del proceso de PostgreSQL que atendió esa conexión. De esta manera podemos comparar el PID de una sesión con el que aparece en los registros.

### 2. Después de que termina el reporte, ¿qué fuente conserva evidencia de que existió?

La bitácora del servidor conserva evidencia de las actividades realizadas durante el reporte, como las conexiones y las consultas ejecutadas, siempre que esas operaciones estén incluidas en la configuración de registro. Aunque la sesión termine, los registros permanecen guardados en los archivos de PostgreSQL.

### 3. ¿Por qué `client_addr` aparece vacío en la sesión del administrador?

Porque la sesión del administrador puede estar conectada mediante un socket local y no mediante una conexión TCP/IP. En ese caso PostgreSQL no tiene una dirección IP del cliente que mostrar y el valor de `client_addr` aparece como `NULL`.