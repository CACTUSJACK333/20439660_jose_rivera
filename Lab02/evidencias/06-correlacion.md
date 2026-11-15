### Actividad 6 — Correlacionar un cambio de configuración con su autor

**1. ¿Qué usuario cambió la configuración del perfilador? ¿Qué dos eventos lo demuestran?**

El usuario fue `admin`. Esto se comprueba con dos eventos de la bitácora: el primero es `Successfully authenticated`, que muestra que el usuario `admin` inició sesión en la conexión `conn31`; el segundo es `Profiler settings changed`, que muestra que esa misma conexión modificó la configuración del perfilador.

**2. ¿Qué condición debe cumplirse para que esta correlación sea válida?**

Los dos eventos deben pertenecer a la misma sesión del servidor, es decir, deben compartir el mismo identificador de conexión y corresponder al mismo periodo de ejecución del servidor. Si MongoDB se reinicia, los identificadores de conexión pueden volver a empezar, por lo que no se deben relacionar eventos de diferentes ejecuciones usando solamente el número de conexión.

**3. ¿Por qué es relevante que quede registrado un cambio de configuración del propio mecanismo de registro?**

Porque permite saber quién modificó la forma en que se registran las operaciones y cuándo lo hizo. Esto es importante para detectar cambios que podrían reducir la información disponible, evitar registros o dificultar una investigación. También ayuda a mantener la confianza en las evidencias de auditoría.