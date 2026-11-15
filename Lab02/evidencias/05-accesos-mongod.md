### Actividad 5 — Accesos en la bitácora de mongod

**1. ¿Qué campo distingue un acceso fallido de uno exitoso?**

El campo `msg` permite distinguirlos, ya que muestra si la autenticación fue exitosa o fallida. También se puede revisar el campo `result`: el valor `0` indica que fue exitoso, mientras que los valores `18` y `11` indican errores de autenticación.

**2. ¿Qué diferencia hay entre el error de contraseña incorrecta y el de usuario inexistente? ¿Por qué el cliente recibe el mismo mensaje en ambos casos?**

La contraseña incorrecta significa que el usuario sí existe, pero los datos de autenticación no coinciden. En cambio, el usuario inexistente significa que MongoDB no encontró esa cuenta en la base de datos indicada.

El cliente recibe un mensaje parecido en ambos casos para no revelar información sobre qué usuarios existen en el servidor, lo que ayuda a evitar que alguien pueda identificar cuentas válidas.

**3. ¿Por qué el nombre de la aplicación del intento fallido es `mongosh 2.10.0` y no `app-ventas-web`?**

Porque el intento fallido se realizó directamente desde la terminal utilizando `mongosh`, sin conectarse mediante la aplicación de ventas. Por eso MongoDB registra el nombre de `mongosh` como aplicación cliente. En cambio, cuando se conecta el usuario `app_ventas` utilizando el nombre de aplicación configurado en la conexión, aparece `app-ventas-web`.