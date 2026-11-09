# Actividad 8 — Preguntas de análisis

### 1. ¿El intento de `soporte_ana` causó algún daño? ¿Por qué debe auditarse de todos modos?

No causó ningún daño porque PostgreSQL rechazó la operación al detectar que `soporte_ana` no tenía los permisos necesarios. Aun así, debe registrarse porque es importante saber qué acciones intentan realizar los usuarios, incluso cuando no tienen éxito. Esto ayuda a detectar posibles errores, intentos de acceso indebido o actividades sospechosas.

### 2. ¿Qué diferencia hay entre un error de autorización (esta actividad) y uno de autenticación (Actividad 5)?

La autenticación ocurre cuando PostgreSQL comprueba la identidad del usuario y verifica si sus credenciales son correctas. Si la contraseña es incorrecta, no permite iniciar sesión.

La autorización ocurre después de iniciar sesión y consiste en comprobar si ese usuario tiene permiso para realizar una acción. En esta actividad, `soporte_ana` pudo conectarse, pero PostgreSQL rechazó la operación porque no tenía los permisos necesarios.

### 3. ¿Qué indica el error de `DROP ROLE` sobre el orden correcto para dar de baja a un usuario?

Indica que no se puede eliminar directamente un usuario si todavía tiene permisos, dependencias u objetos relacionados dentro de la base de datos. Primero se deben revisar y retirar sus privilegios, transferir o eliminar los objetos que le pertenecen y resolver sus dependencias. Después de eso se puede ejecutar `DROP ROLE` para eliminarlo correctamente.