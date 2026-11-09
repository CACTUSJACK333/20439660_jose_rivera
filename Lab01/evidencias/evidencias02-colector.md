## Actividad 2 — Preguntas de análisis

### 1. ¿Por qué `logging_collector` requiere reinicio y `log_statement` solo recarga?

Porque `logging_collector` controla el proceso encargado de recopilar y guardar los registros de PostgreSQL, por lo que necesita iniciar nuevamente cuando se modifica esta configuración. En cambio, `log_statement` solamente indica qué tipo de consultas se deben registrar, así que sus cambios pueden aplicarse recargando la configuración sin reiniciar todo el servidor.

### 2. ¿Qué ventaja tiene que la bitácora se lea con SQL y no con una herramienta del sistema operativo o del contenedor? ¿Qué riesgo introduce?

La ventaja es que podemos consultar la bitácora directamente desde PostgreSQL mediante una vista, en este caso `dba.bitacora`. Esto permite buscar, filtrar y revisar los registros utilizando consultas SQL, sin tener que abrir directamente el archivo desde el sistema operativo.

El riesgo es que la vista puede mostrar información sensible, como usuarios, consultas ejecutadas y actividades realizadas en la base de datos. Si se dan permisos a personas que no deberían tenerlos, podrían consultar información que debería mantenerse protegida.

### 3. ¿Quién debería poder consultar `dba.bitacora`?

Solamente el DBA y el personal de auditoría o seguridad que tenga autorización deberían poder consultar `dba.bitacora`. Los usuarios normales de la aplicación no necesitan acceder a esta información, ya que la bitácora contiene detalles sobre las actividades realizadas en PostgreSQL y podría exponer información sensible.