# Actividad 3 — El incidente sin bitácora

### 1. ¿Puedes demostrar quién modificó el RFC?

No puedo demostrarlo completamente porque no tenemos un registro de auditoría que guarde quién realizó la modificación. Aunque ejecuté el cambio utilizando el usuario `app_ventas`, no tengo una evidencia guardada en la bitácora que permita comprobarlo.

### 2. ¿Puedes demostrar que el cambio no lo hizo `soporte_ana`?

No, porque al no tener registros de las conexiones y operaciones realizadas, no podemos asegurar que `soporte_ana` no haya participado. La falta de registros hace que no podamos comprobar quién realizó o no realizó el cambio.

### 3. Los privilegios de la Unidad II, ¿impidieron el cambio? ¿Debían impedirlo?

No impidieron el cambio porque el usuario `app_ventas` tenía permisos para actualizar los datos de la tabla `clientes`, por lo que PostgreSQL permitió realizar la operación. En este caso no debían impedirlo, ya que la aplicación necesita modificar ciertos datos para funcionar. Lo importante es que cada usuario tenga únicamente los permisos que necesita.

### 4. ¿Qué tendría que haber estado configurado antes del incidente?

Antes del incidente debían estar configuradas las bitácoras para registrar las conexiones, desconexiones y consultas ejecutadas en PostgreSQL. También era importante registrar información como el usuario, la base de datos, la dirección IP y la aplicación desde la que se realizó la operación. De esta manera habría sido posible revisar los registros y tener evidencia de quién realizó el cambio.