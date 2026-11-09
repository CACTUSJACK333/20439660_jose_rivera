# Actividad 19 — Auditoría de objeto sobre columnas sensibles

### 1. ¿Por qué no apareció `SELECT nombre, ciudad ...`? ¿Por qué sí apareció `SELECT * ...`?

La consulta de nombre y ciudad no apareció porque esas columnas no forman parte de los permisos que se le asignaron al rol auditor_datos. En cambio, la consulta `SELECT *` sí apareció porque devuelve todas las columnas de la tabla, incluyendo el RFC y el teléfono, que son los datos que se están vigilando.

### 2. ¿Por qué no apareció `UPDATE ... ciudad ...`?

No apareció porque el rol auditor_datos solamente tiene permisos de auditoría sobre las columnas RFC y teléfono. Como la actualización solamente modificó la ciudad, no coincidió con las columnas configuradas para ser auditadas.

### 3. ¿Qué diferencia de volumen esperarías frente a `log_statement = 'all'`?

Con pgaudit se espera un menor volumen de registros porque solamente se guardan las operaciones que coinciden con los objetos y columnas que se quieren vigilar. En cambio, con `log_statement = 'all'` se registran todas las sentencias ejecutadas, incluso las que no son importantes para la auditoría. Esto puede generar muchos más registros y hacer más difícil encontrar información relevante.

### 4. El README oficial advierte que `pgaudit` no puede auditar de forma confiable a los superusuarios. ¿Qué implica para la separación de funciones?

Esto significa que no se debe dejar toda la responsabilidad de la auditoría en el mismo administrador de la base de datos. Un superusuario tiene permisos suficientes para modificar configuraciones, cambiar privilegios o desactivar mecanismos de auditoría. Por eso es importante separar las funciones y que otra persona o área independiente se encargue de revisar y conservar los registros.