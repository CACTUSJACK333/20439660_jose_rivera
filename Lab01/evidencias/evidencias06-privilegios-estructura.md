# Actividad 6 — Registro de cambios y privilegios

### 1. ¿Qué tipo de evento es cada una de las tres primeras sentencias (privilegio o estructura)?

Las sentencias se pueden clasificar dependiendo de lo que hacen:

- `GRANT`: es un evento de privilegios porque concede permisos a un usuario o rol.
- `REVOKE`: es un evento de privilegios porque retira permisos que anteriormente se habían concedido.
- `CREATE TABLE`: es un evento de estructura porque crea una nueva tabla dentro de la base de datos.

### 2. ¿Por qué `GRANT` y `REVOKE` quedan registrados con `log_statement = 'ddl'`?

Porque PostgreSQL considera estas instrucciones como parte de las sentencias de definición de datos (DDL), ya que modifican los permisos y la configuración de acceso a los objetos de la base de datos. Por eso quedan registradas cuando se utiliza `log_statement = 'ddl'`.

### 3. Si la bitácora contiene contraseñas, ¿quién debería poder leerla?

Solamente el DBA y el personal de seguridad o auditoría que tenga autorización deberían poder consultar la bitácora. Esto es importante porque puede contener información sensible, como contraseñas, usuarios y consultas ejecutadas. Los usuarios normales de la aplicación no deberían tener acceso.