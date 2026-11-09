## Análisis de la configuración de bitácoras de PostgreSQL

### 1. Con esta configuración, ¿se registra quién se conecta?

No necesariamente. El parámetro `log_connections` aparece con el valor `default`, por lo que no podemos asegurar que se estén registrando las conexiones. Para que PostgreSQL registre cuándo un usuario se conecta, es necesario habilitarlo con `log_connections = on`.

### 2. ¿Se registran las sentencias `UPDATE`?

No. El parámetro `log_statement` tiene el valor `none`, lo que significa que PostgreSQL no registra las sentencias SQL ejecutadas de manera general. Para registrar las modificaciones, se podría configurar `log_statement = 'mod'`, que incluye instrucciones como `INSERT`, `UPDATE`, `DELETE` y `TRUNCATE`.

### 3. ¿La línea de bitácora incluye el usuario o la dirección IP del cliente?

No con la configuración actual. El parámetro `log_line_prefix` tiene el valor `%t`, que únicamente muestra la hora en que ocurrió el evento. Para incluir información del usuario y del cliente se pueden utilizar los códigos `%u` para el usuario, `%h` para la dirección IP y `%d` para la base de datos.

### 4. ¿En qué zona horaria se registran los eventos? ¿Por qué importa al reconstruir una cronología?

Los eventos se registran utilizando la zona horaria `America/Chihuahua`. Esto es importante porque permite relacionar los eventos con la hora local en que ocurrieron. Al investigar un incidente, tener una zona horaria definida ayuda a ordenar los acontecimientos y compararlos con otros registros del sistema. Si se utilizan diferentes zonas horarias, pueden existir confusiones al reconstruir lo sucedido.

### 5. Con `logging_collector = off`, ¿quién decide dónde termina la bitácora: PostgreSQL o el mecanismo con que se desplegó el servidor?

Cuando `logging_collector = off`, PostgreSQL no administra directamente los archivos de bitácora mediante su recolector. En ese caso, los registros se envían al flujo de errores estándar (`stderr`) y el destino final depende del mecanismo con el que se inició o desplegó el servidor, por ejemplo, el sistema operativo, un servicio o un contenedor.

En cambio, cuando `logging_collector = on`, PostgreSQL puede encargarse de guardar los registros en archivos dentro del directorio configurado.